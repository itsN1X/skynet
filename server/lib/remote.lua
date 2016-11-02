local fish = require "fish"

local _M = {}

function _M.forward_gate(handle,service_handle,method,args)
	local data,size = fish.pack({message = "forward_service_handle",args = {service_handle,method,args}})
	fish.send(handle,"forward_service_handle",data,size)
end

function _M.forward_gate_name(handle,service,method,args)
	local data,size = fish.pack({message = "forward_service_name",args = {service,method,args}})
	fish.send(handle,"forward_service_name",data,size)
end

function _M.forward_client(client,handle,method,args)
	fish.raw_send(client,"client",fish.pack({method = "forward_service_handle",content = {handle,method,args}}))
	
end

function _M.forward_client_name(client,service,method,args)
	fish.raw_send(client,"client",fish.pack({method = "forward_service_name",content = {service,method,args}}))
end

return _M