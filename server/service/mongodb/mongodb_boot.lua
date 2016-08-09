local fish = require "fish"
local serv = require "mongodb.mongodb_serv"

local ip,port = ...
local function start()
	serv.start(ip,tonumber(port))
end

local function stop()
	serv.stop()
end

fish.start(start,stop)
