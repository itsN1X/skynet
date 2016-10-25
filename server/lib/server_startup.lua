local fish = require "fish"
local skynet = require "skynet"
local csv = require "config.csvloader"

local _server_id = nil
local _service_mgr = {}

local _M = {}

function _M.start(id,console,http,mongodb,csvpath)
	fish.register(".startup")

	_server_id = id
	skynet.newservice("service_helper")
	skynet.newservice("script_manager")

	if console ~= nil then
		skynet.newservice("debug_console",console)
	end
	if http ~= nil then
		fish.newservice("http","http/http_boot",http)
	end
	if mongodb ~= nil then
		_M.create_service("mongodb","mongodb/mongodb_boot","127.0.0.1","10105")
	end
	time_recorder:begin("csv.load(csvpath)")
	if csvpath ~= nil then
		csv.load(csvpath)
	end
	time_recorder:over("csv.load(csvpath)")
end

function _M.create_service(name,file,...)
	local handle = fish.newservice(name,file,...)
	_service_mgr[handle] = {handle = handle,name = name,file = file,args = table.pack(...)}
	return handle
end

function _M.init_all_service()
	for handle,start_info in pairs(_service_mgr) do
		fish.initservice(handle)
	end
end

return _M