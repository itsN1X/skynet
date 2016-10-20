local fish = require "fish"
local connector = require "connector"
local util = require "util"

local _file,_ip,_port = ...
local _id
local _role_mgr = {}

fish.start(function ()
	fish.require(_file)
	local id = connector.connect(_ip,tonumber(_port))
end,function (source,...)
	fish.error("stop",...)
end,function (source,...)
	fish.error("init",...)
end)


local command = {}

function command.forward_service_name(source,service,method,data)
	fish.send(fish.handle(service),method,data)
end

function command.forward_service_handle(source,handle,method,data)
	fish.send(handle,method,data)
end

function command.forward_agent(source,method,id,data)
	local role_agent = _role_mgr[id]
	if role_agent == nil then
		fish.error(string.format("drop message:%s to role:%d",method,id))
		return
	end
	fish.send_agent(role_agent,id,method,data)
end

function command.auth_success(source,args)
	fish.error(string.format("remote auth success!id:%d,ip:%s,port:%s",_id,_ip,_port))
	fish.dispatch_message(_id,"connected",address)
end

fish.register_message("enter",function (source,args)
	_role_mgr[args.id] = source
end)

fish.register_message("leave",function (source,args)
	_role_mgr[args.id] = nil
end)

fish.register_message("forward_service_name",function (source,service,method,args)
	if _id == nil then
		fish.error(string.format("remote server ip:%s,port:%s down,drop message:%s",_ip,_port,method))
		return
	end
	connector.send(_id,"forward_service_name",service,method,args)
end)

fish.register_message("forward_service_handle",function (source,handle,method,args)
	if _id == nil then
		fish.error(string.format("remote server ip:%s,port:%s down,drop message:%s",_ip,_port,method))
		return
	end
	connector.send(_id,"forward_service_handle",handle,method,args)
end)

fish.register_message("socket_connected",function (id,address)
	_id = id
	fish.error(string.format("remote connected!id:%d,ip:%s,port:%s",_id,_ip,_port))
	connector.send(_id,"auth","i am fish")
end)

fish.register_message("socket_close",function (id)
	assert(id == _id)
	fish.error(string.format("remote closed!id:%d,ip:%s,port:%s",_id,_ip,_port))
	_id = nil
	fish.dispatch_message(id,"closed")
end)

fish.register_message("socket_error",function (id)
	assert(id == _id)
	fish.error(string.format("remote error!id:%d,ip:%s,port:%s",_id,_ip,_port))
	_id = nil
	fish.dispatch_message(id,"closed")
end)

fish.register_message("socket_data",function (id,method,...)
	local func = command[method]
	func(id,...)
end)


