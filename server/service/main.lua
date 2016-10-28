local fish = require "fish"
local util = require "util"
local startup = require "server_startup"
local remote = require "remote"
fish.start(function ()
	
	startup.start(1,7777,9999,"127.0.0.1:10105","./server/csv","./server/pb")
	startup.create_service("agent_mgr","agent_mgr")
	local login = startup.create_service("login","login/login_boot")
	local gate = startup.create_service("gate","gate_client")
	local remote_test = startup.create_service("remote_test","remote_test")
	local remote_gate = startup.create_service("remote_gate","remote_gate","mrq",8888)
	local remote_client = startup.create_service("remote_client","remote_client","remote_interaction.remote_interaction_proto","mrq","127.0.0.1","8888")
	local remote_team = startup.create_service("remote_team","remote_client","remote_team.remote_team_proto","mrq","127.0.0.1","8888")
	remote.send_gate_name(remote_client,"remote_test","ping",{a = 1,b = 2})
	remote.send_gate_handle(remote_team,remote_test,"req",{handle = remote_test,c = 3,b = 4})

	fish.send(login,"start",{gate = gate})
	fish.send(gate,"listen",{login = login,port = 10100,maxclient = 10000})
end,function ()
	fish.error("stop")
	startup.stop()
end)