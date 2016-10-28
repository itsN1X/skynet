local util = require "util"
local fish = require "fish"
local mongodb = require "libmongo"
local model = require "login.login_model"
local timerheap = require "timerheap"
local _M = {}



function _M.start(source,args)
    model.heap_ctx = timerheap.create()
	model.gate = args.gate
	model.db = mongodb.new("u3d")
	fish.schedule_timer(100,"update")
end

function _M.enter(source,args)
	util.dump_table(args,"enter")
	model.login_mgr[args.fd] = {addr = args.addr,client = args.client,time = fish.time(),kick = false,auth = false}
    local info = model.login_mgr[args.fd]
    local heapid = timerheap.push(model.heap_ctx,info.time + 10)
    model.heap_mgr[heapid] = args.fd
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
    while true do
        local heapid = timerheap.pop(model.heap_ctx,now)
        if heapid == nil then
            break
        end
        local fd = model.heap_mgr[heapid]
        local info = model.login_mgr[fd]
        if info ~= nil then
            if not info.auth then
                kick_fd(fd,fish.make_message("CloseNty",{id = 2}))
            end
        end
        model.heap_mgr[heapid] = nil
    end
end

function _M.auth(fd,args)
	if model.login_mgr[fd] == nil then
        kick_fd(fd)
        error(string.format("fd:%d not enter",fd))
    end
    util.dump_table(args,"auth")
    local info = util.decode_token(args.token,"y@dta8@AgrXe4)%+jpc;S(+NCzV1S(lE",43200)
    if info == nil then
         kick_fd(fd)
         error("error token:"..args.token)
    end

    local info = {account = args.token}

    local login_info = model.login_mgr[fd]
    login_info.auth = true
    login_info.account = info.account
    login_info.sdkId = info.sdk_id
    login_info.userId = info.user_id
    login_info.channelId = info.channel_id
    login_info.dbInstance = dbInstance
    login_info.dbIndex = dbIndex
    login_info.auth = true
    login_info.uuid = args.uuid
    login_info.system = args.system
    login_info.device = args.device
    login_info.network = args.network
    login_info.entryId = args.entryId

    local rfields = {
        id = 1,
        level = 1,
        nick = 1,
        career = 1,
        avatar = 1,
        deleteTime = 1,
        actorId = 1,
        createTime = 1,
        hiddenWing = 1,
        exitTime = 1;
    }

    local rolelist = model.db.role:findAll({account = info.account, entryId = info.entryId, is_del = 0},rfields)
  
    fish.send_client(login_info.client,"OnAuth",{rolelist = login_info.rolelist})
end

function _M.relogin(...)

end

function _M.enter_game(...)

end

print("reload serv")
return _M