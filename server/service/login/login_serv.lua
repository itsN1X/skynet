local util = require "util"
local fish = require "fish"
local mongodb = require "libmongo"
local model = require "login.login_model"
local minheap = require "minheap"
local _M = {}



function _M.start(source,args)
    model.heap_ctx = minheap.create()
	model.gate = args.gate
	model.db = mongodb.new("u3d")
	fish.schedule_timer(100,"update")
end

function _M.enter(source,args)
	util.dump_table(args,"enter")
	model.login_mgr[args.fd] = {addr = args.addr,client = args.client,time = fish.time(),kick = false,auth = false}
    local info = model.login_mgr[args.fd]
    model.heap_ctx:push(args.fd,info.time + 10)
end

function _M.leave(source,args)
	util.dump_table(args,"leave")
	model.login_mgr[args.fd] = nil
end

local function kick_fd(fd,msg,sz)
	local info = model.login_mgr[fd]
	if info.kick == false then
		fish.send(model.gate,"kick",{fd = fd,msg = msg,sz = sz})
		info.kick = true
	end
end

function _M.update(source,args)
	fish.schedule_timer(100,"update")
	local now = fish.time()

    local timeout_list = model.heap_ctx:pop(now)
    for _,fd in pairs(timeout_list) do
        local info = model.login_mgr[fd]
        if info ~= nil then
            if not info.auth then
                kick_fd(fd,fish.make_message("CloseNty",{id = 2}))
            end
        end
    end
end

function _M.auth(fd,args)
	if model.login_mgr[fd] == nil then
        kick_fd(fd)
        error(string.format("fd:%d not enter",fd))
    end
    model.login_mgr[fd].auth = true
end

function _M.relogin(...)

end

function _M.enter_game(...)

end

print("reload serv")
return _M