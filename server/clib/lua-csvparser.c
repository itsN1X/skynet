#include <lua.h>
#include <lauxlib.h>
#include <math.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "csv/csv.h"

static int
release_parser(lua_State* L) {
	struct csv_parser* parser = lua_touserdata(L, 1);

	return 0;
}

static int
create_parser(lua_State* L) {
	struct csv_parser* parser = lua_newuserdata(L,sizeof(*parser));
	if (luaL_newmetatable(L, "metactx")) {
		lua_pushcfunction(L, release_parser);
		lua_setfield(L, -2, "__gc");
	}
	lua_setmetatable(L, -2);

	csv_init(parser,0);
	return 1;
}

struct parser_ctx {
	struct lua_State* L;
	int row;
	int field;
};

void submitfield(char *field, size_t len, void* ctx) {
	struct parser_ctx* self = ctx;
	// printf("cb1:%.*s\n",len,field);
	if (self->field == 0)
		lua_createtable(self->L,64,0);

	self->field++;
	lua_pushlstring(self->L,field,len);
	lua_rawseti(self->L, -2, self->field);
}

void newline(int c, void* ctx) {
	struct parser_ctx* self = ctx;
	self->row++;
	lua_rawseti(self->L, -2, self->row);
	self->field = 0;
}


static int
parse_csv(lua_State* L) {
	struct csv_parser* parser = lua_touserdata(L,1);
	size_t len = 0;
	char* line = lua_tolstring(L,2,&len);
	char c;
	struct parser_ctx* ctx = malloc(sizeof(*ctx));
	ctx->L = L;
	ctx->row = 0;
	ctx->field = 0;
	lua_createtable(L,64,0);

	csv_parse(parser,line,len,submitfield,newline,(void*)ctx);
	return 1;
}

static struct luaL_Reg lib[] = {
	{"create", create_parser},
	{"parse", parse_csv},
  	{NULL, NULL}
};

int luaopen_csvparser(lua_State *L) {
	luaL_checkversion(L);
	lua_createtable(L, 0, (sizeof(lib)) / sizeof(luaL_Reg) - 1);
	luaL_setfuncs(L, lib, 0);
	return 1;
}