local util = require "util"
local _M = {}


function _M.enter(source,args)
	util.dump_table(args,"enter")
end

function _M.leave(source,args)
	util.dump_table(args,"leave")
end

function _M.auth(fd,args)
	util.dump_table(args,"auth")
end

function _M.relogin(...)

end

function _M.enter_game(...)

end

print("reload serv")
return _M