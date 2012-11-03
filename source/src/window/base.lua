local Image,Sprite,TextRender=HoGE.Image,HoGE.Sprite,HoGE.TextRender
local ZPosSet=ZPosSet
class. Window_Base() do
	function __c:ctor(x,y,width,height)
		do local _ENV=self
			self.width=width
			self.height=height
			background=Image:new(width,height)
			sprite=Sprite:new(ZPosSet.Window)
			sprite.X=x
			sprite.Y=y
			sprite:Image(background)
			render=background:Draw()
			text_image=Image:new(width,height)
			text_i_render=text_image:Draw()
			text_render=TextRender:new(text_image)
			text_sprite=Sprite:new(ZPosSet.WindowText)
			text_sprite:Image(text_image)
			text_sprite.X=x
			text_sprite.Y=y
			visible=true
		end	
	end
	function __c:draw_window(r,g,b,a)
		self.render:SetSource(r,g,b,a or 1)
		self.render:Paint()
		self.render:SetLineWidth(4)
		self.render:SetSource(0,0,0)
		self.render:Rectangle(0,0,self.width,self.height)
		self.render:Stroke()
	end
	function __c:clear_text()
		self.text_i_render:Save()
		self.text_i_render:SetSource(0,0,0,0)
		self.text_i_render:SetOperator(6)
		self.text_i_render:Paint()
		self.text_i_render:Restore()
		self.text_render:GotoXY(0,0)
	end
	function __c:delete()
		self.text_sprite:delete()
		self.sprite:delete()
		self.render:End()
		self.text_i_render:End()
		self.text_render:delete()
	end
	function __c:update()
		
		self.sprite.Visible=self.visible
		self.text_sprite.Visible=self.visible
	end

end