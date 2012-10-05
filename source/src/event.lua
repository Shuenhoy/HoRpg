
local global_manager=global_manager
finish_funcs={}
do local _ENV=finish_funcs
	function MessageBox()
		return global_manager.temp.message_text==nil
	end
end

class. Event_Interpreter() do
	
	function __c:ctor()
		self.co=nil
		self.finish_all=false--是否执行完毕整个事件
		self.now_type=nill --当前命令类型
	end
	function __c:load(fn)
		self.co = coroutine.create(fn)
		self.first=true
	end
	function __c:run_next()
		if not self.co then
			error "未初始化!"
		end
		self.now_type = select(2,coroutine.resume(self.co))
		self.finish_all=coroutine.status(self.co)=="dead"
		
	end
	
	function __c:finish_now()
		if self.first then
			self.first=false
			return true
		end
		return finish_funcs[self.now_type]()
	end
	function __c:update()
		--是否初始化
		if self.co == nil then
			return
		end
		
		--是否全部完成
		if self.finish_all then
			return
		end
		
		if self:finish_now() then
			self:run_next()
		end
	end
end


function MessageBox(msg,name)
	if name then
		global_manager.temp.message_text=string.gsub(string.gsub("%c[0.9,0.7,0.7]【"..name.."】%c[0,0,0]\n"..msg,"%%c","\001"),"%%%%","%")
		global_manager.temp.message_text=string.gsub(global_manager.temp.message_text,"%%s","\002")
	else
		global_manager.temp.message_text=string.gsub(string.gsub(msg,"%%c","\001"),"%%%%","%")
		global_manager.temp.message_text=string.gsub(global_manager.temp.message_text,"%%s","\002")
	end
	coroutine.yield("MessageBox")
end