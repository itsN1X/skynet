local util = require "util"

local _class={}
local _class_map = {}
local _class_instance = {}

function class(name,super)
	local class_type = {}
	class_type.super = super
	class_type.children = {}
	class_type.name = name
	class_type.supermethod = {}
	if super ~= nil then
		local is_child = false
		for _,namex in pairs(super.children) do
			if namex == name then
				is_child = true
			end
		end
		if not is_child then
			table.insert(super.children,name)
		end
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
	class_type.vtbl = vtbl

	--加载文件时给虚表赋值
	setmetatable(class_type,{__newindex=
		function(t,k,v)
			vtbl[k]=v
		end
	})

	if super then
		--子类提供一个super接口，可以直接防问父类的函数
		vtbl.super = _class[super]
		--子类没有的函数假如父类有的话，把函数放到子类当中，以便下次防问少一次metatable的防问
		setmetatable(vtbl,{__index=
			function(t,k)
				local ret=_class[super][k]
				vtbl[k]=ret
				--同时记录子类有哪些函数是父类的
				table.insert(class_type.supermethod,k)
				return ret
			end
		})
	end



	local oclass_type = _class_map[name]
	--热更新?
	if oclass_type ~= nil then

		local function remove_clildren_supermethod(parent)
			for _,name in pairs(parent.children) do
				local child_class = _class_map[name]
				local child_vtbl = _class[child_class]
				for _,method in pairs(child_class.supermethod) do
					child_vtbl[method] = nil
				end
				child_class.supermethod = {}
				if #child_class.children ~= 0 then
					remove_clild_supermethod(child_class)
				end
			end
		end

		--把所有子类的super和vtbl的super修改成新类
		for _,name in pairs(oclass_type.children) do
			table.insert(class_type.children,name)
			local child_class = _class_map[name]
			child_class.super = class_type

			local child_vtbl = _class[child_class]
			for _,method in pairs(child_class.supermethod) do
				child_vtbl[method] = nil
			end
			child_class.supermethod = {}

			child_vtbl.super = _class[class_type]
			setmetatable(child_vtbl,{__index=
				function(t,k)
					local ret=_class[class_type][k]
					child_vtbl[k]=ret
					table.insert(child_class.supermethod,k)
					return ret
				end
			})
			remove_clildren_supermethod(child_class)
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

function dump_class_inst(name)
	util.dump_table(_class_instance[name],name)
end