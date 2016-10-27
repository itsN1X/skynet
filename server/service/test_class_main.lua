local skynet = require "skynet"

local WildZone = require "test_class.WildZone"
skynet.start(function ()
	local wz = WildZone.new()
	wz:WildZone_Func()
	wz:Battle_Func()
	wz:Interface_Func()
	wz:Virtual_Func()
	wz.super:Virtual_Func()
	wz.super.super:Virtual_Func()
	-- dump_class("WildZone")
	require "test_class.Interfacex"
	wz:WildZone_Func()
	wz:Battle_Func()
	wz:Interface_Func()
	wz:Virtual_Func()
	wz.super:Virtual_Func()
	wz.super.super:Virtual_Func()
	dump_class("Interface")
	dump_class("Battle")
	dump_class("WildZone")
end)