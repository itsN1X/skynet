local core = require "timerheap"
local fish = require "fish"

local _M = {}

local meta = {}

function meta:timeout(ti,cmd,args)
	local id = core.push(self.inst,expire)
	self.funclist[id] = {cmd = cmd,args = args}
end

function meta:update(now)
	while true do
		local id = core.pop(self.inst,now)
		if id ~= nil then
			local info = self.funclist[id]
			assert(info ~= nil)
			fish.dispatch_message(id,info.cmd,info.args)
		else
			break
		end
	end
end

function _M.create(id)
	local obj = setmetatable({},{__index = self})
	obj.inst = core.create()
	obj.funclist = {}
	obj.id = id
	return obj
end


return _M