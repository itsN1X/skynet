local util = require "util"

local collect_info = {}
local agent_collections = {}

local export = {}

export.foreach = function (func)
	for name,info in pairs(collect_info) do
		func(name,info)
	end
end

export.foreach_agent = function (func)
	for name,_ in pairs(agent_collections) do
		func(name)
	end
end

export.exist = function (name)
	if collect_info[name] == nil then
		return false
	end
	return true
end

export.register = function (name,indexes,merge)
	assert(collect_info[name] == nil,string.format("collection:%s already register",name))
	collect_info[name] = {index = indexes,merge = merge}
end

export.register_agent = function (name)
	assert(agent_collections[name] == nil,string.format("collection:%s already register to agent",name))
	agent_collections[name] = true
end


return export