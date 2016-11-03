

#include <math.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include "../list.h"
#include "../minheap.h"
#include "pathfinder.h"
#ifndef _MSC_VER
#include <stdbool.h>
#else
#define inline __inline
#define false 0
#endif

#define MARK_MAX 64

#define RANGE_MIN(val,depth,min) (val - depth < min ? min : val - depth)
#define RANGE_MAX(val,depth,max) (val + depth >= max ? max - 1 : val + depth)
#define SQUARE(val) (val*val)
#define DISTANCE(x0,y0,x1,y1) (sqrt((float)(SQUARE((x1-x0)) + SQUARE((y1-y0)))))

struct node {
	struct list_node list_node;
	struct element elt;
	struct node   *parent;
	int 		   x;
	int 		   y;
	int			   block;
	float 		   G;
	float 		   H;
	float 		   F;
};


struct map_context {
	int 		 scene;
	int 		 width;
	int 		 heigh;
	struct node *node;
	char 		*data;
	char	     mask[MARK_MAX];
};

struct pathfinder_context 
{
	int size;
	int	search_cnt;
	struct map_context* map_mgr;
	struct minheap* openlist;
	struct list closelist;
	struct list neighbors;
};

int direction[8][2] = {
	{ -1, 0 },
	{ 1, 0 },
	{ 0, -1 },
	{ 0, 1 },
	{ -1, -1 },
	{ -1, 1 },
	{ 1, -1 },
	{ 1, 1 },
};

#define FIND_NODE(mp,x,y) ((x < 0 || x >= mp->width || y < 0 || y >= mp->heigh) ? NULL:&mp->node[x*mp->heigh + y])

#define MASK_SET(mp,index,enable) (mp->mask[index] = enable)
#define MASK_RESET(mp) do \
{\
	int i = 0; \
for (; i < MARK_MAX; i++)\
{\
	mp->mask[i] = 0; \
	}\
}\
while (0);

#define CLEAR_NEIGHBORS(pf) do \
{\
while (!LIST_EMPTY((&pf->neighbors)))\
	LIST_POP(&pf->neighbors); \
} while (false);

struct  list *
	find_neighbors(struct pathfinder_context * finder, int index, struct node * node) {
		int i;
		CLEAR_NEIGHBORS(finder);
		for (i = 0; i < 8; i++) {
			int x = node->x + direction[i][0];
			int y = node->y + direction[i][1];
			struct map_context* map = &finder->map_mgr[index];
			struct node * tmp = FIND_NODE(map, x, y);
			if (tmp) {
				if (tmp->list_node.pre || tmp->list_node.next)
					continue;
				if (tmp->block != 0)
					LIST_PUSH((&finder->neighbors), ((struct list_node*)tmp));
			}
		}
		if (LIST_EMPTY((&finder->neighbors)))
			return NULL;
		else
			return &finder->neighbors;
	}

static inline float
neighbor_cost(struct node * from, struct node * to) {
	int dx = from->x - to->x;
	int dy = from->y - to->y;
	int i;
	for (i = 0; i < 8; ++i) {
		if (direction[i][0] == dx && direction[i][1] == dy)
			break;
	}
	if (i < 4)
		return 50.0f;
	else if (i < 8)
		return 60.0f;
	else {
		assert(0);
		return 0.0f;
	}
}

#define GOAL_COST(from,to) (abs(from->x - to->x) * 50.0f + abs(from->y - to->y) * 50.0f)


static inline void
heap_clear(struct element* elt) {
	struct node *n = (struct node*)((int8_t*)elt - sizeof(struct list_node));
	n->parent = NULL;
	n->F = n->G = n->H = 0;
	n->elt.index = 0;
}

#define RESET(finder) do \
{\
struct node * n = NULL; \
while ((n = (struct node*)LIST_POP(&finder->closelist))) {\
\
n->G = n->H = n->F = 0; \
}\
minheap_clear(finder->openlist, heap_clear); \
} while (false);


#define CLEAR_NODE(n) do  \
{\
	n->parent = NULL; \
	n->F = n->G = n->H = 0; \
	n->elt.index = 0; \
} while (false);

#define DX(A,B) (A->x - B->x)
#define DY(A,B) (A->y - B->y)

static inline int
movable(struct map_context * map, int x, int y, int ignore) {
	struct node *n = FIND_NODE(map, x, y);
	if (n == NULL)
		return 0;
	if (ignore)
		return n->block != 0;
	return map->mask[n->block] == 1;
}

