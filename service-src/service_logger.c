#include "skynet.h"
#include "skynet_timer.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>

struct logger {
	FILE * handle;
	char * filename;
	int close;
	uint32_t start;
};

struct logger *
logger_create(void) {
	struct logger * inst = skynet_malloc(sizeof(*inst));
	inst->handle = NULL;
	inst->close = 0;
	inst->filename = NULL;

	return inst;
}

void
logger_release(struct logger * inst) {
	if (inst->close) {
		fclose(inst->handle);
	}
	skynet_free(inst->filename);
	skynet_free(inst);
}

static void
localtimex(time_t sec,struct tm* tm,int timezone) {
 	static const int kHoursInDay = 24;
    static const int kMinutesInHour = 60;
    static const int kDaysFromUnixTime = 2472632;
    static const int kDaysFromYear = 153;
    static const int kMagicUnkonwnFirst = 146097;
    static const int kMagicUnkonwnSec = 1461;
    tm->tm_sec  =  sec % kMinutesInHour;
    int i      = (sec/kMinutesInHour);
    tm->tm_min  = i % kMinutesInHour; //nn
    i /= kMinutesInHour;
    tm->tm_hour = (i + timezone) % kHoursInDay; // hh
    tm->tm_mday = (i + timezone) / kHoursInDay;
    int a = tm->tm_mday + kDaysFromUnixTime;
    int b = (a*4  + 3)/kMagicUnkonwnFirst;
    int c = (-b*kMagicUnkonwnFirst)/4 + a;
    int d =((c*4 + 3) / kMagicUnkonwnSec);
    int e = -d * kMagicUnkonwnSec;
    e = e/4 + c;
    int m = (5*e + 2)/kDaysFromYear;
    tm->tm_mday = -(kDaysFromYear * m + 2)/5 + e + 1;
    tm->tm_mon = (-m/10)*12 + m + 2;
    tm->tm_year = b*100 + d  - 6700 + (m/10);
}

static int
logger_cb(struct skynet_context * context, void *ud, int type, int session, uint32_t source, const void * msg, size_t sz) {
	struct logger * inst = ud;
	
	switch (type) {
	case PTYPE_SYSTEM:
		if (inst->filename) {
			inst->handle = freopen(inst->filename, "a", inst->handle);
		}
		break;
	case PTYPE_TEXT:
		skynet_now();
		time_t ti = skynet_now() / 100 + inst->start;
		struct tm tm;
		localtimex(ti,&tm,8);
		char fmti[32] = {0};
		strftime(fmti,sizeof(fmti),"%Y-%m-%d %H:%M:%S",&tm);
		fprintf(inst->handle, "[:%08x][%s] ",source,fmti);
		fwrite(msg, sz , 1, inst->handle);
		fprintf(inst->handle, "\n");
		fflush(inst->handle);
		if (session != 0)
			skynet_send(context, 0, source, PTYPE_RESPONSE|PTYPE_TAG_DONTCOPY, session, NULL, 0);
		break;
	}

	return 0;
}

int
logger_init(struct logger * inst, struct skynet_context *ctx, const char * parm) {
	if (parm) {
		inst->handle = fopen(parm,"w");
		if (inst->handle == NULL) {
			return 1;
		}
		inst->filename = skynet_malloc(strlen(parm)+1);
		strcpy(inst->filename, parm);
		inst->close = 1;
	} else {
		inst->handle = stdout;
	}
	if (inst->handle) {
		inst->start = skynet_starttime();
		skynet_callback(ctx, inst, logger_cb);
		skynet_command(ctx, "REG", ".logger");
		return 0;
	}
	return 1;
}
