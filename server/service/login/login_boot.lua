local fish = require "fish"
local queue = require "skynet.queue"
local util = require "util"
local login_serv = require_script "login.login_serv"

local function start(...)

end

local function stop(...)

end

fish.start(start,stop)

local _login_mgr = {}
local _account_mgr = {}

fish.register_message("enter",function (source,args)
	_login_mgr[args.fd] = {fd = args.fd,addr = args.addr}
end)

fish.register_message("leave",function (source,args)
	_login_mgr[args.fd] = nil
end)

fish.register_message("auth",function (fd,args)
	local account_info = _account_mgr[args.account]

	if account_info == nil then
		account_info = {}
		account_info.account = args.account
		account_info.queue = queue()
		_account_mgr[args.account] = account_info
		account_info.queue(login_serv.login,fd,args)
	else
		

	end
	
end)

fish.dispatch("gate",function (_, address, fd, msg, sz)
	fish.dispatch_message(id,msg,sz)
end)