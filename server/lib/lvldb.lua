local db_c = require "leveldb"
local fish = require "fish"
local meta = {}

function meta:put(key,value)
	return db_c.put(self.__core,key,fish.pack(value))
end

function meta:get(key)
	local code,result = db_c.get(self.__core,key)
	if not code then
		return false,result
	end
	return true,fish.unpack(result)
end


local _M = {}

function _M.create(path)
	local ctx = {__core = db_c.create()}
	return setmetatable(ctx,{__index = meta,__gc = function (self)
		db_c.delete(self.__core)
	end})
end

return _M