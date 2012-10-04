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
		text_render.Top=10
		text_render:Left(10)
		
		--visible=false
	end
	function __c:set_msg(m)
		self.msg=m
		self.index=1
	end
	function __c:update()
	
		if self.msg~=nil then
			if self.index>=#self.msg then
				self.msg=nil
				return
			end
			
			local s=string.char(string.byte(self.msg,self.index))
		
			self.index=self.index+1
			
			if string.byte(s)>128 then
				s=s..string.char(string.byte(self.msg,self.index))
		
				self.index=self.index+1
				
				s=s..string.char(string.byte(self.msg,self.index))
		
				self.index=self.index+1
			
			end
			
			if s=="\001" then
				
				local n=string.match(self.msg,"%[([0-9%.]+,[0-9%.]+,[0-9%.]+)%]",self.index)
				local l=string.match(self.msg,"(\001%[[0-9%.]+,[0-9%.]+,[0-9%.]+%])")
				
				self.msg=string.gsub(self.msg,"\001%[([0-9%.]+,[0-9%.]+,[0-9%.]+)%]","",1)
				print(self.msg)
				
				local r,g,b=string.match(n,"([0-9%.]+),([0-9%.]+),([0-9%.]+)")
				self.text_render:Color(tonumber(r),tonumber(g),tonumber(b))
			
				
				self.index=self.index-1--+#l
				
			else
				print(s)
				self.text_render:Puts(s)
			end
			
			
			
		end
		
		self.type.superclass.update(self)
	end

end