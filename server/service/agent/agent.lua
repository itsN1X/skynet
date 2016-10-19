local fish = require "fish"

local function start(...)

end

local function stop(...)

end

fish.start(start,stop)

local function dispatch_agent_message(id,method,args)
	fish.dispatch_message(id,method,args)
end

fish.dispatch("agent",function (_, address, method, id, args, fallback)
	dispatch_agent_message(id,method,args)
end)

local export = {}
export.dispatch_agent_message = dispatch_agent_message

return export