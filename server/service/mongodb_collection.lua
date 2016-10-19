local util = require "util"

local collect_info = {}

local function register_collection(name,index)
	collect_info[name] = {index = index}
end



register_collection("role",{{"id"},{"id","account"}})


local export = {}

export.foreach = function (func)
	for name,info in pairs(collect_info) do
		func(name,info)
	end
end

export.createIndex = function (u3d)
	for name,info in pairs(collect_info) do
		for _,indexes in pairs(info.index) do
			local indextbl = {}
			for _,index in pairs(indexes) do
				indextbl[index] = 1
			end
			util.dump_table(indextbl,"indextbl")
			u3d[name]:createIndex(indextbl,false)
		end
	end
end

export.exist = function (name)
	if collect_info[name] == nil then
		return false
	end
	return true
end

return export