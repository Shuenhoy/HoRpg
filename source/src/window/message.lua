local Image,Sprite=HoGE.Image,HoGE.Sprite
class. Window_Message(Window_Base) do
	function __c:ctor(x,y,width,height)
		Window_Message.create_super(self,x,y,width,height)
		local _ENV=self
		self:draw_window(0.6,0.4,0,0.8)
		show_finish=false
		text_render:Top(10)
		text_render:Left(10)
		self.text_render:GotoXY(0,0)
		index=1
		visible=false
	end
	function __c:render_text()
		self.visible=true
		if self.index>=#global_manager.temp.message_text then
			global_manager.temp.message_show_finishi=true
			self.index=1
			return
		end
		local s=string.char(string.byte(global_manager.temp.message_text,self.index))
		
		self.index=self.index+1
		
		if string.byte(s)>128 then
			s=s..string.char(string.byte(global_manager.temp.message_text,self.index))
		
			self.index=self.index+1
			
			s=s..string.char(string.byte(global_manager.temp.message_text,self.index))
		
			self.index=self.index+1
		
		end
		
		if s=="\001" then
			
			local n=string.match(global_manager.temp.message_text,"%[([0-9%.]+,[0-9%.]+,[0-9%.]+)%]",self.index)
			local l=string.match(global_manager.temp.message_text,"(\001%[[0-9%.]+,[0-9%.]+,[0-9%.]+%])")
			
			global_manager.temp.message_text=string.gsub(global_manager.temp.message_text,"\001%[([0-9%.]+,[0-9%.]+,[0-9%.]+)%]","",1)
			
			
			local r,g,b=string.match(n,"([0-9%.]+),([0-9%.]+),([0-9%.]+)")
			self.text_render:Color(tonumber(r),tonumber(g),tonumber(b))
		
			
			self.index=self.index-1--+#l
		elseif s=="\002" then
			
			local n=string.match(global_manager.temp.message_text,"%[([0-9]+)%]",self.index)
			local l=string.match(global_manager.temp.message_text,"(\002%[[0-9]+%])")
			
			global_manager.temp.message_text=string.gsub(global_manager.temp.message_text,"\002%[([0-9]+)%]","",1)
			
			
			local s=string.match(n,"([0-9]+)")
			self.text_render:Size(tonumber(s))
		
			
			self.index=self.index-1--+#l
		else
			
			self.text_render:Puts(s)
		end
	end
	function __c:event(msg)
		if msg.type==HoGE.KEYDOWN and msg.KeyCode==32 then
			if global_manager.temp.message_text~=nil  and not global_manager.temp.message_show_finishi then
			
				while not global_manager.temp.message_show_finishi do
					self:render_text()
			
				end
			end
		end
	end
	function __c:update()
		if global_manager.temp.message_show_finishi   and global_manager.temp.selectbox_result==nil then
			return
		end
		if global_manager.temp.selectbox_finish  then
			
			global_manager.temp.message_show_finishi=false
			self.visible=false
			
			self:clear_text()
			global_manager.temp.selectbox_result=nil
			global_manager.temp.selectbox_finish=false
		end
		
		if HoGE.KeyDown(32) and global_manager.temp.message_show_finishi  then
			global_manager.temp.message_show_finishi=false
			self.visible=false
			global_manager.temp.message_text=nil
			self:clear_text()
			
			return
		
		elseif global_manager.temp.message_text~=nil and not global_manager.temp.message_show_finishi then
			
			self:render_text()
			
		
			
		end
	
		Window_Message.superclass.update(self)
	end

end