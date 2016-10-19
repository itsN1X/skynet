local fish = require "fish"
local connector = require "connector"
local util = require "util"

local _ip,_port = ...


local channel_mgr = {}


fish.register_message("socket_connected",function (id,address)
	connector.send(id,"remote_test","ping",{a = 1,b = 2})
end)

fish.register_message("socket_close",function (id)
	print("socket_close",id)
end)

fish.register_message("socket_error",function (id)
	print("socket_error",id)
end)

fish.register_message("socket_data",function (id,method,data)
	util.dump_table(data)
	connector.close(id)
end)


fish.start(function ()

	local id = connector.connect(_ip,tonumber(_port))

end,function (source,...)
	fish.error("stop",...)
end,function (source,...)
	fish.error("init",...)
end)
