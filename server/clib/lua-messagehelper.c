#include <lua.h>
#include <lauxlib.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include "skynet_malloc.h"


int
_xor_encrypt(lua_State *L) {
	int index;
	char * ptr;
	char * result;
	size_t size;
	if (lua_isuserdata(L,1)) {
		ptr = (char *)lua_touserdata(L,1);
		size = luaL_checkinteger(L, 2);
		result = ptr;
		index = 3;
	} else {
		ptr = (char *)luaL_checklstring(L, 1, &size);
		result = skynet_malloc(size);
		memset(result,0,size);
		index = 2;
	}

	size_t keysz;
	const char * key = lua_tolstring(L,index,&keysz);

	int i;
	for (i = 0;i < size;i++) {
		result[i] = ptr[i] ^ key[i%keysz];
	}

	if (!lua_isuserdata(L,1)) {
		lua_pushlstring(L,result,size);
		skynet_free(result);
		return 1;
	}
	return 0;
}

#define RC4_BOX_LEN 255

int
_rc4_box(lua_State *L) {
	size_t size;
	const char * key = (const char *)luaL_checklstring(L, 1, &size);

	unsigned char box[RC4_BOX_LEN] = {0};
	unsigned char rnd_key[RC4_BOX_LEN] = {0};
	
	int i;
	for(i = 0;i < RC4_BOX_LEN;i++) {
		box[i] = i;
		rnd_key[i] = key[i % size];
	}

	int j = 0;
	for(i = 0;i < RC4_BOX_LEN;i++) {
		j = (j + box[i] + rnd_key[i]) % RC4_BOX_LEN;
		unsigned char tmp = box[i];
		box[i] = box[j];
		box[j] = tmp;
	}

	lua_pushlstring(L,(const char *)box,RC4_BOX_LEN);
	return 1;
}

struct message {
	char* data;
	int size;
	int offset;
};

struct message*
create_message(char* data,int size,const char* key,int length) {
	struct message* msg = malloc(sizeof(*msg));
	msg->data = data;
	msg->size = size;
	msg->offset = 0;
	int i;
	for (i = 0;i < msg->size;i++)
		msg->data[i] = msg->data[i] ^ key[i%length];
	return msg;
}

void
release_message(struct message* msg) {
	free(msg->data);
	free(msg);
}

ushort
read_ushort(struct message* msg) {
	assert(msg->size - msg->offset >= 0);
	uint8_t result[2] = {0};
	result[0] = *(msg->data + msg->offset);
	msg->offset++;
	result[1] = *(msg->data + msg->offset);
	msg->offset++;
	return result[0] | (result[1] << 8);
}

void*
read_left(struct message* msg,int* length) {
	assert(msg->size - msg->offset >= 0);
	if (msg->size == msg->offset)
		return NULL;
	void* result = msg->data + msg->offset;
	*length = msg->size - msg->offset;
	msg->offset = msg->size;
	return result;
}

int
_read_head(lua_State* L) {
	if (lua_isuserdata(L,1) == 0)
		luaL_error(L,"invalid userdata");

	char* data = (char*)lua_touserdata(L,1);
	int size = lua_tointeger(L, 2);
	int server_index = lua_tointeger(L,3);
	size_t length;
	const char* key = lua_tolstring(L,4,&length);

	struct message* msg = create_message(data,size,key,length);

	ushort client_index = read_ushort(msg);
	ushort id = read_ushort(msg);

	if (server_index++ != client_index) {
		release_message(msg);
		lua_pushboolean(L,0);
		lua_pushinteger(L,client_index);
		lua_pushinteger(L,server_index&0xffff);
		return 3;
	}

	lua_pushboolean(L,1);
	lua_pushinteger(L,client_index);
	lua_pushinteger(L,server_index&0xffff);
	lua_pushinteger(L,id);
	lua_pushlightuserdata(L,msg);
	return 5;	
}

/*
读取包消息id和索引，和消息体
同时释放从gate里来的消息
*/
int 
_read_body(lua_State *L) {
	if (lua_isuserdata(L,1) == 0)
		luaL_error(L,"invalid userdata");

	struct message* msg = lua_touserdata(L,1);

	int length = 0;
	char* result = read_left(msg,&length);
	if (result == NULL) {
		release_message(msg);
		return 0;
	}

	lua_pushlstring(L,result,length);
	release_message(msg);
	return 1;
}

struct header {
	ushort len; 		//total length of pack
	ushort id;  		//message id
	uint8_t num;		//pack total num
	uint8_t index;		//pack index,start from 1
};

//for server
int
_make_server_message(lua_State *L) {
	int id = lua_tointeger(L, 1);
	size_t length = 0;
	const char *body = NULL;
	if (lua_isnil(L,2) == 0)
		body = luaL_tolstring(L, 2, &length);

	static int MAX_SIZE = 1024 * 60 - sizeof(struct header);

	int cnt = 1;
	if (length > MAX_SIZE) {
		cnt = length / MAX_SIZE;
		if (length % MAX_SIZE > 0)
			cnt++;
	}

	int stream_offset = 0;
	int stream_sz = cnt * sizeof(struct header) + length;
	char* stream = (char*)malloc(stream_sz);

	int offset = 0;
	int i=1;
	for (;i<=cnt;i++) {
		int pack_size = 0;
		if (length - offset > MAX_SIZE)
			pack_size = MAX_SIZE; 
		else
			pack_size = length - offset;

		int len = sizeof(struct header) + pack_size;
		struct header * ptr = (struct header*)(stream + stream_offset);

		ptr->len = (((len - 2) & 0xff) << 8) | (((len - 2) >> 8 ) & 0xff);
		ptr->id = id;
		ptr->num = cnt;
		ptr->index = i;

		stream_offset += sizeof(struct header);
		memcpy((void*)(ptr+1),body + offset,pack_size);
		stream_offset += pack_size;

		offset += pack_size;
	}

	lua_pushlightuserdata(L,stream);
	lua_pushinteger(L,stream_sz);
	return 2;
}


int
_free_buffer(lua_State* L) {
	void * ptr;
	size_t sz;
	if (lua_isuserdata(L,1)) {
		ptr = lua_touserdata(L,1);
		sz = (size_t)luaL_checkinteger(L, 2);
		skynet_free(ptr);
	}
	return 0;
}

static struct luaL_Reg streamLib[] = {
	{ "xor_encrypt", _xor_encrypt },
	{ "rc4_box", _rc4_box },
	{ "read_head", _read_head },
	{ "read_body", _read_body },
	{ "make_server_message", _make_server_message },
	{ "free_buffer", _free_buffer },
  	{NULL, NULL}
};

int luaopen_messagehelper(lua_State *L) {
	luaL_checkversion(L);
	lua_createtable(L, 0, (sizeof(streamLib)) / sizeof(luaL_Reg) - 1);
	luaL_setfuncs(L, streamLib, 0);
	return 1;
}