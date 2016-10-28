local fish = require "fish"
local gate = require "gate"
local util = require "util"
local messagehelper = require "messagehelper"

local _login
local _fd_mgr = {}

local function start()
	
end

local function stop(...)
	gate.close()
end

fish.start(start,stop)

local _agent_forward = {}

fish.register_message("message",function (source,fd,msg,sz)
	local fd_info = _fd_mgr[fd]
	local success,client_index,server_index,id,message = messagehelper.read_head(msg,sz,fd_info.index,fd_info.key)
	if not success then
		gate.closeclient(fd)
		error(string.format("message index not match!server:%d,client:%d",server_index,client_index))
	end

	local fd_info = _fd_mgr[fd]
	fd_info.index = server_index

	local agent = _agent_forward[fd]
	if agent == nil then
		fish.raw_send(_login,"gate",fd,id,message)
	else
		fish.raw_send(agent,"gate",fd,id,message)
	end
end)

fish.register_message("connect",function (source,fd,addr)
	fish.error("connect",fd,addr)
	local client = fish.launch("client",fd)
	gate.openclient(fd)
	fish.send(_login,"enter",{fd = fd,addr = addr,client = client})
	_fd_mgr[fd] = {addr = addr,index = 0,client = client,key = messagehelper.rc4_box("legend")}
end)

local function client_down(fd)
	local info = _fd_mgr[fd]
	fish.kill(info.client)
	fish.send(_login,"leave",{fd = fd})
	_fd_mgr[fd] = nil
end

fish.register_message("disconnect",function (source,fd)
	fish.error("disconnect",fd)
	client_down(fd)
end)

fish.register_message("error",function (source,fd,msg)
	fish.error("error",fd,msg)
	client_down(fd)
end)

fish.register_message("forward",function (source,args)
	assert(_agent_forward[args.fd] == nil)
	_agent_forward[args.fd] = args.agent
end)

fish.register_message("kick",function (source,args)
	gate.closeclient(args.fd,args.msg,args.sz)
end)

fish.register_message("listen",function (source,args)
	_login = args.login
	gate.open({port = args.port,maxclient = args.maxclient})
end)