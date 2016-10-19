local fish = require "fish"
local agent = require "agent"

local tremove = table.remove
local tinsert = table.insert

local _M = {}

local _timer_mgr = {}
local _counter = 1
local _idpool = {}

local function pop()
	if #_idpool == 0 then
		local id = _counter
		_counter = _counter + 1
		return id
	end
	return tremove(_idpool)
end

local function push(id)
	tinsert(_idpool,id)
end

local function find_timer(id)
	local timer = _timer_mgr[id]
	if timer == nil then
		_timer_mgr[id] = {}
		timer = _timer_mgr[id]
	end
	return timer
end

function _M.schedule_timer(ti,id,cmd,args)
	local timer = find_timer(id)
	local tid = pop()
	timer[tid] = true

	fish.timeout(ti,function ()
		local timer = _timer_mgr[id]
		if timer == nil then
			push(tid)
			return
		end
		local flag = timer[tid]
		if flag == nil then
			push(tid)
			return
		end
		agent.dispatch_agent_message(id,cmd,args)
		push(tid)
	end)

end

function _M.cancel(id)
	_timer[id] = nil
end

return _M