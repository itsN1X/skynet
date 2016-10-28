local skynet = require "skynet"
require "skynet.manager"
local codecache = require "skynet.codecache"
local data_collector = require "data_collector"
local protobuf = require "protobuf"
local netpack = require "netpack"
local messagehelper = require "messagehelper"

local fish = {
	PTYPE_FISH = 100,
	PTYPE_GATE = 101,
	PTYPE_AGENT = 102,
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

skynet.register_protocol {
	name = "agent",
	id = fish.PTYPE_AGENT,
	pack = skynet.pack,
	unpack = skynet.unpack,
}

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	pack = function(...) return ... end,
}

skynet.register_protocol {
    name = "text",
    id = skynet.PTYPE_TEXT,
    unpack = skynet.tostring,
    pack = function(...) return ... end,
}


local system = {}

local _init_func
local _stop_func
local _reload_func
local _route = {}
local _reponse = {}
local _alive = false
local _script_mgr = {}
local _handle_mgr = {}


function system.init(source,...)
	assert(_init_func ~= nil,"no init func")
	data_collector.func_start()
	fish.ret(_init_func(source,...))
	data_collector.func_over("service init")
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

		if type(module) == "table" then
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

	fish.ret("ok")
	if _reload_func ~= nil then
		_reload_func()
	end
end

function fish.require(file)
	local scirpt_info = _script_mgr[file]
	if scirpt_info ~= nil then
		return scirpt_info.proxy
	end

	local module = require(file)
	_script_mgr[file] = {module = module}

	local result
	if type(module) == "table" then
		result = setmetatable({},{__index = function (self,method)
			local func = module[method]
			self[method] = func
			return func
		end})
		
	end
	_script_mgr[file] = {proxy = result,module = module}
	
	fish.send(".script_manager","report",skynet.self(),file)	
	return result
end

function fish.newservice(name,file,...)
	local handle = fish.call(".service_helper","newservice",name,file,...)
	return handle
end

function fish.initservice(handle,...)
	local r = fish.call(".service_helper","initservice",handle,...)
	return r
end

function fish.stopservice(handle,...)
	local r = fish.call(".service_helper","stopservice",handle,...)
	return r
end

function fish.init_service(handle,...)
	return skynet.call(handle,"fish","init",...)
end

function fish.stop_service(handle,...)
	return skynet.call(handle,"fish","stop",...)
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
fish.now = skynet.now
fish.dispatch = skynet.dispatch
-- fish.error = skynet.error
fish.name = skynet.name
fish.register = skynet.register
fish.localname = skynet.localname
fish.pack = skynet.pack
fish.unpack = skynet.unpack
fish.launch = skynet.launch
fish.kill = skynet.kill
fish.timeout = skynet.timeout

local core_send = skynet.send
local core_call = skynet.call

fish.raw_send = core_send
fish.raw_call = core_call

function fish.time()
	return math.modf(skynet.time())
end

function fish.timestamp()
	return math.modf(skynet.time() * 1000)
end

function fish.abort(text)
	if text ~= nil then
		skynet.call(".logger","text",text)
	end
	skynet.abort()
end


function fish.ret(...)
	skynet.ret(skynet.pack(...))
end

function fish.error(...)
	skynet.error(table.concat({...},"\t"))
end

function fish.dispatch_message(source,method,...)
	if not _alive then
		return
	end
	local message_info = _route[method]
	assert(message_info ~= nil,string.format("no such method:%s",method))
	data_collector.func_start()
	message_info.handler(source,...)
	data_collector.func_over(method)
end

function fish.schedule_timer(ti,cmd,...)
	local args = {...}
	skynet.timeout(ti,function () 
		fish.dispatch_message(0,cmd,table.unpack(args))
	end)
end

function fish.start(start_func,stop_func,init_func)
	if _alive == true then
		skynet.error("already start,maybe reload")
		return
	end
	assert(start_func ~= nil,string.format("no start func"))
	assert(stop_func ~= nil,string.format("no stop func"))
	_stop_func = stop_func
	_init_func = init_func
	skynet.start(function ()
		data_collector.func_start()
		start_func()
		data_collector.func_over("service start")
	end)
	_alive = true
end


function fish.send(handle,method,...)
	core_send(handle,"lua",method,...)
end

function fish.call(handle,method,...)
	return core_call(handle,"lua",method,...)
end

function fish.send_agent(agent,id,cmd,args,fallback)
	core_send(agent,"agent",id,cmd,args,fallback)
end

function fish.make_message(cmd,args)
	local reponse_info = _reponse[cmd]
	if reponse_info == nil then
		error(string.format("no such client cmd:%s",cmd))
	end
	local pack
	if reponse_info.proto ~= nil then
		pack = protobuf.encode(reponse_info.proto,args)
	end
	local stream,sz = messagehelper.make_server_message(reponse_info.id,pack)
	return stream,sz
end

function fish.send_client(client,cmd,args)
	local stream,sz = fish.make_message(cmd,args)
	skynet.send(client,"client",stream,sz)
	data_collector.collect_message(cmd,sz)
end

function fish.broadcast_client(clients,cmd,args)
	local stream,sz = fish.make_message(cmd,args)
	local str = netpack.tostring(stream,sz)
	local cnt = 0
	for _,client in pairs(clients) do
		skynet.send(client,"client",str)
		cnt = cnt + 1
	end
	data_collector.collect_message(cmd,sz * cnt)
end

function fish.register_message(cmd,handler,proto)
	assert(handler ~= nil,string.format("register message:%s failed,handler is nil",tostring(cmd)))
	local omessage_info = _route[cmd]
	if omessage_info ~= nil then
		skynet.error(string.format("cmd:%s has register before,now reload",cmd))
	end
	_route[cmd] = {handler = handler,proto = proto}
end


function fish.register_reponse(cmd,id,proto)
	local oreponse_info = _reponse[cmd]
	if oreponse_info ~= nil then
		skynet.error(string.format("cmd:%s has register before,now reload",cmd))
	end
	_reponse[cmd] = {id = id,proto = proto}
end

function fish.reload_func(func)
	local ofunc = _reload_func
	_reload_func = func
	return ofunc
end

skynet.dispatch("lua", function (_, address, method, ...)
	fish.dispatch_message(address, method, ...)
end)

fish.dispatch("gate",function (_, address, fd, id, message)
	local body = messagehelper.read_body(message)
	local message_info = _route[id]
	if message_info == nil then
		error(string.format("no such message:%d",id))
	end
	if message_info.proto ~= nil and body ~= nil then
		local message,err = protobuf.decode(message_info.proto,body)
		if message == false then
			error(string.format("error decode id:%d,proto:%s,error:%s",id,message_info.proto,err))
		end
		fish.dispatch_message(fd,id,message)
	else
		fish.dispatch_message(fd,id,body)
	end
	messagehelper.free_buffer(msg,sz)
end)

skynet.dispatch("fish", function (_, address, cmd, ...)
	local f = system[cmd]
	if f ~= nil then
		f(source,...)
	else
		error("Unknow command:"..cmd)
	end
end)

_G["require_script"] = fish.require

return fish
