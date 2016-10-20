require "class"

local _C = class("second")

function _C:ctor()
	self.a = 1
	self.b = 2
end

function _C:test()
	print("test")
end

return _C