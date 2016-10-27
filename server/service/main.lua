local fish = require "fish"
local util = require "util"
local startup = require "server_startup"
local debughelper = require "debughelper"
local time = require "time"
local messagehelper = require "messagehelper"
fish.start(function ()
	
	startup.start(1,7777,9999,"127.0.0.1:10105","./server/csv")
	local handle = startup.create_service("login","login/login_boot")
	startup.create_service("gate_client","gate_client",handle,10100,1000)
end,function ()
	fish.error("stop")
end)