#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
#include <stdint.h>
#include "list.h"
#include "minheap.h"

struct timer_node {
	struct element elt;
	uint32_t id;
	uint32_t expire;
	struct timer_node* next;
};

struct timer_pool {
	struct timer_pool* next;
};

struct timer_ctx {
	uint32_t counter;
	struct minheap* heap;
	struct timer_node* freelist;
	struct timer_pool* pool;
};

#define CAST_NODE(n) (struct timer_node*)(n)

static inline int 
less(struct element * left,struct element * right) {
	struct timer_node *l = CAST_NODE(left);
	struct timer_node *r = CAST_NODE(right);

	return l->expire < r->expire;
}

static int
releaseobj(lua_State *L) {
	struct timer_ctx* ctx = lua_touserdata(L, 1);
	minheap_delete(ctx->heap);

	struct timer_pool* pool = NULL;
	while((pool = ctx->pool) != NULL) {
		ctx->pool = pool->next;
		free(pool);
	}

	return 0;
}

static int
_create(lua_State* L) {
	struct timer_ctx* ctx = lua_newuserdata(L,sizeof(*ctx));

	ctx->counter = 0;
	ctx->heap = minheap_new(100,less);
	ctx->freelist = NULL;
	ctx->pool = NULL;

	if (luaL_newmetatable(L, "metactx")) {
		lua_pushcfunction(L, releaseobj);
		lua_setfield(L, -2, "__gc");
	}
	lua_setmetatable(L, -2);

	return 1;
}

static int
_push(lua_State* L) {
	struct timer_ctx* ctx = lua_touserdata(L,1);
	int expire = luaL_checkinteger(L,2);
	int id = ++ctx->counter;

	struct timer_node* node = NULL;
	if (ctx->freelist == NULL) {
		//从内存申请一块内存
		static int NODE_SIZE = 64;

		struct timer_pool* pool = malloc(sizeof(*pool) + NODE_SIZE * sizeof(struct timer_node));
		pool->next = ctx->pool;
		ctx->pool = pool;

		struct timer_node* nodes = (struct timer_node*)(pool+1);
		int i;
		for(i = 0;i < NODE_SIZE;i++) {
			struct timer_node* n = &nodes[i];
			n->next = ctx->freelist;
			ctx->freelist = n;
		}
	}
	
	node = ctx->freelist;
	ctx->freelist = ctx->freelist->next;

	if (node == NULL)
		luaL_error(L,"allocate timer node error");

	memset(node,0,sizeof(*node));
	node->id = id;
	node->expire = expire;

	minheap_push(ctx->heap,&node->elt);

	lua_pushinteger(L,id);
	return 1;
}

static int
_pop(lua_State* L) {
	struct timer_ctx* ctx = lua_touserdata(L,1);
	uint32_t now = luaL_checkinteger(L,2);
	
	struct element* top = MINHEAP_TOP(ctx->heap);
	if (top == NULL)
		return 0;

	struct timer_node* node = CAST_NODE(top);

	if (node->expire <= now) {
		struct element * elt = minheap_pop(ctx->heap);
		assert(elt == top);

		node = CAST_NODE(elt);

		node->next = ctx->freelist;
		ctx->freelist = node;
		
		lua_pushinteger(L,node->id);
		return 1;
	}
	return 0;
}


static struct luaL_Reg lib[] = {
	{"create", _create},
	{"push", _push},
	{"pop", _pop},
  	{NULL, NULL}
};

int luaopen_timerheap(lua_State *L) {
	luaL_checkversion(L);
	lua_createtable(L, 0, (sizeof(lib)) / sizeof(luaL_Reg) - 1);
	luaL_setfuncs(L, lib, 0);
	return 1;
}