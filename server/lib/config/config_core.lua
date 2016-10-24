local core = require "sharedata.core"
local type = type
local next = next
local rawget = rawget
local setmetatable = setmetatable

local conf = {}

conf.new = core.new
conf.delete = core.delete

local meta = {}

local index = core.index
local len = core.len
local nextkey = core.nextkey

function meta:__index(key)
	local obj = self.__obj
	local v = index(obj, key)
	if type(v) == "userdata" then
		local r = setmetatable({__obj = v,__root = self.__root}, meta)
		self[key] = r
		return r
	else
		return v
	end
end

function meta:__len()
	return len(self.__obj)
end

function meta:__pairs()
	return conf.next, self, nil
end

function conf.next(obj, key)
	local cobj = obj.__obj
	local nk = nextkey(cobj, key)
	if nk then
		return nk, obj[nk]
	end
end

function conf.box(obj,root)
	return setmetatable({__obj = obj,__root = root} , meta)
end


return conf