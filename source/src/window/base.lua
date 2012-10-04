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
			text_render=TextRender:new(background)
			visible=true
		end	
		
	end
	function __c:delete()
		sprite:delete()
		render:End()
	end
	function __c:update()
		
		self.sprite.Visible=self.visible
	end

end