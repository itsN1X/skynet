local core = require "timerheap"

local export = {}


local meta = {}

function meta:push(ud,value)
	assert(ud ~= nil and value ~= nil)
	local id = core.push(self.__heap,value)
	self.__element_mgr[id] = ud
end

function meta:pop(max)
	local result = {}
	while true do
		local id = core.pop(self.__heap,max)
        if id == nil then
            break
        end
        local ud = self.__element_mgr[id]
        table.insert(result,ud)
        self.__element_mgr[id] = nil
	end
	return result
end

function export.create(compare)
	local ctx = {}
	ctx.__heap = core.create()
	ctx.__element_mgr = {}
	setmetatable(ctx,{__index = meta})
	return ctx
end

return export