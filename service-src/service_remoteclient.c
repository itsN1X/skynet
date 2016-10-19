#include "skynet.h"
#include "skynet_socket.h"

#include <stdint.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct client {
	int id;
};

static int
_cb(struct skynet_context * context, void * ud, int type, int session, uint32_t source, const void * msg, size_t sz) {
	struct client * c = ud;

	char* data = malloc(sz + 2);
	data[0] = sz >> 8;
	data[1] = sz & 0xff;
	memcpy(&data[2],msg,sz);
	skynet_socket_send(context, c->id, (void*)data, sz + 2);
	return 0;
}

int
remoteclient_init(struct client *c, struct skynet_context *ctx, const char * args) {
	int id = 0;
	if (args == NULL)
		return 1;
	sscanf(args, "%d",&id);
	c->id = id;
	skynet_callback(ctx, c, _cb);
	return 0;
}

struct client *
remoteclient_create(void) {
	struct client *c = skynet_malloc(sizeof(*c));
	memset(c,0,sizeof(*c));
	return c;
}

void
remoteclient_release(struct client *c) {
	skynet_free(c);
}
