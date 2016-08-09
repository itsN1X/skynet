local skynet = require "skynet"
require "skynet.manager"
local codecache = require "skynet.codecache"

local fish = {
	PTYPE_FISH = 100,
	PTYPE_GATE = 101
}

skynet.register_protocol {
	name = "fish",
	id = fish.PTYPE_FISH,
	pack = skynet.pack,
	unpack = skynet.unpack,
}

skynet.register_protocol {
	name = "gate",
	id = fish.PTYPE_GATE,
	pack = skynet.pack,
	unpack = skynet.unpack,
}


local system = {}

local _init_func
local _stop_func
local _route = {}
local _alive = false
local _script_mgr = {}
local _handle_mgr = {}


function system.init(source,...)
	assert(_init_func ~= nil,"no init func")
	fish.ret(_init_func(source,...))
end

function system.stop(source,...)
	assert(_stop_func ~= nil)
	fish.ret(_stop_func(source,...))
	_alive = false
	skynet.exit()
end

function system.set_handle(source,list)
	for name,handle in pairs(list) do
		if handle == 0 then
			_handle_mgr[name] = nil
		else
			_handle_mgr[name] = handle
		end
	end
end

function system.reload(source,list)
	codecache.clear()

	for _,path in pairs(list) do
		local info = _script_mgr[path]
		assert(info ~= nil,string.format("no such scirpt:%s",path))

		package.loaded[path] = nil
		local module = require(path)

		for name,value in pairs(module) do
			info.proxy[name] = value
		end

		setmetatable(info.proxy,{__index = function (self,method)
			local func = module[method]
			self[method] = func
			return func
		end})
	end
end

function fish.require(path)
	local module = require(path)

	local result = setmetatable({},{__index = function (self,method)
		local func = module[method]
		self[method] = func
		return func
	end})
	
	_script_mgr[path] = {proxy = result,module = module}	
	return result
end

function fish.new_service(name,file,...)
	local handle = fish.call(".service_helper","new_service",name,file,...)
	return handle
end

function fish.init_service(handle,...)
	local r = fish.call(".service_helper","init_service",handle,...)
	return r
end

function fish.stop_service(handle,...)
	local r = fish.call(".service_helper","stop_service",handle,...)
	return r
end

function fish.reload_service(handle,...)
	return skynet.call(handle,"fish","reload",...)
end

function fish.set_handle(handle,list)
	skynet.send(handle,"fish","set_handle",list)
end

function fish.handle(name)
	return _handle_mgr[name]
end

function fish.dump_handle()
	for k,v in pairs(_handle_mgr) do
		print(k,v)
	end
end

fish.self = skynet.self
fish.time = skynet.time
fish.now = skynet.now
fish.dispatch = skynet.dispatch
fish.error = skynet.error
fish.name = skynet.name
fish.register = skynet.register

local core_send = skynet.send
local core_call = skynet.call

fish.raw_send = core_send
fish.raw_call = core_call

function fish.ret(...)
	skynet.ret(skynet.pack(...))
end

function fish.dispatch_message(source,method,...)
	if not _alive then
		return
	end
	local func = _route[method]
	assert(func ~= nil,string.format("no such method:%s",method))
	return func(source,...)
end

function fish.schedule_timer(ti,cmd,...)
	local args = {...}
	skynet.timeout(ti,function () 
		fish.dispatch_message(0,cmd,table.unpack(args))
	end)
end

function fish.start(start_func,stop_func,init_func)
	assert(start_func ~= nil,string.format("no start func"))
	assert(stop_func ~= nil,string.format("no stop func"))
	_stop_func = stop_func
	_init_func = init_func
	skynet.start(function ()
		start_func()
	end)
	_alive = true
end


function fish.send(handle,method,...)
	core_send(handle,"lua",method,...)
end

function fish.call(handle,method,...)
	return core_call(handle,"lua",method,...)
end

function fish.send_client(client,cmd,args)

end

function fish.broadcast_client(clients,cmd,args)

end

function fish.register_message(cmd,func)
	assert(_route[cmd] == nil)
	_route[cmd] = func
end

skynet.dispatch("lua", function (_, address, method, ...)
	fish.dispatch_message(address, method, ...)
end)

skynet.dispatch("fish", function (_, address, cmd, ...)
	local f = system[cmd]
	if f ~= nil then
		f(source,...)
	else
		error("Unknow command:"..cmd)
	end
end)

skynet.dispatch("gate", function (_, address, id, msg, sz)
	fish.dispatch_message(address,id,msg,sz)
end)

_G["require_script"] = fish.require

return fish
