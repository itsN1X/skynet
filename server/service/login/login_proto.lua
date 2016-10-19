local fish = require "fish"
local serv = fish.require "login.login_serv"

fish.register_message("enter",	serv.enter)
fish.register_message("leave",	serv.leave)


fish.register_message(10001,	serv.Auth,			"SoulProtocol.AuthReq")
fish.register_message(10002,	serv.CreateRole,	"SoulProtocol.AuthReq")
fish.register_message(10003,	serv.DeleteRole,	"SoulProtocol.DeleteRoleReq")
fish.register_message(10004,	serv.CreateName,	"SoulProtocol.CreateNameReq")
fish.register_message(10005,	serv.EnterGame,		"SoulProtocol.EnterGameReq")
fish.register_message(10006,	serv.HeartBeat,		"SoulProtocol.HeartBeatReq")
fish.register_message(10007,	serv.SyncStamp,		"SoulProtocol.SyncStampReq")
fish.register_message(10008,	serv.RecoverRole,	"SoulProtocol.DeleteRoleReq")


fish.register_reponse("OnAuth",40000,"SoulProtocol.AuthMsg")
fish.register_reponse("OnCreateName",40003,"SoulProtocol.AuthMsg")

print("reload")