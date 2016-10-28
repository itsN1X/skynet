local util = require "util"

local collect_info = {}
local agent_collections = {}

local function register_collection(name,index)
	collect_info[name] = {index = index}
end

local function register_agent_collection(name)
	agent_collections[name] = true
end


register_collection("role",{{"id",unique = true},{"id","account",unique = true}})
register_collection("test1",{{"id",unique = true}})
register_collection("test2",{})










register_agent_collection("role")














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

return export