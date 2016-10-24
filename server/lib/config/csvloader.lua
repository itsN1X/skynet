
local util = require "util"
local skynet = require "skynet"
local config = require "config.config_helper"
local csv2table = require "config.csv2table"
local csv_maker = require "config.csvmaker"


local function make_arr(data,header,name)
    for id,line in pairs(data) do
        local value = line[header]
        if value ~= nil then
            line[header] = nil
            if line[name] == nil then
                line[name] = {}
            end
            table.insert(line[name],value)
        end
    end
end

local function make_dic(data,header,name,index)
    for id,line in pairs(data) do
        local key = line[header]
        if key ~= nil then
            line[header] = nil
            if line[name] == nil then
                line[name] = {}
            end
            local value_text = string.format("v_%s_%s",name,index)
            local value = line[value_text]
            line[name][key] = value
            line[value_text] = nil
        end
    end
end

local function make_csv(csv,headers)
    for _,header in pairs(headers) do
        local name,index = string.match(header,"a_(.+)_(%d+)")
        if name ~= nil then
            make_arr(csv,header,name)
        else
            local name,index = string.match(header,"k_(.+)_(%d+)")
            if name ~= nil then
                make_dic(csv,header,name,index)
            end
        end
    end
    return csv
end

local _M = {}

--配置做预处理
function _M.load(dir)
    local csvs = {}

    util.find_dir_files(csvs,dir, "csv",true,false)

    local csv_tables = {}
    local csv_header = {}

    --不加载文件
    local dont_load = {
    }

    for i in pairs(csvs) do
        local _,file_name = string.match(csvs[i],"(.*)/(.*).csv")
        if dont_load[file_name] == nil then
            local data,header = csv2table.load(dir,file_name..".csv")
            csv_tables[file_name] = make_csv(data,header)
        end
    end

    for name,func in pairs(csv_maker) do
        local result = table.pack(pcall(func,csv_tables[name]))
        assert(result[1],string.format("error csv make %s,error :%s",name,result[2]))
        for i = 2,result.n do
            local data = result[i]
            csv_tables[data[1]] = data[2]
        end
    end
    config:init(csv_tables)
end

function _M.reload(dir,file)
    config:init()
    local odata,header = csv2table.load(dir,file..".csv")
    local ndata = make_csv(odata,header)
    
    local tbl = {}
    tbl[file] = ndata

    local maker_func = csv_maker[file]
    if maker_func ~= nil then
        local result = table.pack(maker_func(ndata))
        for i = 1,result.n do
            local data = result[i]
            tbl[data[1]] = data[2]
        end
    end

    for k,v in pairs(tbl) do
        config:reload(k,v)
        skynet.error("reload csv:"..k)
    end
end

return _M
