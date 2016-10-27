require "class"
local Interface = require "test_class.Interface"

local _C = class("Battle",Interface)

function _C:ctor()

end

function _C:Battle_Func()
	print(_C.name,"Battle_Func")
end

function _C:Virtual_Func()
	print(_C.name,"Virtual_Func")
end

return _C