local fish = require "fish"
local serv = fish.require "remote_team.remote_team_serv"

fish.register_message("connected",	serv.connected)
fish.register_message("closed",	serv.closed)