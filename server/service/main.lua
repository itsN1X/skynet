local fish = require "fish"
local util = require "util"
local startup = require "server_startup"
local debughelper = require "debughelper"
local time = require "time"
local messagehelper = require "messagehelper"
fish.start(function ()
	
	startup.start(1,7777,9999,"127.0.0.1:10105","./server/csv","./server/pb")
	startup.create_service("agent_mgr","agent_mgr")
	local login = startup.create_service("login","login/login_boot")
	local gate = startup.create_service("gate_client","gate_client")
	fish.send(login,"start",{gate = gate})
	fish.send(gate,"listen",{login = login,port = 10100,maxclient = 10000})
end,function ()
	fish.error("stop")
end)