local driver = require "socketdriver"
local fish = require "fish"
local skynet = require "skynet"
local core = require "connector.core"

local assert = assert

local connector_mgr = {}

local _M = {}	-- api

local socket_message = {}

-- read skynet_socket.h for these macro
-- SKYNET_SOCKET_TYPE_DATA = 1
socket_message[1] = function(id, size, data)
	local connector = connector_mgr[id]
	if connector == nil then
		fish.error(string.format("no such socket id:%d",id))
		return
	end
	local data_list = core.collect(connector.buffer,data,size)
	for _,data in pairs(data_list) do
		fish.dispatch_message(id,"socket_data",data.method,table.unpack(data.content))
	end
end

-- SKYNET_SOCKET_TYPE_CONNECT = 2
socket_message[2] = function(id, _ , addr)
	local connector = connector_mgr[id]
	if connector == nil then
		fish.error(string.format("no such socket id:%d,addr:%s",id,addr))
		return
	end
	connector.connected = true
	fish.dispatch_message(id,"socket_connected",addr)
end

-- SKYNET_SOCKET_TYPE_CLOSE = 3
socket_message[3] = function(id)
	local connector = connector_mgr[id]
	if connector == nil then
		fish.error(string.format("no such socket id:%d",id))
		return
	end
	connector_mgr[id] = nil
	fish.dispatch_message(id,"socket_close")
end

-- SKYNET_SOCKET_TYPE_ACCEPT = 4
socket_message[4] = function(id, newid, addr)
	assert(false,id)
end

-- SKYNET_SOCKET_TYPE_ERROR = 5
socket_message[5] = function(id, _, err)
	local connector = connector_mgr[id]
	if connector == nil then
		fish.error(string.format("no such socket id:%d",id))
		return
	end
	connector_mgr[id] = nil
	fish.dispatch_message(id,"socket_error",err)
end

-- SKYNET_SOCKET_TYPE_UDP = 6
socket_message[6] = function(id, size, data, address)
	assert(false,id)
end


-- SKYNET_SOCKET_TYPE_WARNING
socket_message[7] = function(id, size)
	fish.error(string.format("socket:%d size:%d warning",id,size))
end

skynet.register_protocol {
	name = "socket",
	id = skynet.PTYPE_SOCKET,	-- PTYPE_SOCKET = 6
	unpack = driver.unpack,
	dispatch = function (_, _, t, ...)
		socket_message[t](...)
	end
}


function _M.send(id,data,size)
	core.send(id,data,size)
end

function _M.close(id)
	driver.close(id)
end

function _M.connect(address,port)
	local id = driver.connect(address,port)
	local connector = setmetatable({},{__gc = function (self)
		core.release(self.buffer)
	end})
	connector.id = id
	connector.connected = false
	connector.address = address
	connector.port = port
	connector.buffer = core.create()
	connector_mgr[id] = connector
	return id
end

return _M
