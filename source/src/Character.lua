local Sprite,Image,Rect=HoGE.Sprite,HoGE.Image,HoGE.Rect

--1下
--2左
--3右
--4上
class. Game_Character() do
	function __c:ctor() 
		self.step=1
		self.direction=1
		self.w=4
		self.h=4
		self.x=1
		self.y=1
		self.real_x=0
		self.real_y=0
		self.move_speed=5
		self.anime_count=0
	end
	function __c:get_rect(w,h)
		return w/self.w*(self.step-1),h/self.h*(self.direction-1)+1,w/self.w,h/self.h 
	end
	function __c:up() 
		o.direction=4
		self.y=self.y-1
	end
	function __c:down() 
		o.direction=1
		self.y=self.y+1
	end
	function __c:left()
		o.direction=2
		self.x=self.x-1
	end
	function __c:right() 
		o.direction=3
		self.x=self.x+1
	end
	function __c:moveto(x,y)

	end
	function __c:moving()
		if self.real_x~=(self.x-1)*128 or self.real_y~=(self.y-1)*128 then
			return true
		end
	end
	function __c:update_move()
		local  distance = 2 ^ self.move_speed
		--上
		if self.direction==1 then
			self.real_y=self.real_y+distance
			self.real_y=math.min(self.real_y,(self.y-1)*128)
		--左
		elseif self.direction==2 then
			self.real_x=self.real_x-distance
			self.real_x=math.max(self.real_x,(self.x-1)*128)
			
		--右
		elseif self.direction==3 then 
			self.real_x=self.real_x+distance
			self.real_x=math.min(self.real_x,(self.x-1)*128)
		--下
		elseif self.direction==4 then 
			self.real_y=self.real_y-distance
			self.real_y=math.max(self.real_y,(self.y-1)*128)
		end
		self.anime_count=self.anime_count+5
		--self.real_x=self.real_x+distance
	end
	function __c:update()
		if self:moving() then
			self:update_move()
		end
		if self.anime_count>18-self.move_speed*2 then
			self.step=(self.step-2)%4+1
			self.anime_count=0
		end
		
	end
	function __c:display_pos()
		return (self.real_x+3)/4,(self.real_y+3)/4
	end
end


class. Game_Player(Game_Character) do
	function __c:ctor()
		
	end
	function __c:update()
		if not self:moving() then
			if HoGE.KeyDown(38) then
				self:up()
			elseif HoGE.KeyDown(37) then
				self:left()
			elseif HoGE.KeyDown(40) then
				self:down()
			elseif HoGE.KeyDown(39) then
				self:right()
			end
		end
		self.type.superclass.update(self)
	end
end
class. Display_Character() do	
	function __c:ctor(character)
		self.sprite=Sprite:new()
		self.image=nil
		self.character=character

		self.rect=Rect:new(0,0,0,0)
		self.sprite.Rect=self.rect
		self.sprite:Image(self.image)
	end
	function __c:set_image(img)
		self.image=img
		self.sprite:Image(img)
		self.rect:Set(self.character:get_rect(img.Width,img.Height))
		
	end
	function __c:update()
		
		self.sprite.Rect:Set(self.character:get_rect(self.image.Width,self.image.Height))
		self.sprite.X,self.sprite.Y=self.character:display_pos()
		
		
	end
	
end

