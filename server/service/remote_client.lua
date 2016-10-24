local fish = require "fish"
local connector = require "connector"
local util = require "util"


local STATE = {Connecting = 0,Connected = 1,Close = 2}
local _file,_key,_ip,_port = ...
local _id
local _state
local _role_mgr = {}

fish.start(function ()
	fish.require(_file)
	_state = STATE.Connecting
	_id = connector.connect(_ip,tonumber(_port))
	fish.schedule_timer(100,"socket_update")
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
	
	local args = util.decode_token(args,_key,3600)
	if args.hello == nil or args.hello ~= "client" then
		fish.error(string.format("remote auth failed!id:%d,ip:%s,port:%s",_id,_ip,_port))
	else
		fish.error(string.format("remote auth success!id:%d,ip:%s,port:%s",_id,_ip,_port))
		fish.dispatch_message(_id,"connected",address)
	end
end

fish.register_message("enter",function (source,args)
	_role_mgr[args.id] = source
end)

fish.register_message("leave",function (source,args)
	_role_mgr[args.id] = nil
end)

fish.register_message("forward_service_name",function (source,data,size)
	if _id == nil then
		fish.error(string.format("remote server ip:%s,port:%s down,drop message:%s",_ip,_port,method))
		return
	end
	connector.send(_id,data,size)
end)

fish.register_message("forward_service_handle",function (source,data,size)
	if _id == nil then
		fish.error(string.format("remote server ip:%s,port:%s down,drop message:%s",_ip,_port,method))
		return
	end
	connector.send(_id,data,size)
end)

fish.register_message("socket_connected",function (id,address)
	_id = id
	fish.error(string.format("remote connected!id:%d,ip:%s,port:%s",_id,_ip,_port))
	local token = util.encode_token({hello = "gate"},_key,3600)
	local data,size = fish.pack({message = "auth",args = {token}})
	connector.send(_id,data,size)
	_state = STATE.Connected
end)

fish.register_message("socket_close",function (id)
	assert(id == _id)
	fish.error(string.format("remote closed!id:%d,ip:%s,port:%s",_id,_ip,_port))
	_id = nil
	fish.dispatch_message(id,"closed")
	_state = STATE.Close
end)

fish.register_message("socket_error",function (id)
	assert(id == _id)
	fish.error(string.format("remote error!id:%d,ip:%s,port:%s",_id,_ip,_port))
	_id = nil
	fish.dispatch_message(id,"closed")
	_state = STATE.Close
end)

fish.register_message("socket_data",function (id,method,...)
	local func = command[method]
	func(id,...)
end)

fish.register_message("socket_update",function (id,...)
	fish.schedule_timer(100,"socket_update")
	
	if _state == STATE.Close then
		_id = connector.connect(_ip,tonumber(_port))
		_state = STATE.Connecting
		fish.error(string.format("remote connecting!id:%d,ip:%s,port:%s",_id,_ip,_port))
	end
end)


