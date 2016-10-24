local fish = require "fish"
local util = require "util"
local gate = require "gate"


local _key,_port = ...
local _fd_mgr = {}

local function start()
	gate.open({port = tonumber(_port)})
end

local function stop(...)

end

fish.start(start,stop,function ()
	fish.error("init")
	fish.dump_handle()
end)

local command = {}

function command.auth(fd,args)
	local fd_info = _fd_mgr[fd]
	local args = util.decode_token(args,_key,3600)
	if args == nil or args.hello == nil or args.hello ~= "gate" then
		fish.error(string.format("remote client auth failed!"))
		gate.closeclient(fd)
	else
		local token = util.encode_token({hello = "client"},_key,3600)
		fish.raw_send(fd_info.client,"client",fish.pack({method = "auth_success",content = {token}}))
	end
end

function command.forward_service_name(fd,service,method,args)
	local fd_info = _fd_mgr[fd]
	fish.send(fish.handle(service),method,fd_info.client,args)
end

function command.forward_service_handle(fd,handle,method,args)
	local fd_info = _fd_mgr[fd]
	fish.send(handle,method,fd_info.client,args)
end

fish.register_message("message",function (surce,fd,msg,sz)
	local fd_info = _fd_mgr[fd]
	local args = fish.unpack(msg,sz)
	local func = command[args.message]
	func(fd,table.unpack(args.args))
end)

fish.register_message("connect",function (surce,fd,addr)
	gate.openclient(fd)
	local client = fish.launch("remoteclient",fd)
	_fd_mgr[fd] = {fd = fd,addr = addr,client = client}
end)

fish.register_message("disconnect",function (surce,fd)
	local client = _fd_mgr[fd].client
	fish.kill(client)
	_fd_mgr[fd] = nil
end)

fish.register_message("error",function (surce,fd,msg)
	_fd_mgr[fd] = nil
end)
