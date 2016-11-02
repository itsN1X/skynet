local dbutil = require "mongodb.mongodb_util"

local register = dbutil.register
local register_agent = dbutil.register_agent

register("role",{{"id",unique = true},{"id","account",unique = true}})
register("test1",{{"id",unique = true}})
register("test2",{})


register_agent("role")
