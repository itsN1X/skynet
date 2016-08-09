local skynet = require "skynet"
local fish = require "fish"
local netpack = require "netpack"
local socketdriver = require "socketdriver"

local gate = {}

local socket	-- listen socket
local queue		-- message queue
local maxclient	-- max client
local client_number = 0
local CMD = setmetatable({}, { __gc = function() netpack.clear(queue) end })
local nodelay = false

local connection = {}

function gate.openclient(fd)
	if connection[fd] then
		socketdriver.start(fd)
	end
end

function gate.closeclient(fd)
	local c = connection[fd]
	if c then
		connection[fd] = false
		socketdriver.close(fd)
	end
end


function gate.open(conf)
	assert(not socket)
	local address = conf.address or "0.0.0.0"
	local port = assert(conf.port)
	maxclient = conf.maxclient or 1024
	nodelay = conf.nodelay
	skynet.error(string.format("Listen on %s:%d", address, port))
	socket = socketdriver.listen(address, port)
	socketdriver.start(socket)
end

function gate.close()
	assert(socket)
	socketdriver.close(socket)
end

function gate.kick(fd)
	gate.closeclient(fd)
end

local MSG = {}

local function dispatch_msg(fd, msg, sz)
	if connection[fd] then
		fish.dispatch_message(0,"message",fd, msg, sz)
	else
		skynet.error(string.format("Drop message from fd (%d) : %s", fd, netpack.tostring(msg,sz)))
	end
end

MSG.data = dispatch_msg

local function dispatch_queue()
	local fd, msg, sz = netpack.pop(queue)
	if fd then
		-- may dispatch even the handler.message blocked
		-- If the handler.message never block, the queue should be empty, so only fork once and then exit.
		skynet.fork(dispatch_queue)
		dispatch_msg(fd, msg, sz)

		for fd, msg, sz in netpack.pop, queue do
			dispatch_msg(fd, msg, sz)
		end
	end
end

MSG.more = dispatch_queue

function MSG.open(fd, msg)
	if client_number >= maxclient then
		socketdriver.close(fd)
		return
	end
	if nodelay then
		socketdriver.nodelay(fd)
	end
	connection[fd] = true
	client_number = client_number + 1
	fish.dispatch_message(0,"connect",fd, msg)
end

local function close_fd(fd)
	local c = connection[fd]
	if c ~= nil then
		connection[fd] = nil
		client_number = client_number - 1
	end
end

function MSG.close(fd)
	if fd ~= socket then
		fish.dispatch_message(0,"disconnect",fd)
		close_fd(fd)
	else
		socket = nil
	end
end

function MSG.error(fd, msg)
	if fd == socket then
		socketdriver.close(fd)
		skynet.error(msg)
	else
		fish.dispatch_message(0,"error",fd, msg)
		close_fd(fd)
	end
end

function MSG.warning(fd, size)
	fish.dispatch_message(0,"warning",fd, size)
end

skynet.register_protocol {
	name = "socket",
	id = skynet.PTYPE_SOCKET,	-- PTYPE_SOCKET = 6
	unpack = function ( msg, sz )
		return netpack.filter( queue, msg, sz)
	end,
	dispatch = function (_, _, q, type, ...)
		queue = q
		if type then
			MSG[type](...)
		end
	end
}

return gate
