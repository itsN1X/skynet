#include "skynet.h"
#include "skynet_socket.h"

#include <stdint.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define UPDATE_TICK "10"
#define BUFFER_INIT (64)
#define BUFFER_BEST (4096)
#define BUFFER_MAX  (1024*64)

struct client {
	int id;
	int count;
	int min;
	int max;
	int offset;
	char* buffer;
};

static int
_cb(struct skynet_context * context, void * ud, int type, int session, uint32_t source, const void * msg, size_t sz) {
	struct client * c = ud;

	if (type == PTYPE_RESPONSE) {
		skynet_command(context,"TIMEOUT",UPDATE_TICK);
		if (c->offset != 0) {
			skynet_socket_send(context, c->id, (void*)c->buffer, c->offset);
			
			if (c->min == 0 || c->min > c->offset)
				c->min = c->offset;

			c->offset = 0;
			c->buffer = NULL;
			c->count = 0;
			if (c->max >= BUFFER_MAX)
				c->max = BUFFER_BEST;
		}
	}
	else if(type == PTYPE_CLIENT) {
		if (c->buffer == NULL) {
			while(c->max <= sz) {
				c->max *= 2;
			}
			c->offset = 0;
			c->buffer = skynet_malloc(c->max);
		}

		int need = c->offset + sz;
		if (need > c->max) {
			while(c->max <= need) {
				c->max *= 2;
			}
			c->buffer = skynet_realloc(c->buffer,c->max);
			if (c->max >= BUFFER_MAX) {
				skynet_error(context, "[client] buffer size too large:[%d,%d]", need,c->max);
			}
		}
		memcpy(c->buffer+c->offset,msg,sz);
		c->offset += sz;
		c->count += 1;
	}
	else {
		skynet_error(context, "[client] Unkown type : %d", type);
	}
	return 0;
}

int
client_init(struct client *c, struct skynet_context *ctx, const char * args) {
	int id = 0;
	if (args == NULL)
		return 1;
	sscanf(args, "%d",&id);
	c->id = id;
	skynet_callback(ctx, c, _cb);

	skynet_command(ctx,"TIMEOUT",UPDATE_TICK);

	return 0;
}

struct client *
client_create(void) {
	struct client *c = skynet_malloc(sizeof(*c));
	memset(c,0,sizeof(*c));
	c->min = 0;
	c->max = BUFFER_INIT;
	return c;
}

void
client_release(struct client *c) {
	if (c->buffer != NULL)
		skynet_free(c->buffer);
	skynet_free(c);
}
