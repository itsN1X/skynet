local fish = require "fish"
local remote = require "remote"
local util = require "util"
local startup = require "server_startup"
local mongodb_collection = require "mongodb.mongodb_collection"
local loadfilex = require "loadfilex"
local second = require "second"
local config = require "config.config_helper"
local debughelper = require "debughelper"
local csv2tablex = require "config.csv2tablex"
fish.start(function ()
	local time_recorder = debughelper.create_timerecorder()
	_G["time_recorder"] = time_recorder
	
	
	
	time_recorder:begin("startup.start")
	startup.start(1,7777,9999,"127.0.0.1:10105","./server/csv")
	time_recorder:over("startup.start")

	time_recorder:begin("csvparser")
	local parser = csv2tablex.create()
	local r = parser:parse("./server/csv/Item.csv")
	time_recorder:over("csvparser")
	
	time_recorder:begin("config:find")
	util.dump_table(config:find("Item",1))
	time_recorder:over("config:find")
	time_recorder:report()
	local inst = second.new()
	inst:test()
	local r = loadfilex("./examples/config")
	util.dump_table(r)
	dump_class_inst("second")
	inst = nil
	collectgarbage "collect"
	dump_class_inst("second")

	local token = util.encode_token({hello = "world"},"key",3600)
	print(token)
	util.dump_table(util.decode_token(token,"key",3600))
	local libmongo = require "libmongo"
	-- util.dump_table(libmongo.listdb())
	local u3d = libmongo.new("u3d")
	local rolelist = u3d.role:findAll()
	
	startup.create_service("login","login/login_boot")
	local handle = startup.create_service("remote_test","remote_test")
	-- startup.create_service("remote_gate","remote_gate","key","8888")
	local handle_interaction = startup.create_service("remote_interaction","remote_client","remote_interaction/remote_interaction_proto","key","127.0.0.1","10100")
	local handle_team = startup.create_service("remote_team","remote_client","remote_team/remote_team_proto","key","127.0.0.1","10100")


		remote.send_gate_name(handle_interaction,"remote_test","ping",rolelist)
		remote.send_gate_handle(handle_team,handle,"req",{handle = handle,a = 3,b = 4})
	-- end
	-- -- 	util.dump_table(u3d:dropdb())
	-- 	local u3d = libmongo.new("u3d_bak")
	-- util.dump_table(u3d:copydb("u3d"))
	-- local u3d = libmongo.new("u3d")
	-- util.dump_table(u3d.role:findAll())
	u3d.test:insert({a = 1,b= 2})
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