local skynet = require "skynet"
local fish = require "fish"

skynet.register_protocol {
	name = "text",
	id = skynet.PTYPE_TEXT,
	pack = function(...) return ... end,
	unpack = skynet.tostring,
}

local _service_mgr = {}

local function start_service(name,file,...)
	local handle = fish.new_service(name,file,...)
	_service_mgr[handle] = {handle = handle,name = name,file = file,args = table.pack(...)}
	return handle
end

local function init_all_service()
	for handle,start_info in pairs(_service_mgr) do
		fish.init_service(handle)
	end
end

skynet.start(function ()
	skynet.newservice("service_helper")
	local inst = skynet.launch("connector")
	skynet.send(inst,"text","connect 127.0.0.1 10105")
	-- local handle = start_service("login","login/login_boot")
	-- start_service("gate","gate_client",handle,10109,1000)
	-- start_service("agent","agent/agent")
	-- start_service("mongodb","mongodb/mongodb_boot","127.0.0.1",10105)
	-- start_service("http","http/http_boot",1989)
	-- init_all_service()
end)