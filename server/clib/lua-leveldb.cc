extern "C" {
#include <lua.h>
#include <lauxlib.h>
}

#include <assert.h>
#include "leveldb/db.h"
#include "leveldb/options.h"

using namespace leveldb;

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

extern "C" {
	int luaopen_leveldb(lua_State *L) {
		luaL_Reg l[] = {
			{ "create", _create_db },
			{ NULL, NULL },
		};
		luaL_newlib(L,l);
		luaL_setfuncs(L,l,0);

		return 1;
	}
}