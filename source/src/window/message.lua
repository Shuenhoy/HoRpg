local Image,Sprite=HoGE.Image,HoGE.Sprite
class. Window_Message(Window_Base) do
	function __c:ctor(x,y,width,height)
		local _ENV=self
		render:SetSource(0.6,0.4,0,0.8)
		render:Paint()
		render:SetLineWidth(4)
		render:SetSource(0,0,0)
		render:Rectangle(0,0,width,height)
		render:Stroke()
		text_render:Top(10)
		
		show_finish=false
		text_render:Left(10)
		self.text_render:GotoXY(0,0)
		index=1
		visible=false
	end

	function __c:update()
		if self.show_finish and HoGE.KeyDown(32) then
			self.show_finish=false
			self.visible=false
			global_manager.temp.message_text=nil
			self.text_i_render:Save()
			self.text_i_render:SetSource(0,0,0,0)
			self.text_i_render:SetOperator(6)
			self.text_i_render:Paint()
			self.text_i_render:Restore()
			self.text_render:GotoXY(0,0)
			
			do return end
		elseif global_manager.temp.message_text~=nil and not self.show_finish then
			self.visible=true
			if self.index>=#global_manager.temp.message_text then
				self.show_finish=true
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
		
		self.type.superclass.update(self)
	end

end