local core = require "config"
local config_core = require "config.config_core"
local skynet = require "skynet"

local setmetatable = setmetatable
local rawget = rawget
local tinsert = table.insert
local pack = table.pack
local unpack = table.unpack
local pairs = pairs

local core_new = config_core.new
local core_delete = config_core.delete
local core_search = core.search

local _obj
local _csvtbl = {}
local _meta_cache = {}
local _meta_index = {}

local config = {}


function config:init(datas)
   _csvtbl = {}
   local cnt = 1
   for name,data in pairs(datas) do
        _csvtbl[name] = cnt
        cnt = cnt + 1
    end

    _obj = core.init(cnt-1,function (obj)
        for name,data in pairs(datas) do
            core.add(obj,_csvtbl[name],name,core_new(data))
        end
    end)
    assert(false,_obj)
end


function config:load(datas)
    local tbl = {}
    for name,data in pairs(datas) do
        tinsert(tbl,name)
    end

    for i,name in pairs(tbl) do
        _csvtbl[name] = i
    end
    _obj = core.singleton(#tbl)

    core.load(_obj,function ()
        for _,name in pairs(tbl) do
            core.add(_obj,_csvtbl[name],name,core_new(datas[name]))
        end
    end)
end

function config:find(name,...)--如果不加参数就是整个表，可以for
    local index = _csvtbl[name]
    if index == nil then
        return
    end

    local data = core_search(_obj,index,core_delete)
    -- local meta = config_core.box(data[1])
    local meta = _meta_cache[data[1]]
    if meta == nil then
        meta = config_core.box(data[1],data)
        _meta_cache[data[1]] = meta

        local odata = _meta_index[index]
        if odata ~= nil then
            if _meta_cache[odata[1]] ~= nil then
                _meta_cache[odata[1]] = nil
            end
        end
        _meta_index[index] = data
    end

    local n = select("#",...)
    local val = meta
    for i =1,n do
        val = val[select(i,...)]
    end
    return val
end

function config:reload(name,data)
    core.update(_obj,_csvtbl[name],core_new(data),core_delete)
end

function config:dump()
    core.dump(_obj)
end

function config:get_all_name()
    return _csvtbl
end

return config
