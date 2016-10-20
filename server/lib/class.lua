local util = require "util"

local _class={}
local _class_map = {}
local _class_instance = {}

function class(name,super)
	local class_type = {}
	class_type.super = super
	class_type.clilds = {}
	class_type.name = name
	class_type.super_method = {}
	if super ~= nil then
		table.insert(super.clilds,name)
	end

	--构造函数
	class_type.new=function(...)
			local obj={}
			local ctor = _class[class_type].ctor
			--把对像的虚表设成加载到的函数表里
			setmetatable(obj,{ __index=_class[class_type] })
			if ctor then
				ctor(obj,...)
			end
			--用来记录同一个类生成了多少对像，热更用
			table.insert(_class_instance[name],obj)
			return obj
		end

	--类的虚表
	local vtbl={}
	_class[class_type]=vtbl

	--加载文件时给虚表赋值
	setmetatable(class_type,{__newindex=
		function(t,k,v)
			vtbl[k]=v
		end
	})

	if super then
		vtbl.super = _class[super]
		setmetatable(vtbl,{__index=
			function(t,k)
				local ret=_class[super][k]
				vtbl[k]=ret
				table.insert(class_type.super_method,k)
				return ret
			end
		})
	end

	local oclass_type = _class_map[name]
	--热更新?
	if oclass_type ~= nil then
		--把所有子类的super和vtbl的super修改成新类
		for _,child_name in pairs(oclass_type.clilds) do
			table.insert(class_type.clilds,child_name)
			local child_class = _class_map[child_name]
			child_class.super = class_type

			local child_vtbl = _class[child_class]
			for _,method in pairs(child_class.super_method) do
				child_vtbl[method] = nil
			end
			child_class.super_method = {}

			child_vtbl.super = _class[class_type]
			setmetatable(child_vtbl,{__index=
				function(t,k)
					local ret=_class[class_type][k]
					child_vtbl[k]=ret
					table.insert(child_class.super_method,k)
					return ret
				end
			})
		end

		--把以此类实例化的对像的meta全设成新的class的vtbl
		local insts = _class_instance[name]
		for _,inst in pairs(insts) do
			setmetatable(inst,{ __index=_class[class_type] })
		end
	else
		_class_instance[name] = setmetatable({},{__mode = "v"})
	end
	_class_map[name] = class_type
	
	return class_type
end

function dump_class(name)
	util.dump_table(_class_map[name],name)
end
