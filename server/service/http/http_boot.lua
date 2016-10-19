local fish = require "fish"
local httphelper = require "httphelper"

local port = ...
local function start()
	httphelper.listen(tonumber(port))
end

local function stop(...)

end

fish.start(start,stop)

fish.register_message("test",function (source,args)
	print(args.a,args.b)
	return {name = "mrq"}
end)