local fish = require "fish"
local util = require "util"
local service_pool = require "service_pool"

local _agent_pool

local function start(...)
	_agent_pool = service_pool.create("agent/agent",5,20)
end

local function stop(...)

end

fish.start(start,stop)

fish.register_message("reload",function (source,args)

end)

fish.register_message("restart",function (source,args)

end)


fish.register_message("enter",function (source,args)

end)

fish.register_message("leave",function (source,args)

end)

fish.register_message("enter_agent",function (source,args)

end)

fish.register_message("leave_agent",function (source,args)

end)