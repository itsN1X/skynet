local fish = require "fish"
local util = require "util"
local startup = require "server_startup"
local debughelper = require "debughelper"
local time = require "time"
local messagehelper = require "messagehelper"
fish.start(function ()
	local time_recorder = debughelper.create_timerecorder()
	_G["time_recorder"] = time_recorder
	startup.start(1,7777,9999,"127.0.0.1:10105","./server/csv")
	time_recorder:begin("time")
	for i = 1,100000 do
		time.time_to_date(fish.time())
	end
	time_recorder:over("time")
	time_recorder:report()

	local t = {}
	for i = 1,1024 * 60 * 2.5 do
		table.insert(t,"a")
	end
	messagehelper.make_server_pack(1000,table.concat(t,""))
end,function ()
	fish.error("stop")
end)