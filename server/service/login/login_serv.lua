local util = require "util"
local fish = require "fish"
local mongodb = require "libmongo"
local model = require "login.login_model"
local minheap = require "minheap"
local queue_lock = require "skynet.queue"

local logic = fish.require "login.login_logic"

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
    local info = model.login_mgr[args.fd]
    if info.agent ~= nil then
        local lock = model.account_lock[info.account]
        lock(function ()
            _M.leave_agent(args.fd)
            model.login_mgr[args.fd] = nil
        end)
    else
        local lock = model.account_lock[info.account]
        if lock ~= nil then
            lock(function ()
                model.login_mgr[args.fd] = nil
            end)
        else
            model.login_mgr[args.fd] = nil
        end
    end
	
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

    local login_info = model.login_mgr[fd]
	if login_info == nil then
        kick_fd(fd)
        error(string.format("fd:%d not enter",fd))
    end

    local info = util.decode_token(args.token,"y@dta8@AgrXe4)%+jpc;S(+NCzV1S(lE",43200)
    if info == nil then
        kick_fd(fd)
        error(string.format("fd:%d auth failed",fd))
    end

    print("auth",info.account)

    model.login_mgr[fd].auth = true

    login_info.account = info.account
    local lock = model.account_lock[info.account]
    if lock == nil then
        lock = queue_lock()
        model.account_lock[info.account] = lock
    end

    if login_info.agent ~= nil then
        lock(function ()
            _M.leave_agent(fd)
            logic.auth(fd,info.account)
        end)
    else
        lock(function ()
            logic.auth(fd,info.account)
        end)
    end
end

function _M.enter_agent(fd,id)
    local info = login_mgr[fd]
    info.agent = model.agent_pool:pop()
    fish.send(info.agent,"enter",{id = args.id})
    info.id = id
end

function _M.leave_agent(fd)
    local info = login_mgr[fd]
    fish.send(info.agent,"leave",{id = info.id})
    model.agent_pool:push(agent)
    info.agent = nil
    info.id = nil
end

return _M