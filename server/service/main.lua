local fish = require "fish"
local remote = require "remote"
local util = require "util"
local startup = require "server_startup"
local mongodb_collection = require "mongodb.mongodb_collection"

local second = require "second"
fish.start(function ()
	startup.start(1,7777,9999,"127.0.0.1:10105")

	local inst = second.new()
	inst:test()

	dump_class_inst("second")
	inst = nil
	collectgarbage "collect"
	dump_class_inst("second")

	local libmongo = require "libmongo"
	util.dump_table(libmongo.listdb())
	local u3d = libmongo.new("u3d")
	-- mongodb_collection.createIndex(u3d)
	
	startup.create_service("login","login/login_boot")
	local handle = startup.create_service("remote_test","remote_test")
	startup.create_service("remote_gate","remote_gate","8888")
	local handle_interaction = startup.create_service("remote_interaction","remote_client","remote_interaction/remote_interaction_proto","127.0.0.1","8888")
	local handle_team = startup.create_service("remote_team","remote_client","remote_team/remote_team_proto","127.0.0.1","8888")

	remote.send_gate_name(handle_interaction,"remote_test","ping",{a = 1,b = 2})
	remote.send_gate_handle(handle_team,handle,"req",{handle = handle,a = 3,b = 4})
	-- -- 	util.dump_table(u3d:dropdb())
	-- 	local u3d = libmongo.new("u3d_bak")
	-- util.dump_table(u3d:copydb("u3d"))
	-- local u3d = libmongo.new("u3d")
	-- util.dump_table(u3d.vip:findAll())

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