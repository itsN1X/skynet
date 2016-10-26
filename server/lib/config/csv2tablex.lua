local csvparser = require "csvparser"
local cjson = require "cjson"

local _M = {}


local meta = {}

function _M.create()
	local ctx = {__core = csvparser.create()}
	setmetatable(ctx,{__index = meta})
	return ctx
end

local function translate(odata)
	if _compatible == false then
		return odata
	end

	local ndata = {}

	for k,v in pairs(odata) do
		--key为number,转为string,v如果是table,必须再递归转换
		if type(k) == "number" then
			if type(v) == "table" then
				ndata[tostring(k)] = translate(v)
			else
				ndata[tostring(k)] = v
			end
		else
			if type(v) == "table" then
				ndata[k] = translate(v)
			else
				ndata[k] = v
			end
		end
	end
	return ndata
end

function meta:parse(file)
	io.input(file)
	local tbl = csvparser.parse(self.__core,io.read("*a"))

	local data = {}
	local header = {}
	for index,field_name in pairs(tbl[1]) do
		header[index] = field_name
	end

	for i = 2,#tbl do
		local line = tbl[i]
		local firstc = line[1]:sub(0,1)
		if firstc ~= "#" and firstc ~= "*" and firstc ~= "&" then
			local number_id = tonumber(line[1])
			local line_data 
			if number_id == nil then
				data[line[1]] = {}
				line_data = data[line[1]]
			else
				data[number_id] = {}
				line_data = data[number_id]
			end
			
			for index,field in ipairs(line) do
				if field:sub(1,1) == '{' or field:sub(1,1) == '[' then
					local success,result = pcall(cjson.decode,field)
					if success == false then
						assert(false,string.format("%s,line:%d,content:[%s],sub:[%s]",file,i,lines[i],ct[j]))
					end
					--为了兼容以前的老版本csv的key都是字符串,加了个translate函数
					line_data[header[index]]= translate(cjson.decode(field))
				else
					if tonumber(field) ~= nil then
						line_data[header[index]] = tonumber(field)
					else
						line_data[header[index]] = field
					end
				end
			end
		end
	end

	return data
end

return _M