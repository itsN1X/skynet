local skynet = require "skynet"
local core = require "leveldb"
skynet.start(function ()
	local db = core.create()
end)