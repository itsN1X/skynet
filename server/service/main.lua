local fish = require "fish"
local util = require "util"
local startup = require "server_startup"
local mongodb_collection = require "mongodb_collection"

fish.start(function ()
	startup.start(1,7777,9999,"127.0.0.1:10105")

	local libmongo = require "libmongo"
	local u3d = libmongo.new("u3d")
	-- mongodb_collection.createIndex(u3d)
	
	startup.create_service("remote_test","remote_test")
	startup.create_service("gate_remote","gate_remote","8888")
	startup.create_service("remote","remote","127.0.0.1","8888")
	
	
	-- -- 	util.dump_table(u3d:dropdb())
	-- 	local u3d = libmongo.new("u3d_bak")
	-- util.dump_table(u3d:copydb("u3d"))
	-- local u3d = libmongo.new("u3d")
	util.dump_table(u3d.vip:findAll())

	-- local service_pool = require "service_pool"
	-- local agent_pool = service_pool.create("agent/agent",5,5)
	-- agent_pool:dump()
	-- startup.init_all_service()

	local time = require "time"
	print(time.next_week_midnight(fish.time()),time.this_week_midnight(fish.time()),time.this_week_midnight(fish.time(),0))
	print(time.today_begin(fish.time()),time.day_time(fish.time(),11,20,0))
end,function ()
	fish.error("stop")
end)