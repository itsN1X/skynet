

struct pathfinder_context;

typedef void(*path_callback)(void *ud, int x, int y,int flag);
typedef void(*path_dump)(void* ud, int x, int y);

struct pathfinder_context* finder_create(int size);
void finder_init(struct pathfinder_context* finder, int index, int scene, int width, int heigh, char* data);
void finder_release(struct pathfinder_context* finder);
void finder_raycast(struct pathfinder_context* finder, int index, int x0, int y0, int x1, int y1, int ignore, int* resultx, int* resulty, path_dump dump,void* ud);
int finder_find(struct pathfinder_context * finder, int index, int x0, int y0, int x1, int y1, int ignore, path_callback cb, void* cb_args, path_dump dump,void* dump_args);
int finder_movable(struct pathfinder_context * finder, int index, int x, int y,int ignore);