
local fish = require "fish"
local libmongo = require "libmongo"
local util = require "util"

local mc = libmongo.new("u3d")

local _log = false
local _alive = true
local _data_mgr = {}
local _data_info = {}
local _dirty_data = {}
local _update_info = {}
local _flush_time = 60 * 100

local dataobj = {}

local _db_func = nil
local _helper_func = nil

function dataobj.init_db_func(func)
	_db_func = func
end

function dataobj.init_helper_func(func)
	_helper_func = func
end

local function init(name,id,data)
	if data._id ~= nil then
		data._id = nil
	end
	local dobj = _data_mgr[name]
	if dobj == nil then
		_data_mgr[name] = {}
		dobj = _data_mgr[name]
	end
	if dobj[id] ~= nil then
		fish.error(string.format("dataobj.init:collection:%s id:%d has init",name,id))
		local prev_data = dobj[id]
		if _data_info[prev_data] ~= nil then
			_data_info[prev_data] = nil
		end
	end
	dobj[id] = data
	assert(_data_info[data] == nil,string.format("name:%s id:%d data:%s already init",name,id,data))
	_data_info[data] = {name = name,id = id}
end

local function save(data,info)
	local db = mc.u3d
	if _db_func ~= nil then
		local mongo_client = _db_func(info.id)
		db = mongo_client.u3d
	end

	local updater = {}
	updater["$set"] = data			
	db[info.name]:update({id = info.id}, updater, true)
	if _log then
		fish.error(string.format("dataobj:%s->%s update to database",info.name,info.id))
	end

	if _helper_func ~= nil then
		pcall(_helper_func,info.id,info.name,data)
	end
end

function dataobj.init(name,id,data)
	init(name,id,data)
end

function dataobj.add(name,id,data)
	init(name,id,data)
	dataobj.dirty(data)
end

function dataobj.remove(name,id)
	if _data_mgr[name] ~= nil and _data_mgr[name][id] ~= nil then
		local data = _data_mgr[name][id]
		_data_info[data] = nil
		_dirty_data[data] = nil
		_data_mgr[name][id] = nil
	else
		fish.error(string.format("dataobj.remove: name %s id:%d  not find",name,id))
	end
end

function dataobj.remove_name(name)
	if _data_mgr[name] ~= nil then
		for id,data in pairs(_data_mgr[name]) do
			local data = _data_mgr[name][id]
			_data_info[data] = nil
			_dirty_data[data] = nil
		end
		_data_mgr[name] = {}
	end
end

function dataobj.remove_all(id)
	for name,dobj in pairs(_data_mgr) do
		local data = dobj[id]
		if data ~= nil then
			dobj[id] = nil
			_data_info[data] = nil
			_dirty_data[data] = nil
		end
	end
end

function dataobj.get(name,id)
	return _data_mgr[name][id]
end

function dataobj.flush(data)
	if _dirty_data[data] == nil then
		return
	end

	_dirty_data[data] = nil

	local info = _data_info[data]
	if info ~= nil then
		local r,err = xpcall(save,util.traceback,data,info)
		if not r then
			fish.error(string.format("save collection:%s error",info.name))
			fish.error(err)
			util.dump_table(data,info.name,nil,fish.error)
		end
	end
	
end

function dataobj.flush_all()
	if _alive == false then
		return
	end
	fish.timeout(_flush_time,function () dataobj.flush_all() end)

	for data,_ in pairs(_dirty_data) do
		local info = _data_info[data]
		if info == nil then
			util.dump_table(data,"error data",nil,fish.error)
		else
			local r,err = xpcall(save,util.traceback,data,info)
			if not r then
				fish.error(string.format("save collection:%s error",info.name))
				fish.error(err)
				util.dump_table(data,info.name,nil,fish.error)
			end
		end
	end

	for _,value in pairs(_update_info) do
		local info = value
		local data = value.data
		local r,err = xpcall(save,util.traceback,data,info)
		if not r then
			fish.error(string.format("update collection:%s error",info.name))
			fish.error(err)
			util.dump_table(data,info.name,nil,fish.error)
		end
	end

	_update_info = {}
	_dirty_data = {}
end

function dataobj.dirty(data)
	assert(_data_info[data] ~= nil,string.format("data:%s must be init or add",data))
	_dirty_data[data] = true
end

function dataobj.update(name, id, data, uType)
	local key = name..tostring(id)
	if uType ~= nil then
		key = key..uType
	end
	local value = {}
	value.data = data
	value.name = name
	value.id = id
	_update_info[key] = value
end

function dataobj.dead()
	_alive = false
end

function dataobj.set_flush_time(time)
	if time == nil or time <= _flush_time then
		return
	end

	_flush_time = time
end

function dataobj.dump()
	for k,v in pairs(_data_info) do
		print(k,v.name,v.id)
	end
end

math.randomseed(fish.self())  
fish.timeout(math.random(1,1000000)%_flush_time,function () dataobj.flush_all() end)

_G["_DATA_DIRTY"] = function (data)
	dataobj.dirty(data)
end

_G["_DATA_UPDATE"] = function (name, id, data, uType)
	dataobj.update(name, id, data, uType)
end

return dataobj