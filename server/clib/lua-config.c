#include <lua.h>
#include <lauxlib.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "rwlock.h"

struct config_name {
	char * str;
	int sz;
};

struct config_data {
	void * ptr;
	int ref;
};

struct config {
	struct config_name* key;
	struct config_data* value;
};

struct config_array {
	struct rwlock lock;
	int size;
	struct config *cfgs;
};


static struct config_array *CONFIG_ARRAY = NULL;

static int linit(lua_State* L) {
	assert(CONFIG_ARRAY == NULL);
	luaL_checktype(L,1,LUA_TNUMBER);
	luaL_checktype(L,2,LUA_TFUNCTION);

	int n = lua_tointeger(L, 1);

	struct config_array *ar = malloc(sizeof(*ar));
	memset(ar,0,sizeof(*ar));

	ar->size = n;

	ar->cfgs = malloc(sizeof(struct config) * ar->size);
	memset(ar->cfgs,0,sizeof(struct config) * ar->size);
	rwlock_init(&ar->lock);

	lua_pushlightuserdata(L,ar);
	if (lua_pcall(L,1,0,0) != LUA_OK) {
		luaL_error(L,lua_tostring(L,-1));
	}
	CONFIG_ARRAY = ar;

	lua_pushlightuserdata(L,ar);
	return 1;
}

static int
ladd(lua_State *L) {
	luaL_checktype(L, 1, LUA_TLIGHTUSERDATA);
	luaL_checktype(L, 2, LUA_TNUMBER);
	luaL_checktype(L, 3, LUA_TSTRING);
	luaL_checktype(L, 4, LUA_TLIGHTUSERDATA);

	struct config_array *ar = lua_touserdata(L,1);
	
	rwlock_wlock(&ar->lock);

	size_t size;
	int index = lua_tointeger(L,2);
	const char * name = lua_tolstring(L,3,&size);
	void * ptr = lua_touserdata(L,4);

	struct config_name* conf_name = malloc(sizeof(*conf_name));
	conf_name->str = malloc(size+1);
	memcpy(conf_name->str,name,size+1);
	conf_name->str[size] = '\0';
	conf_name->sz = size+1;

	struct config_data* conf_data = malloc(sizeof(*conf_data));
	conf_data->ptr = ptr;
	conf_data->ref = 0;

	__sync_add_and_fetch(&conf_data->ref, 1);

	assert(index <= ar->size);

	ar->cfgs[index-1].value = conf_data;
	ar->cfgs[index-1].key = conf_name;

	rwlock_wunlock(&ar->lock);
	return 0;
}

#define SHAREDATA_INDEX 	1
#define ARRAYELEMENT_INDEX 	2
#define GCFUNC_INDEX 		3

static int
releaseobj(lua_State *L) {
	luaL_checktype(L, 1, LUA_TTABLE);
	lua_rawgeti(L,1,ARRAYELEMENT_INDEX);
	struct config_data* data = lua_touserdata(L,-1);
	if (__sync_sub_and_fetch(&data->ref, 1) == 0) {
		lua_rawgeti(L,1,GCFUNC_INDEX);
		lua_pushlightuserdata(L,data->ptr);
		if (lua_pcall(L,1,0,0) != LUA_OK) {
			luaL_error(L,lua_tostring(L,-1));
		}
		free(data);
	}
	return 0;
}


static int
lsearch(lua_State *L) {
	luaL_checktype(L, 1, LUA_TLIGHTUSERDATA);
	luaL_checktype(L, 2, LUA_TNUMBER);

	struct config_array *ar = lua_touserdata(L,1);
	rwlock_rlock(&ar->lock);

	int index = lua_tointeger(L,2);

	struct config *conf = &ar->cfgs[index-1];

	if (conf->value == NULL) {
		rwlock_runlock(&ar->lock);
		luaL_error(L,"lsearch error:%d\n",index);
		return 0;
	}

	struct config_data* data = conf->value;

	__sync_add_and_fetch(&data->ref, 1);

	lua_createtable(L, 3, 0);
	//sharedata ptr
	lua_pushlightuserdata(L,data->ptr);
	lua_rawseti(L,-2,SHAREDATA_INDEX);
	//array element
	lua_pushlightuserdata(L,data);
	lua_rawseti(L,-2,ARRAYELEMENT_INDEX);
	//gc func
	lua_pushvalue(L,3);
	lua_rawseti(L,-2,GCFUNC_INDEX);

	if (luaL_newmetatable(L, "meta")) {
		lua_pushcfunction(L,releaseobj);
		lua_setfield(L, -2, "__gc");
	}
	lua_setmetatable(L, -2);

	rwlock_runlock(&ar->lock);
	return 1;
}

