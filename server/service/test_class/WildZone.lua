require "class"
local Battle = require "test_class.Battle"

local _C = class("WildZone",Battle)

function _C:ctor()

end

function _C:WildZone_Func()
	print(_C.name,"WildZone_Func")
end

function _C:Virtual_Func()
	print(_C.name,"Virtual_Func")
end

return _C