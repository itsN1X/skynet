extern "C" {
#include <lua.h>
#include <lauxlib.h>
}

#include <assert.h>
#include "leveldb/db.h"
#include "leveldb/options.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

using namespace leveldb;

typedef int (*method_func)(lua_State* L,void* v);

struct method_reg {
	const char* name;
	method_func func;
	size_t offset;
};


static int
_create_db(lua_State* L) {
	leveldb::DB* db;
	leveldb:Options options;
	options.create_if_missing = 1;
	leveldb::Status status = leveldb::DB::Open(options, "/tmp/testdb", &db); 
	assert(status.ok());
	lua_pushlightuserdata(L,db);
	return 1;
}

static int
_delete_db(lua_State* L) {
	leveldb::DB* db = (leveldb::DB*)lua_touserdata(L,1);
	delete db;
	return 0;
}


static int
_db_put(lua_State* L) {
	leveldb::DB* db = (leveldb::DB*)lua_touserdata(L,1);
	size_t keysize;
	const char* keystr = lua_tolstring(L,2,&keysize);
	leveldb::Slice key(keystr,keysize);
	const char* data = (const char*)lua_touserdata(L,3);
	int size = luaL_checkinteger(L,4);
	leveldb::Slice value(data,size);

	leveldb::Status status = db->Put(leveldb::WriteOptions(),key,value);

	free((void*)data);

	if (status.ok()) {
		lua_pushboolean(L,1);
		return 1;
	}
	lua_pushboolean(L,0);
	lua_pushliteral(L,"error db put");

	return 2;
}

static int
_db_get(lua_State* L) {
	leveldb::DB* db = (leveldb::DB*)lua_touserdata(L,1);
	size_t keysize;
	const char* keystr = lua_tolstring(L,2,&keysize);
	leveldb::Slice key(keystr,keysize);
	std::string value;
	leveldb::Status status = db->Get(leveldb::ReadOptions(), key, &value); 

	if (status.ok()) {
		lua_pushboolean(L,1);
		lua_pushlstring(L,value.c_str(),value.length());
		return 2;
	}
	lua_pushboolean(L,0);
	lua_pushliteral(L,"error db get");
	return 2;
}

extern "C" {
	int luaopen_leveldb(lua_State *L) {
		luaL_Reg l[] = {
			{ "create", _create_db },
			{ "delete", _delete_db },
			{ "put", _db_put },
			{ "get", _db_get },
			{ NULL, NULL },
		};
		luaL_newlib(L,l);
		luaL_setfuncs(L,l,0);

		return 1;
	}
}