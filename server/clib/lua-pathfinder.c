#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"


#include <math.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include "pathfinder/pathfinder.h"

static int
_create(lua_State *L) {
	int size = (int)lua_tointeger(L,1);
	struct pathfinder_context *finder = finder_create(size);
	lua_pushlightuserdata(L, finder);
	return 1;
}

static int
_release(lua_State *L) {
	struct pathfinder_context * finder = (struct pathfinder_context*)lua_touserdata(L, 1);
	finder_release(finder);
	return 0;
}

static int
_init(lua_State *L) {
	struct pathfinder_context *finder = (struct pathfinder_context *)lua_touserdata(L, 1);
	int index = lua_tointeger(L,2);
	int scene = lua_tointeger(L,3);

	size_t size;
	const char *file = luaL_checklstring(L, 4, &size);

	int width,heigh;

	FILE *stream = fopen(file,"rb+");
	assert(stream != NULL);

	fread(&width,sizeof(int),1,stream);
	fseek(stream,sizeof(int),SEEK_SET);
	fread(&heigh,sizeof(int),1,stream);
	fseek(stream,sizeof(int) * 2,SEEK_SET);
	fseek(stream,sizeof(int) * 4,SEEK_SET);

	char* data = malloc(width * heigh);
	memset(data,0,width * heigh);
	fread(data,width * heigh,1,stream);

	fclose(stream);

	finder_init(finder, index, scene, width, heigh, data);
	
	lua_pushinteger(L,width);
	lua_pushinteger(L,heigh);
	return 2;
}

struct find_args 
{
	lua_State *L;
	int index;
};


void find_result(void *ud, int x, int y,int flag)
{

}

static int
_find(lua_State *L) {
	struct pathfinder_context *finder = (struct pathfinder_context *)lua_touserdata(L, 1);
	int index = (int)lua_tointeger(L,2);
	int x0 = (int)lua_tointeger(L,3);
	int y0 = (int)lua_tointeger(L,4);
	int x1 = (int)lua_tointeger(L,5);
	int y1 = (int)lua_tointeger(L,6);
	int ignore = (int)lua_toboolean(L,7);
	
	lua_createtable(L,64,0);
	struct find_args args;
	args.L = L;
	args.index = 0;
	finder_find(finder, index, x0, y0, x1, y1, ignore, find_result, &args, NULL, NULL);
	return 1;
}

static int
_raycast(lua_State *L) {
	struct pathfinder_context *finder = (struct pathfinder_context *)lua_touserdata(L, 1);
	int index = (int)lua_tointeger(L,2);
	int x0 = (int)lua_tointeger(L,3);
	int y0 = (int)lua_tointeger(L,4);
	int x1 = (int)lua_tointeger(L,5);
	int y1 = (int)lua_tointeger(L,6);
	int ignore = (int)lua_toboolean(L,7);

	int rx,ry;
	finder_raycast(finder, index, x0, y0, x1, y1, ignore, &rx, &ry, NULL, NULL);

	lua_pushinteger(L,rx);
	lua_pushinteger(L,ry);
	return 2;
}

static int 
_movable(lua_State *L) {
	struct pathfinder_context *pf = (struct pathfinder_context *)lua_touserdata(L, 1);
	int index = (int)lua_tointeger(L,2);
	int x = (int)lua_tointeger(L,3);
	int y = (int)lua_tointeger(L,4);
	int ignore = lua_toboolean(L,5);

	int r = finder_movable(pf,index,x,y,ignore);
	lua_pushboolean(L,r);
	return 1;
}

static int 
_mask_set(lua_State* L) {
	struct pathfinder_context *pf = (struct pathfinder_context *)lua_touserdata(L, 1);
	int map_index = (int)lua_tointeger(L,2);
	int mask_index = (int)lua_tointeger(L,3);
	int mask_enable = (int)lua_toboolean(L,4);
	finder_mask_set(pf,map_index,mask_index,mask_enable);
	return 0;
}

static int
_mask_reset(lua_State* L) {
	struct pathfinder_context *pf = (struct pathfinder_context *)lua_touserdata(L, 1);
	int map_index = (int)lua_tointeger(L,2);
	finder_mask_reset(pf,map_index);
	return 0;
}

static int
_cell(lua_State* L) {
	// struct pathfinder *pf = (struct pathfinder *)lua_touserdata(L, 1);
	// int index = (int)lua_tointeger(L,2);
	// int x = (int)lua_tointeger(L,3);
	// int y = (int)lua_tointeger(L,4);

	// struct map *m = &pf->map_mgr[index];
	// struct node* n = FIND_NODE(m,x,y);
	// if (n == NULL)
	// 	lua_pushinteger(L,0);
	// else
	// 	lua_pushinteger(L,n->block);
	return 1;
}


#if defined (_MSC_VER)
#define EXPORT __declspec(dllexport)
#else
#define EXPORT
#endif
 
#ifdef __cplusplus
extern "C" {
#endif
EXPORT int luaopen_pathfinder_core(lua_State *L)
{
	luaL_Reg l[] = 
	{
		{"create", _create},
		{"release", _release},
		{"init", _init},
		{"find", _find},
		{"raycast", _raycast},
		{"movable", _movable},
		{"mask_set", _mask_set},
		{"mask_reset", _mask_reset},
		{"cell", _cell},
		{ NULL, NULL }
	};

	lua_createtable(L, 0, (sizeof(l)) / sizeof(luaL_Reg) - 1);
	luaL_setfuncs(L, l, 0);
	return 1;
}

#ifdef __cplusplus
}
#endif
