local fish = require "fish"
local util = require "util"
local service_pool = require "service_pool"

local _agent_pool

local function start(...)
	fish.register(".agent_mgr")
	_agent_pool = service_pool.create("agent","agent/agent",5,20)
end

local function stop(...)
	_agent_pool:foreach(function (agent,cnt)
		fish.stopservice(agent)
	end)
end

fish.start(start,stop)

fish.register_message("restart",function (source,args)
	_agent_pool:new()
	fish.ret("ok")
end)


fish.register_message("enter",function (source,args)

end)

fish.register_message("leave",function (source,args)

end)

fish.register_message("enter_agent",function (source,args)

end)

fish.register_message("leave_agent",function (source,args)

end)