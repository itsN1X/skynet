local skynet = require "skynet"
local lvldb = require "lvldb"
local util = require "util"
skynet.start(function ()
	local db = lvldb.create()
	local code,value = db:get("key")
	util.dump_table(value,"value")
end)