static inline int
less(struct element * left, struct element * right) {
	struct node *l = (struct node*)((int8_t*)left - sizeof(struct list_node));
	struct node *r = (struct node*)((int8_t*)right - sizeof(struct list_node));
	return l->F < r->F;
}

void
make_path(struct map_context* map, struct node *current, struct node *from, int ignore, path_callback cb, void* ud) {
	cb(ud, current->x, current->y,1);

	struct node * parent = current->parent;
	assert(parent != NULL);
	int dx0 = DX(current, parent);
	int dy0 = DY(current, parent);

	int door = 0;

	current = parent;
	while (current) 
	{
		LIST_REMOVE(((struct list_node*)current));
		if (current != from) 
		{
			parent = current->parent;
			if (parent != NULL) 
			{
				if (ignore) {
					int dx1 = DX(current, parent);
					int dy1 = DY(current, parent);
					if (dx0 != dx1 || dy0 != dy1) 
					{
						cb(ud, current->x, current->y, 1);
						dx0 = dx1;
						dy0 = dy1;
					}
				}
				else 
				{
					if (map->mask[current->block] != 1) 
					{
						door = 1;
						dx0 = DX(current, parent);
						dy0 = DY(current, parent);
						cb(ud, current->x, current->y, 0);
					}
					else 
					{
						if (door) 
						{
							door = 0;
							dx0 = DX(current, parent);
							dy0 = DY(current, parent);
							cb(ud, current->x, current->y, 1);
						}
						else 
						{
							int dx1 = current->x - parent->x;
							int dy1 = current->y - parent->y;
							if (dx0 != dx1 || dy0 != dy1) 
							{
								cb(ud, current->x, current->y, 1);
								dx0 = dx1;
								dy0 = dy1;
							}
						}
					}
				}
			}
			else 
			{
				cb(ud, current->x, current->y, 1);
				CLEAR_NODE(current);
				break;
			}

		}
		else 
		{
			cb(ud, current->x, current->y, 1);
			CLEAR_NODE(current);
			break;
		}
		struct node *tmp = current;
		current = current->parent;
		CLEAR_NODE(tmp);
	}
}

struct pathfinder_context* finder_create(int size) 
{
	struct pathfinder_context *finder = (struct pathfinder_context *)malloc(sizeof(*finder));
	memset(finder, 0, sizeof(*finder));

	finder->size = size;
	finder->map_mgr = (struct map_context*)malloc(sizeof(struct map_context) * finder->size);
	memset(finder->map_mgr, 0, sizeof(struct map_context) * finder->size);

	finder->openlist = minheap_new(50 * 50, less);
	LIST_INIT((&finder->closelist));
	LIST_INIT((&finder->neighbors));

	return finder;
}

void finder_release(struct pathfinder_context* finder)
{
	int i;
	for (i = 0; i < finder->size; i++) 
	{
		struct map_context * map = &finder->map_mgr[i];
		free(map->node);
		free(map->data);
	}
	free(finder->map_mgr);
	minheap_delete(finder->openlist);
	free(finder);
}


void finder_init(struct pathfinder_context* finder, int index, int scene, int width, int heigh, char* data) 
{
	struct map_context *map = &finder->map_mgr[index];
	map->scene = scene;
	map->width = width;
	map->heigh = heigh;

	map->node = (struct node*)malloc(map->width * map->heigh * sizeof(struct node));
	memset(map->node, 0, map->width * map->heigh * sizeof(struct node));

	map->data = (char*)malloc(map->width * map->heigh);
	memset(map->data, 0, map->width * map->heigh);
	memcpy(map->data, data, width * heigh);

	int i = 0;
	int j = 0;
	for (; i < map->width; ++i) 
	{
		for (j = 0; j < map->heigh; ++j) 
		{
			int index = i*map->heigh + j;
			struct node *tmp = &map->node[index];
			tmp->x = i;
			tmp->y = j;
			tmp->block = map->data[index];
		}
	}
}

