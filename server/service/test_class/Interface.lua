require "class"

local _C = class("Interface")

function _C:ctor()

end

function _C:Interface_Func()
	print(_C.name,"Interface_func")
end

function _C:Virtual_Func()
	print(_C.name,"Virtual_Func")
end

function _C:send_battle()

end

return _C