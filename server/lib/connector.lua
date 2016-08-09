local skynet = require "skynet"
local fish = require "fish"
local netpack = require "netpack"
local socketdriver = require "socketdriver"


-- SKYNET_SOCKET_TYPE_DATA = 1
socket_message[1] = function(id, size, data)

end

-- SKYNET_SOCKET_TYPE_CONNECT = 2
socket_message[2] = function(id, _ , addr)

end

-- SKYNET_SOCKET_TYPE_CLOSE = 3
socket_message[3] = function(id)

end

-- SKYNET_SOCKET_TYPE_ERROR = 5
socket_message[5] = function(id, _, err)

end

-- SKYNET_SOCKET_TYPE_WARNING
socket_message[7] = function(id, size)
	
end


skynet.register_protocol {
	name = "socket",
	id = skynet.PTYPE_SOCKET,	-- PTYPE_SOCKET = 6
	unpack = socketdriver.unpack,
	dispatch = function (_, _, t, ...)
		socket_message[t](...)
	end
}

return gate
