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

local function findobj(path,where,obj,root,desc)
	if root == nil then
		return false
	end

	if path[root] ~= nil then
		return false
	end

	path[root] = true

	local what = type(root)
	if what == "table" then
		for k,v in pairs(root) do
			if k == obj then
				local way = string.format("%s.k(%s)",desc,tostring(k))
				table.insert(where,way)
				findobj(path,where,obj,k,way)
			else
				local way = string.format("%s.k(%s)",desc,tostring(k))
				findobj(path,where,obj,k,way)
			end

			if v == obj then
				local way = string.format("%s.(%s)v(%s)",desc,tostring(k),tostring(v))
				table.insert(where,way)
				findobj(path,where,obj,v,way)
			else
				local way = string.format("%s.(%s)v(%s)",desc,tostring(k),tostring(v))
				findobj(path,where,obj,v,way)
			end
		end
	elseif what == "function" then
		local uv_index = 1  
        while true do  
            local name, value = debug.getupvalue(root, uv_index)  
            if name == nil then  
                break  
            end 

           	if value == obj then
           		local way = string.format("%s.uv(%s)",desc,name)
				table.insert(where,way)
				findobj(path,where,obj,value,way)
           	else
           		local way = string.format("%s.uv(%s)",desc,name)
				findobj(path,where,obj,value,way)
           	end
            uv_index = uv_index + 1  
        end  
	else

	end
end

function export.findobj(obj)
	local where = {}
	local path = {}
	findobj(path,where,obj,_G,"_G")
	return where
end

local function dump(objs,root,finded)
	if objs == nil then
		return false
	end

	if root == nil then
		return false
	end

	if finded[root] ~= nil then
		return false
	end

	finded[root] = true
	
	local what = type(root)
	if what == "table" then
		objs[root] = true
		for k,v in pairs(root) do
			dump(objs,k,finded)
			dump(objs,v,finded)
		end
	elseif what == "function" then
		local uv_index = 1  
        while true do  
            local name, value = debug.getupvalue(root, uv_index)  
            if name == nil then  
                break  
            end 
           	dump(objs,value,finded)
            uv_index = uv_index + 1  
        end  
	else

	end
end

function export.dump()
	local objs = setmetatable({},{__mode = "k"})
	local finded = {}
	dump(objs,_G,finded)
	return objs
end

return export