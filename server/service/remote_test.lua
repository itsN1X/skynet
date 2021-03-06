local fish = require "fish"
local util = require "util"
local remote = require "remote"
local function start(...)

end

local function stop(...)

end

fish.start(start,stop)

fish.register_message("ping",function (source,client,args)
	util.dump_table(args,"ping")
	remote.forward_client_name(client,"remote_test","pong",args)
end)

fish.register_message("pong",function (source,args)
	util.dump_table(args,"pong")
end)

fish.register_message("req",function (source,client,args)
	util.dump_table(args,"req")
	remote.forward_client(client,args.handle,"rsp",args)
end)

fish.register_message("rsp",function (source,args)
	util.dump_table(args,"rsp")
end)