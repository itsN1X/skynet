local fish = require "fish"

local _M = {}

function _M.send_gate_name(handle,service,method,args)
	fish.send(handle,"forward_service_name",service,method,args)
end

function _M.send_gate_handle(handle,service_handle,method,args)
	fish.send(handle,"forward_service_handle",service_handle,method,args)
end

function _M.send_client_name(client,service,method,args)
	fish.raw_send(client,"client",fish.pack({method = "forward_service_name",content = {service,method,args}}))
end

return _M