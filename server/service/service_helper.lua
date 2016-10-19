
local fish = require "fish"
local skynet = require "skynet"

local _serivce_mgr = {}

fish.start(function ()
	fish.register(".service_helper")
end,
function ()

end)

fish.register_message("newservice",function (source,name,file,...)
	local handle = skynet.newservice(file,...)
	
	local list = {}

	local update_info = {}
	update_info[name] = handle

	for addr,info in pairs(_serivce_mgr) do
		
		fish.set_handle(addr,update_info)
		list[info.name] = addr
	end
	fish.set_handle(handle,list)
	_serivce_mgr[handle] = {handle = handle,name = name,file = file,start_args = table.pack(...),init = false,init_args = {}}

	fish.ret(handle)
end)

fish.register_message("initservice",function (source,handle,...)
	_serivce_mgr[handle].init = true
	_serivce_mgr[handle].init_args = table.pack(...)

	local r = fish.init_service(handle,...)
	fish.ret(r)
end)

fish.register_message("stopservice",function (source,handle,...)
	local service_info = _serivce_mgr[handle]
	_serivce_mgr[handle] = nil
	local update_info = {}
	update_info[service_info.name] = 0
	for addr,info in pairs(_serivce_mgr) do
		fish.set_handle(addr,update_info)
	end
	local r = fish.stop_service(handle,...)
	fish.ret(r)
end)

fish.register_message("reload",function (source,handle,list)
	fish.reload_service(handle,list)
end)

fish.register_message("restart",function (source,handle)
	local service_info = _serivce_mgr[handle]
	fish.stop_service(handle)
	_serivce_mgr[handle] = nil
	local nhandle = fish.start_service(service_info.name,service_info.file,table.unpack(service_info.start_args))
	if service_info.init then
		fish.init_service(nhandle,table.unpack(service_info.init_args))
	end
end)

fish.register_message("stop",function (source)
	local list = {}
	for handle,_ in pairs(_serivce_mgr) do
		table.insert(list,handle)
	end
	for _,handle in pairs(list) do
		fish.stop_service(handle)
	end
end)