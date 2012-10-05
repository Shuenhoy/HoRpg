local Image,Sprite,TextRender=HoGE.Image,HoGE.Sprite,HoGE.TextRender

class. Window_Base() do
	function __c:ctor(x,y,width,height)
		do local _ENV=self
			background=Image:new(width,height)
			sprite=Sprite:new(999)
			sprite.X=x
			sprite.Y=y
			sprite:Image(background)
			render=background:Draw()
			text_image=Image:new(width,height)
			text_i_render=text_image:Draw()
			text_render=TextRender:new(text_image)
			text_sprite=Sprite:new(1000)
			text_sprite:Image(text_image)
			text_sprite.X=x
			text_sprite.Y=y
			visible=true
		end	
		
	end
	function __c:delete()
		text_sprite:delete()
		sprite:delete()
		render:End()
		text_i_render:End()
		text_render:delete()
	end
	function __c:update()
		
		self.sprite.Visible=self.visible
		self.text_sprite.Visible=self.visible
	end

end