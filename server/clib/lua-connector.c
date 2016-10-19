#include <lua.h>
#include <lauxlib.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "skynet_malloc.h"
#include "skynet_socket.h"
#include "skynet_socket.h"
#include "lua-seri.h"

struct data_buffer {
	struct data_buffer* next;
	void* data;
	int size;
	int offset;
};

struct collect_data {
	int need;
	int size;
	struct data_buffer* head;
	struct data_buffer* tail;
	struct data_buffer* freelist;
};

#define BUFFER_LEFT(B) (B->size - B->offset)
#define BUFFER_NEXT(CD,B) do{\
							CD->head = B->next;\
							free(B->data);\
							B->data = NULL;\
							B->size = 0;\
							B->offset = 0;\
							B->next = CD->freelist;\
							CD->freelist = B;\
					   }while(0)
int
read_bytes(struct collect_data* cd,int size,char* data) {
	if (cd->size < size)
		return -1;

	cd->size -= size;

	int left = size;
	while(left > 0) {
		struct data_buffer* buffer = cd->head;
		if (BUFFER_LEFT(buffer) >= left) {
			memcpy(data+(size-left),buffer->data+buffer->offset,left);
			buffer->offset += left;
			left -= left;
			if (buffer->offset == buffer->size)
				BUFFER_NEXT(cd,buffer);
		} else {
			memcpy(data+(size-left),buffer->data+buffer->offset,BUFFER_LEFT(buffer));
			left -= BUFFER_LEFT(buffer);
			buffer->offset = buffer->size;
			BUFFER_NEXT(cd,buffer);
		}
	}
	if (cd->head == NULL)
		cd->head = cd->tail = NULL;
	
	return 0;
}

int
_create(lua_State* L) {
	struct collect_data* cd = malloc(sizeof(*cd));
	cd->need = 0;
	cd->size = 0;
	cd->head = cd->tail = cd->freelist = NULL;
	lua_pushlightuserdata(L,cd);
	return 1;
}

int
_release(lua_State* L) {
	struct collect_data* cd = lua_touserdata(L, 1);
	while(cd->head != NULL) {
		struct data_buffer* buffer = cd->head;
		cd->head = cd->head;
		free(buffer->data);
		free(buffer);
	}
	while(cd->freelist != NULL) {
		struct data_buffer* buffer = cd->freelist;
		cd->freelist = cd->freelist->next;
		free(buffer);
	}
	free(cd);
	return 0;
}

int
_collect(lua_State* L) {
	struct collect_data* cd = lua_touserdata(L, 1);
	void* data = lua_touserdata(L, 2);
	int size = luaL_checknumber(L, 3);

	struct data_buffer * buffer = NULL;
	if (cd->freelist != NULL) {
		buffer = cd->freelist;
		cd->freelist = cd->freelist->next;
	} else {
		buffer = malloc(sizeof(*buffer));
	}
	buffer->data = data;
	buffer->size = size;
	buffer->offset = 0;
	buffer->next = NULL;

	if (cd->head == NULL) {
		cd->head = cd->tail = buffer;
	} else {
		cd->tail->next = buffer;
		cd->tail = buffer;
	}
	cd->size += size;

	lua_createtable(L,0,0);
	int index = 1;

	if (cd->need > 0) {
label_again0:
		if (cd->need <= cd->size) {
			char* data = malloc(cd->need);
			read_bytes(cd,cd->need,data);;

			lua_pushcfunction(L,luaseri_unpack);
			lua_pushlightuserdata(L,data);
			lua_pushinteger(L,cd->need);
			if (lua_pcall(L, 2, 1, 0) != LUA_OK) {
				free(data);
				luaL_error(L,"luaseri_unpack:%s\n",lua_tostring(L,-1));
				return 0;
			}
			free(data);
			lua_rawseti(L, -2, index++);
			cd->need = 0;
			goto label_again1;
		} else {
			return 1;
		}
	} else {
label_again1:
		if (cd->size > 2) {
			char tmp[2] = {0};
			read_bytes(cd,2,tmp);
			cd->need = (tmp[0] << 8) | tmp[1];
			goto label_again0;
		} else {
			return 1;
		}
	}
}

int
_send(lua_State *L) {
	struct skynet_context * ctx = lua_touserdata(L, lua_upvalueindex(1));
	int id = luaL_checkinteger(L, 1);
	void* buffer = lua_touserdata(L,2);
	int sz = luaL_checkinteger(L,3);

	char* data = malloc(sz + 2);
	data[0] = sz >> 8;
	data[1] = sz & 0xff;
	memcpy(&data[2],buffer,sz);

	free(buffer);

	int err = skynet_socket_send(ctx, id, data, sz + 2);
	lua_pushboolean(L, !err);
	return 1;
}

int luaopen_connector_core(lua_State *L) {
	luaL_Reg l[] = {
		{ "create", _create },
		{ "release", _release },
		{ "collect", _collect },
		{ "send", _send },
		{ NULL, NULL },
	};
	luaL_newlib(L,l);
	lua_getfield(L, LUA_REGISTRYINDEX, "skynet_context");
	struct skynet_context *ctx = lua_touserdata(L,-1);
	if (ctx == NULL) {
		return luaL_error(L, "Init skynet context first");
	}

	luaL_setfuncs(L,l,1);

	return 1;
}