int finder_find(struct pathfinder_context * finder, int index, int x0, int y0, int x1, int y1, int ignore, path_callback cb, void* cb_args, path_dump dump,void* dump_args)
{
	struct node * from = FIND_NODE((&finder->map_mgr[index]), x0, y0);
	struct node * to = FIND_NODE((&finder->map_mgr[index]), x1, y1);
	if (!from || !to || from == to || to->block == 0)
		return 0;

	finder->search_cnt = 0;

	minheap_push(finder->openlist, &from->elt);

	struct node * current = NULL;

	for (;;)
	{
		struct element * elt = minheap_pop(finder->openlist);
		if (!elt)
		{
			RESET(finder);
			return 0;
		}
		current = (struct node*)((int8_t*)elt - sizeof(struct list_node));
		if (current == to)
		{
			make_path(&finder->map_mgr[index], current, from, ignore, cb, cb_args);
			RESET(finder);
			return 1;
		}
		finder->search_cnt++;
		LIST_PUSH((&finder->closelist), ((struct list_node *)current));
		struct list * neighbors = find_neighbors(finder, index, current);
		if (neighbors)
		{
			struct node * n;
			while ((n = (struct node*)LIST_POP(neighbors)))
			{
				if (n->elt.index)
				{
					int nG = current->G + neighbor_cost(current, n);
					if (nG < n->G)
					{
						n->G = nG;
						n->F = n->G + n->H;
						n->parent = current;
						MINHEAP_CHANGE(finder->openlist, (&n->elt));
					}
				}
				else
				{
					n->parent = current;
					n->G = current->G + neighbor_cost(current, n);
					n->H = GOAL_COST(n, to);
					n->F = n->G + n->H;
					minheap_push(finder->openlist, &n->elt);
					if (dump != NULL)
						dump(dump_args, current->x, current->y);
				}
			}
		}
	}
}

void finder_raycast(struct pathfinder_context* pf, int index, int x0, int y0, int x1, int y1, int ignore, int* resultx, int* resulty, path_dump dump, void* ud)
{
	struct map_context *m = &pf->map_mgr[index];

	float fx0 = x0 + 0.5f;
	float fy0 = y0 + 0.5f;
	float fx1 = x1 + 0.5f;
	float fy1 = y1 + 0.5f;
	float slope = (fy1 - fy0) / (fx1 - fx0);

	float rx = fx0;
	float ry = fy0;
	int founded = 0;
	if (abs(slope) < 1)
	{
		if (fx1 >= fx0)
		{
			float inc = 1;
			float x = fx0 + inc;

			for (; x <= fx1; x += inc)
			{
				float y = slope * (x - fx0) + fy0;
				if (dump != NULL)
					dump(ud, x, y);
				
				if (movable(m, x, y, ignore) == 0)
				{
					founded = 1;
					break;
				}
				else
				{
					rx = x;
					ry = y;
				}
			}
		}
		else
		{
			float inc = -1;
			float x = fx0;
			founded = 0;
			for (; x >= x1; x += inc) 
			{
				float y = slope * (x - fx0) + fy0;
				if (dump != NULL)
					dump(ud, x, y);
				if (movable(m, x, y, ignore) == 0)
				{
					founded = 1;
					break;
				}
				else
				{
					rx = x;
					ry = y;
				}
			}
		}
	}
	else
	{
		if (fy1 >= fy0)
		{
			float inc = 1;
			float y = fy0 + inc;
			founded = 0;
			for (; y <= fy1; y += inc) 
			{
				float x = (y - fy0) / slope + fx0;
				if (dump != NULL)
					dump(ud, x, y);
				if (movable(m, x, y, ignore) == 0)
				{
					founded = 1;
					break;
				}
				else
				{
					rx = x;
					ry = y;
				}
			}
		}
		else 
		{
			float inc = -1;
			float y = fy0;
			founded = 0;
			for (; y >= fy1; y += inc) 
			{
				float x = (y - fy0) / slope + fx0;
				if (dump != NULL)
					dump(ud, x, y);
				if (movable(m, x, y, ignore) == 0)
				{
					founded = 1;
					break;
				}
				else
				{
					rx = x;
					ry = y;
				}
			}
		}
	}

	if (founded == 0 && movable(m, (int)fx1, (int)fy1, ignore) == 1)
	{
		rx = (float)x1;
		ry = (float)y1;
	}
	
	*resultx = (int)rx;
	*resulty = (int)ry;
}

int finder_movable(struct pathfinder_context * finder, int index, int x, int y,int ignore)
{
	struct map_context *m = &finder->map_mgr[index];
	return movable(m, x, y, ignore);
}

void finder_mask_set(struct pathfinder_context * finder, int map_index,int mask_index,int enable) 
{
	struct map_context *map = &finder->map_mgr[mask_index];
	map->mask[mask_index] = enable;
}

void finder_mask_reset(struct pathfinder_context * finder, int map_index) 
{
	struct map_context *map = &finder->map_mgr[map_index];
	int i = 0; 
	for (; i < MARK_MAX; i++)
		map->mask[i] = 0;
}