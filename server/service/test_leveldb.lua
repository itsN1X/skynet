local skynet = require "skynet"
local lvldb = require "lvldb"
local util = require "util"
local time = require "time"
skynet.start(function ()
	-- local db = lvldb.create()
	-- local code,value = db:get("key")
	-- util.dump_table(value,"value")
	util.serialize(time.time_to_date(math.modf(skynet.time())),2)
	util.dump_table(time.time_to_date(math.modf(skynet.time())))
	util.text(time.time_to_date(math.modf(skynet.time())))
	print(time.anti_format_time("2016-11-2 13:50:00"))
	print(time.anti_format_daytime(math.modf(skynet.time()),"13:50"))
end)