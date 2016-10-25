local time = require "time"

local export = {}

local time_meta = {}

local function fetchctx(self,key)
	local ctx = self.__ctxs[key]
	if ctx == nil then
		ctx = {}
		ctx.cnt = 0
		ctx.max_time = 0
		ctx.total_time = 0
		self.__ctxs[key] = ctx
	end
	return ctx
end

function time_meta:begin(key)
	local ctx = fetchctx(self,key)
	ctx.start = time.fetch_usec_time()
end

function time_meta:over(key)
	local now = time.fetch_usec_time()
	local ctx = fetchctx(self,key)
	local cost = now - ctx.start
	ctx.total_time = ctx.total_time + cost
	ctx.cnt = ctx.cnt + 1
	if ctx.max_time < cost then
		ctx.max_time = cost
	end
	ctx.start = nil
end

function time_meta:report()
	local list = {}
	for key,info in pairs(self.__ctxs) do
		table.insert(list,{method = key,avg = info.total_time/info.cnt,max = info.max_time,cnt = info.cnt})
	end
	table.sort(list,function (l,r)
		return l.avg > r.avg
	end)
	local logs = {}
	table.insert(logs,"\r\n")
	table.insert(logs,string.format("-------------------------------------time recorder-------------------------------------"))
	table.insert(logs,string.format("%-25s%-25s%-25s%-25s","method","AVG","AVG-MAX","count"))
	for _,info in pairs(list) do
		table.insert(logs,string.format("%-25s%-25f%-25f%-25d",info.method,info.avg,info.max,info.cnt))
	end
	table.insert(logs,string.format("-------------------------------------------*-------------------------------------------"))
	print(table.concat(logs,"\r\n"))
end

function export.create_timerecorder()
	return setmetatable({__ctxs = {}},{__index = time_meta})
end

return export