local fish = require "fish"

local function start(...)

end

local function stop(...)

end

fish.start(start,stop)

fish.dispatch("lua",function (_, address, method, id, args, fallback)
	fish.dispatch_message(methd,args)
end)

fish.dispatch("gate",function (_, address, id, msg, sz)
	fish.dispatch_message(id,msg,sz)
end)