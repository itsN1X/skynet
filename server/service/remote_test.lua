local fish = require "fish"
local util = require "util"
local function start(...)

end

local function stop(...)

end

fish.start(start,stop)

fish.register_message("ping",function (source,client,args)
	util.dump_table(args,"ping")
	fish.raw_send(client,"client",fish.pack({method = "forward_service",content = {"remote_test","pong",args}}))
end)

fish.register_message("pong",function (source,args)
	util.dump_table(args,"pong")
end)

