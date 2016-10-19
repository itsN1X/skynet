local fish = require "fish"
local serv = fish.require "remote_interaction.remote_interaction_serv"

fish.register_message("connected",	serv.connected)
fish.register_message("closed",	serv.closed)