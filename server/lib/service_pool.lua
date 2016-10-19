local fish = require "fish"
local skynet = require "skynet"
local lock = require "skynet.queue"


local _M = {}


local meta = {}


local function try_pop(self)
	for i = 0,self.cnt - 1 do
		while true do
			local handle = next(self.pool[i])
			if handle == nil then
				break
			end
			self.pool[i][handle] = nil
			self.pool[i+1][handle] = 0
			self.handleinfo[handle] = {pool = self.pool,index = i+1}
			return handle
		end
	end
	return
end

local function expand(self,cap)
	if self.cap == cap then
		return
	end
	
	local add = cap - self.cap
	for i = 1,add do
		local handle = fish.newservice("agent",self.file,table.unpack(self.args))
		ctx.pool[0][handle] = 0
	end
	self.cap = cap
end

function meta:push(handle)
	local where = self.handleinfo[handle]
	where.pool[where.index][handle] = nil
	where.pool[where.index-1][handle] = 0
	if where.index - 1 == 0 then
		self.handleinfo[handle] = nil
	else
		self.handleinfo[handle] = where.index-1
	end
end

function meta:pop()
	local handle = try_pop(self)
	if handle ~= nil then
		return handle
	end
	while handle == nil do
		self.lock(expand,self.cap + 5)
		handle = try_pop()
	end
	return handle
end

function meta:new()
	local npool = {}
	for i=0,ctx.cnt do
		npool[i] = {}
	end

	for i=1,ctx.cap do
		local handle = fish.newservice("agent",file,table.unpack(self.args))
		npool[0][handle] = 0
	end
	npool.next = self.pool
	self.pool = npool
end

function meta:foreach(func)
	local has_earch = {}
	local pool = self.pool
	while pool ~= nil do
		for i = 0,self.cnt do
			for handle,_ in pairs(pool[i]) do
				if has_earch[handle] == nil then
					has_earch[handle] = 0
					func(handle,i)
				end
			end
		end
		pool = pool.next
	end
end

function meta:dump()
	local logs = {">>"}
	table.insert(logs,string.format("file:%s",self.file))
	table.insert(logs,string.format("cap:%d",self.cap))
	table.insert(logs,string.format("cnt:%d",self.cnt))

	self:foreach(function (handle,cnt)
		table.insert(logs,string.format("%s:%d",tostring(skynet.address(handle)),cnt))
	end)

	fish.error(table.concat(logs,"\r\n"))
end

function _M.create(file,cap,cnt,...)
	local ctx = setmetatable({},{__index = meta})
	ctx.file = file
	ctx.cap = cap
	ctx.cnt = cnt
	ctx.lock = lock()
	ctx.args = {...}
	ctx.handleinfo = {}
	ctx.pool = {}
	for i=0,ctx.cnt do
		ctx.pool[i] = {}
	end
	for i=1,ctx.cap do
		local handle = fish.newservice("agent",file,...)
		ctx.pool[0][handle] = 0
	end
	return ctx
end

return _M