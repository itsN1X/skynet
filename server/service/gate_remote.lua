local fish = require "fish"
local util = require "util"
local gate = require "gate"


local _port = ...
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


fish.register_message("message",function (surce,fd,msg,sz)
	local fd_info = _fd_mgr[fd]
	fish.dump_handle()
	local args = fish.unpack(msg,sz)
	fish.send(fish.handle(args.service),args.method,args.content)

	fish.raw_send(fd_info.client,"client",fish.pack({method = "pong",content = {hello = "world"}}))
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
