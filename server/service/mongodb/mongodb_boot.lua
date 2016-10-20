local fish = require "fish"
local serv = fish.require "mongodb.mongodb_serv"

local ip,port = ...
local function start()
	serv.start(ip,tonumber(port))
	fish.register(".mongodb")
end

local function stop()
	serv.stop()
end

fish.start(start,stop)