static int
linfo(lua_State *L) {
	// luaL_checktype(L, 1, LUA_TLIGHTUSERDATA);
	// struct array *ar = lua_touserdata(L,1);
	// int init = __sync_val_compare_and_swap(&ar->init, 0, 1);
	// if (init == 0) {
	// 	luaL_error(L,"please init config first!\n");
	// 	return 0;
	// }

	// lua_newtable(L);
	// int i;
	// for(i=0;i<ar->size;i++) {
	// 	lua_pushlstring(L,ar->elts[i].key,ar->elts[i].size);
	// 	lua_rawseti(L, -2, i+1);
	// }

	return 1;
}


static int
lnew(lua_State *L) {
	// luaL_checktype(L,1,LUA_TNUMBER);

	// int n = lua_tointeger(L, 1);

	// struct array *ar = malloc(sizeof(*ar));
	// memset(ar,0,sizeof(*ar));

	// ar->size = n;

	// ar->elts = malloc(sizeof(struct element) * ar->size);
	// memset(ar->elts,0,sizeof(struct element) * ar->size);

	// lua_pushlightuserdata(L,ar);
	return 1;
}

static int
ldelete(lua_State *L) {
	return 0;
}

static int
_load(lua_State *L) {
	// struct config_array *ar = malloc(sizeof(*ar));
	// ar->offset = 0;
	// ar->size = 64;
	// ar->cfgs = malloc(sizeof(struct config) * ar->size);
	// memset(ar->cfgs,0,sizeof(struct config) * ar->size);

	// rwlock_init(ar->lock)
	// CONFIG_ARRAY = ar;

	// luaL_checktype(L, 1, LUA_TFUNCTION);
	// if (lua_pcall(L,0,0,0) != LUA_OK) {
	// 	luaL_error(L,lua_tostring(L,-1));
	// }

	return 0;
}



static int
_init(lua_State* L) {
	return 0;
}





static int
lupdate(lua_State *L) {
	// luaL_checktype(L, 1, LUA_TLIGHTUSERDATA);
	// luaL_checktype(L, 2, LUA_TNUMBER);
	// luaL_checktype(L, 3, LUA_TLIGHTUSERDATA);
	// luaL_checktype(L, 4, LUA_TFUNCTION);

	// struct array *ar = lua_touserdata(L,1);
	// rwlock_wlock(&ar->lock);

	// int index = lua_tointeger(L,2);
	// void * ptr = lua_touserdata(L,3);

	// assert(index >= 1 && index <= ar->size);
	// struct element *elt = &ar->elts[index-1];

	// if (elt == NULL) {
	// 	rwlock_wunlock(&ar->lock);
	// 	luaL_error(L,"Config update error,key:%d not exist",index);
	// 	return 0;
	// }

	// struct data *od = elt->value;

	// struct data *nd = malloc(sizeof(*nd));
	// nd->ptr = ptr;
	// nd->ref = 0;
	// __sync_add_and_fetch(&nd->ref, 1);

	// elt->value = nd;

	// if (__sync_sub_and_fetch(&od->ref,1) == 0) {
	// 	lua_pushvalue(L,4);
	// 	lua_pushlightuserdata(L,od->ptr);
	// 	if (lua_pcall(L,1,0,0) != LUA_OK) {
	// 		rwlock_wunlock(&ar->lock);
	// 		luaL_error(L,lua_tostring(L,-1));
	// 	}
	// 	free(od);
	// }
	// rwlock_wunlock(&ar->lock);
	return 0;
}

static int
ldump(lua_State *L) {
	// luaL_checktype(L, 1, LUA_TLIGHTUSERDATA);
	// struct array *ar = lua_touserdata(L,1);
	// printf("size:%d\n",ar->size);
	// int i;
	// for (i=0;i<ar->size;i++) {
	// 	printf("%-15s value:%p ref:%d\n",ar->elts[i].key,ar->elts[i].value->ptr,ar->elts[i].value->ref);
	// }
	return 0;
}

int
luaopen_config(lua_State *L) {
	luaL_Reg l[] = {
		{ "init",	linit },
		{ "delete", ldelete },
		{ "info",	linfo },
		{ "add",	ladd },
		{ "search", lsearch },
		{ "update", lupdate },
		{ "dump",	ldump },
		{ NULL, NULL },
	};
	luaL_checkversion(L);
	luaL_newlib(L, l);

	return 1;
}