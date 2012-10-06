
local _class={}
 
local function defclass(super)
	local class_type={}
	
	class_type.ctor=false
	class_type.super=super
	class_type.create_super=function(self,...)
		if class_type.super then
			class_type.super.ctor(self,...)
			__super=class_type.super
		end
	end
	class_type.superclass = _class[super]
	class_type.new=function(self,...) 
			local obj={}
			obj.type=class_type
			setmetatable(obj,{ __index=_class[class_type] })
			do
				local create
				create = function(c,...)
					if not c.ctor and c.super then
						create(c.super,...)
					end
					if c.ctor then
						c.ctor(obj,...)
					end
					__super=c.super
				end
 
				create(class_type,...)
			end
			
			return obj
		end
	local vtbl={}
	 --vtbl.super = _class[super]
	_class[class_type]=vtbl
 
	setmetatable(class_type,{__newindex=
		function(t,k,v)
			vtbl[k]=v
		end
	})
 
	if super then
		setmetatable(vtbl,{__index=
			function(t,k)
				local ret=_class[super][k]
				vtbl[k]=ret
				return ret
			end
		})
	end
	__c=class_type
	return class_type
end










local env=_ENV
local setmetatable=setmetatable
local object_mt={}
--[=[
local class_mt={}
function class_mt:new(...)
	local o=NewObject({},self)
	if self._init_ then
		self._init_(o,...)
	end
	return o
end
class_mt.__index=function(t,k)
end-- class_mt
local function new_class(tt,p)
	tt = tt or {}
	tt.new=class_mt.new
	if p then
		tt.super=p
		setmetatable(tt,p)
	end
	
	__c=tt
	
	return tt
end
]=]
function object_mt.__call(p)
	return defclass(p)
end
function object_mt.__index(t,k)
	return function(p)
		env[k]=defclass(p)
	end
end


class={}
setmetatable(class,object_mt)
--[=[
function NewObject(o, class)
    class.__index = class
	
    return setmetatable(o, class)
end


]=]
local Old_ENV_={}
local module_mt={}
old_module=module
function module_mt.__index(t,k)
	return function()
		table.insert(Old_ENV_,_ENV)
		old_module(k,package.seeall)
		env=_ENV
		return env
	end
	
end
function end_module()
	env=table.remove(Old_ENV_)
	_ENV=env
	return env
end
module={}
setmetatable(module,module_mt)