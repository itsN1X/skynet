local fish = require "fish"
local util = require "util"
local function start(...)

end

local function stop(...)

end

fish.start(start,stop)

fish.register_message("ping",function (source,args)
	util.dump_table(args)
end)
