require "lfs"
local core = require "util.core"
local json = require "cjson"


local _M = setmetatable({},{__index = core})

local function get_type_first_print( t )
    local str = type(t)
    return string.upper(string.sub(str, 1, 1))..":"
end

function _M.dump_table(t, prefix, indent_input,print)
    local indent = indent_input
    if indent_input == nil then
        indent = 1
    end

    if print == nil then
        print = _G["print"]
    end

    local p = nil

    local formatting = string.rep("    ", indent)
    if prefix ~= nil then
        formatting = prefix .. formatting
    end

    if t == nil then
        print(formatting.." nil")
        return
    end

    if type(t) ~= "table" then
        print(formatting..get_type_first_print(t)..tostring(t))
        return
    end

    local output_count = 0
    for k,v in pairs(t) do
        local str_k = get_type_first_print(k)
        if type(v) == "table" then

            print(formatting..str_k..tostring(k).." -> ")

            _M.dump_table(v, prefix, indent + 1,print)
        else
            print(formatting..str_k..tostring(k).." -> ".. get_type_first_print(v)..tostring(v))
        end
        output_count = output_count + 1
    end

    if output_count == 0 then
        print(formatting.." {}")
    end
end

local function get_suffix(filename)
    return filename:match(".+%.(%w+)$")
end

function _M.find_dir_files(r_table,path,suffix,is_path_name,recursive)
    for file in lfs.dir(path) do
        if file ~= "." and file ~= ".." then
            local f = path..'/'..file

            local attr = lfs.attributes (f)
            if type(attr) == "table" and attr.mode == "directory" and recursive then
                _M.find_dir_files(r_table, f, suffix, is_path_name, recursive)
            else
                local target = file
                if is_path_name then target = f end

                if suffix == nil or suffix == "" or suffix == get_suffix(f) then
                    table.insert(r_table, target)
                end
            end
        end
    end
end

function _M.spilt(str,delimiter)
    if str == nil or str == "" or delimiter == nil then
        return false,"error arg1 or arg2"
    end

    local result = {}
    local pattern = string.format("(.-)%s",delimiter)
    local hole = string.format("%s%s",str,delimiter)
    for match in hole:gmatch(pattern) do
        table.insert(result,match)
    end

    return result
end

--十进制右边数起第b位
function _M.decimal_bit(value,b)
    return math.modf((value % (10^b)) / (10^(b-1)))
end

--十进制右边数起第from到to位的数字
function _M.decimal_sub(value,from,to)
    local result = 0
    for i=from,to do
        local var = _M.decimal_bit(value,i)
        result = result + var * 10^(i-from)
    end
    return result
end

function _M.encode_token(args,key,expiry)
    local json_string = json.encode(args)
    local stream = core.authcode(json_string,key,true,expiry)
    if stream == nil then
        return
    end
    return stream
end

function _M.decode_token(token,key,expiry)
    local jsonstream = core.authcode(token,key,false,expiry)
    if jsonstream == nil then
        return nil
    end

    local token_table = json.decode(jsonstream)
    if token_table == nil then
        return nil
    end
    return token_table
end


function _M.request_center(req,center,func,args)
    local param = {
        auth = "z8k3afuqk70wkw13",
        func = func,
        args = args
    }

    local token = _M.encode_token(param,"y@dta8@AgrXe4)%+jpc;S(+NCzV1S(lE",1800)
    local status, result = req(center, "/skynet.php",{token = token}, {})

    if status ~= 200 then
        return false,string.format("request center status:%d",status)
    end

    local r = json.decode(result)
    if r.code ~= 0 then
        return false,string.format("request center code:%d,msg:%s",r.code,r.msg)
    end
    return r.data
end

return _M