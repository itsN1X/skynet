local fish = require "fish"
local util = require "util"
local startup = require "server_startup"
local debughelper = require "debughelper"
fish.start(function ()
	local time_recorder = debughelper.create_timerecorder()
	_G["time_recorder"] = time_recorder
	startup.start(1,7777,9999,"127.0.0.1:10105","./server/csv")
	
end,function ()
	fish.error("stop")
end)