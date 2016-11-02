local fish = require "fish"
local service_pool = require "service_pool"
local model = require "login.login_model"
fish.require "login.login_proto"

local function start(...)
	model.agent_pool = service_pool.create("agent","agent/agent",5,20)
end

local function stop(...)

end

fish.start(start,stop)
