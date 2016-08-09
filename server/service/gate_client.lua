local fish = require "fish"
local gate = require "gate"
local util = require "util"


local login,port,maxclient = ...
local _login
local _fd_mgr = {}

local function start()
	_login = login
	gate.open({port = tonumber(port),maxclient = tonumber(maxclient)})
end

local function stop(...)

end

fish.start(start,stop)

local _agent_forward = {}

fish.register_message("message",function (surce,fd,msg,sz)
	local fd_info = _fd_mgr[fd]
	local agent = _agent_forward[fd]
	if agent == nil then
		fish.raw_send(_login,"gate",fd,msg,sz)
	else
		fish.raw_send(agent,"gate",fd,msg,sz)
	end
end)

fish.register_message("connect",function (surce,fd,addr)
	print("connect",fd,addr)
	gate.openclient(fd)
	fish.send(_login,"enter",{fd = fd,addr = addr})
	_fd_mgr[fd] = {addr = addr,index = 0,key = util.rc4_box("legend")}
end)

fish.register_message("disconnect",function (surce,fd)
	print("disconnect",fd)
	fish.send(_login,"leave",{fd = fd})
	_fd_mgr[fd] = nil
end)

fish.register_message("error",function (surce,fd,msg)
	print("error",fd,msg)
	fish.send(_login,"leave",{fd = fd})
	_fd_mgr[fd] = nil
end)

fish.register_message("forward",function (surce,args)
	assert(_agent_forward[args.fd] == nil)
	_agent_forward[args.fd] = args.agent
end)
