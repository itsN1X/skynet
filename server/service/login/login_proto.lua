local fish = require "fish"
local serv = fish.require "login.login_serv"

fish.register_message("start",	serv.start)
fish.register_message("enter",	serv.enter)
fish.register_message("leave",	serv.leave)
fish.register_message("update",	serv.update)

fish.register_message(10000,	serv.auth,			"SoulProtocol.AuthReq")


fish.register_reponse("OnAuth",			40000,		"SoulProtocol.AuthMsg")
fish.register_reponse("CloseNty",		40009,		"SoulProtocol.CloseFdNty")
