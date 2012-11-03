local Image,Sprite=HoGE.Image,HoGE.Sprite
class. Window_SelectBase(Window_Base) do
	function __c:ctor(x,y,select_list)
		
		
		local max=0
		for k,v in ipairs(select_list) do
			if string.utf8len(v)>max then max=string.utf8len(v) end
		end
		
		local width,height=max*22+48,#select_list*32
		
		
		
		Window_SelectBase.create_super(self,x,y,width,height)
		
		self.visible=true
		
		
		
		self:draw_window(0.6,0.4,0,0.8)
		
		self.text_render:Top(10)
		self.text_render:Left(42)
		
		for k,v in ipairs(select_list) do
			self.text_render:Puts(v)
			self.text_render:Puts("\n")
		end
		
		self.arrow=Sprite:new(1001)
		local arrow_img=Cache.load_file("img/arrow.png")
		self.arrow_img=arrow_img
		self.arrow:Image(arrow_img)
		self.arrow.X=x+10
		self.arrow.Y=y+10
		self.index=0
		self.Visible=true
		self.max=#select_list
		self.x=x
		self.y=y
	end
	function __c:update()
		Window_SelectBase.superclass.update(self)
		self.arrow.Visible=self.visible
		if HoGE.KeyDown(38) then
			self.index=self.index-1
			if self.index<0 then
				self.index=self.max-1
			end
			self.arrow.Y=self.y+self.index*22+10
		elseif HoGE.KeyDown(40) then
			self.index=self.index+1
			if self.index>self.max-1 then
				self.index=0
			end
			self.arrow.Y=self.y+self.index*22+10
		elseif HoGE.KeyDown(32) then
			self.visible=false
			Window_SelectBase.superclass.update(self)
			self.arrow.Visible=self.visible
			if self.commit_func then
				self.commit_func(self.index)
			end
			
		end
		
	end
	function __c:delete()
		self.arrow:delete()
    Window_SelectBase.superclass.delete(self)
	end
end 


class. Window_SelectBox() do
	function __c:ctor(x,y)
		self.select_base=nil
		self.x=x
		self.y=y
	end
	function __c.commit_func(i)
		global_manager.temp.selectbox_result=i
		global_manager.temp.message_text=nil
		global_manager.temp.selectbox_finish=true
	end
	function __c:update()
		if global_manager.temp.message_show_finishi==true then
			if global_manager.temp.selectbox_list~=nil then
				if self.select_base~=nil then self.select_base:delete() end
        
				self.select_base=Window_SelectBase:new(self.x,self.y,global_manager.temp.selectbox_list)
        self.select_base.visible=true
				self.select_base.commit_func=self.commit_func
				global_manager.temp.selectbox_list=nil
				
				
			end
			if global_manager.temp.selectbox_result==nil then
				sleep(0.1)
			end
			if self.select_base~=nil then
				self.select_base:update()
			end
		end
		
	end
end