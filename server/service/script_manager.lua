local fish = require "fish"


fish.start(function ()
	fish.register(".script_manager")
end,
function ()

end)


local _file_handle = {}

fish.register_message("report",function (source,handle,file)
	local handle_set = _file_handle[file]
	if handle_set == nil then
		handle_set = {}
		_file_handle[file] = handle_set
	end
	handle_set[handle] = true
end)

fish.register_message("reload",function (source,file_list)
	local reload_list = {}
	for _,file in pairs(file_list) do
		local handle_set = _file_handle[file]
		for handle,_ in pairs(handle_set) do
			local list = reload_list[handle]
			if list == nil then
				list = {}
				reload_list[handle] = list
			end
			table.insert(file)
		end
	end
	
	for handle,list in pairs(reload_list) do
		fish.reload_service(handle,list)
	end

	fish.ret()
end)

