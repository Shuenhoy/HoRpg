local Sprite,Image,Rect=HoGE.Sprite,HoGE.Image,HoGE.Rect
local dofile=dofile
local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local ipairs = ipairs
local tostring = tostring
local next = next
local modf=math.modf
local string=string

local int_part=getIntPart
local print_r=print_r



class. Game_Map() do

	function __c:ctor()
		
	end
	function __c:setup(data)
		local G=_G
		do local _ENV=self
			self.data=data
			tile=data.tilesets[1].image
			width=data.width
			height=data.height
			real_width=data.width*data.tilewidth
			real_height=data.height*data.tileheight
			screen_width=G.Game.Width/data.tilewidth
			screen_height=G.Game.Height/data.tileheight
			layers=data.layers
			display_x=0
			display_y=0
		end
	end
	function __c:valid(x,y)
		return (x >= 1 and x <= self.width and y >= 0 and y <= self.height)
	end
	local function is_width_liner(a,b)
		return a-b==0
	end
	local function is_height_liner(a,b)
		return a-b==0
	end
	function __c:passable(x,y,d)
		if not self:valid(x,y) then
			return false
		end
		--[[
		x=x-1
		y=y+1
		--]]
		for k,v in ipairs(self.data.layers) do
			if v.type == "objectgroup" and v.properties["type"] == "pass"  then
				for k2,v2 in ipairs(v.objects) do
					--计算路径左上角
					local xx,yy = v2.x/self.data.tilewidth+1,v2.y/self.data.tileheight
					if v2.width>0 or v2.height>0 then
						local w,h=v2.width/self.data.tilewidth-1,v2.height/self.data.tileheight-1
						if x>=xx and x<= xx+w and y>=yy and y<= yy+h then
							return false
						end
					else
						
						local last_x,last_y=xx,yy
						for k3,v3 in ipairs(v2.polyline) do
							local x3,y3=xx+v3.x/self.data.tilewidth-1,yy+v3.y/self.data.tileheight
							
							if x3 > last_x  then
								if is_width_liner(y3,last_y) and x>last_x and x<= x3 then
									if d==1 and y == y3 then
										return false
									end
									if d==4 and y == y3-1 then
										return false
									end
								end
							elseif x3 < last_x then
								if is_width_liner(y3,last_y) and x > x3 and x<=last_x  then
									if d==1 and y == y3 then
										return false
									end
									if d==4 and y == y3-1 then
										return false
									end
								end
							end
						
							if y3 > last_y  then
								
								if is_height_liner(x3,last_x) and y>=last_y and y < y3 then
									if d==2 and x == x3 then
										
										return false
									end
									if d==3 and x == x3+1 then
										return false
									end
								end
							elseif y3 < last_y then
								if is_height_liner(x3,last_x) and y >= y3 and y<last_y then
									if d==2 and x == x3 then
										return false
									end
									if d==3 and x == x3+1 then
										return false
									end
								end
							end
							
							last_x,last_y=x3,y3
						end
						
					end
				end
			end
		
		end
		return true
	end
	function __c:scroll_up(distance) 
		self.display_y=math.max(self.display_y - distance, 0)
	end
	function __c:scroll_down(distance) 
		self.display_y=math.min(self.display_y + distance, (self.height - self.screen_height) * 128)
	end
	function __c:scroll_left(distance) 
		self.display_x=math.max(self.display_x - distance, 0)
	end
	function __c:scroll_right(distance) 
		self.display_x=math.min(self.display_x + distance, (self.width - self.screen_width) * 128)
	end
end





class. Display_Map() do
	function __c:ctor()
		do local _ENV=self
			bottom_sprite=Sprite:new(1)
			top_sprite=Sprite:new(4)
		end
	end
	function __c:setup(map)
		self.map=map
		local data=map.data
		do local _ENV=self
			self.data=data
			tile=Image:FromFile(data.tilesets[1].image)
			bottom_image=Image:new(data.width*data.tilewidth,data.height*data.tileheight)
			top_image=Image:new(data.width*data.tilewidth,data.height*data.tileheight)
			width=data.width
			height=data.height

			self:display()
			bottom_sprite:Image(bottom_image)
			top_sprite:Image(top_image)
		end
	end
	function __c:display()
		do local _ENV=self
			local render_1=bottom_image:Draw()
			local render_2=top_image:Draw()
			for k1,v1 in ipairs(data.layers) do
				local render
				if v1.properties["type"]=="top" then
					render=render_2
				else
					render=render_1
				end
				if v1.type == "tilelayer" then
					for k2,v2 in ipairs(v1.data) do
						if v2~=0 then 
							render:Save()
							local y=int_part((k2-1)/data.width)
							local x=(k2-1)%data.width
							local y2
							local x2
							do local _ENV=data.tilesets[1]
								
								y2=int_part((v2-1)*(tilewidth/imagewidth))*tileheight
								x2=((v2-1)%(imagewidth/tilewidth))*tilewidth
							end
						
							
							render:Translate(self:getpos(x,y,x2,y2))
							render:SetSource(tile)
		
							
							local w,h=data.tilewidth,data.tileheight
							render:Rectangle(x2,y2,w,h)
							render:Clip()
							render:Paint()
							render:Restore()
						end
					end
				end	
				
			end
			render_1:End()
			render_2:End()
		end
	end
	function __c:getpos(x,y,x2,y2)
		local _ENV=self
		return x*data.tilesets[1].tilewidth-x2,y*data.tilesets[1].tileheight-y2

	end
	function __c:update()
		do local _ENV=self
			bottom_sprite.OX=map.display_x/4
			top_sprite.OX=map.display_x/4
			bottom_sprite.OY=map.display_y/4
			top_sprite.OY=map.display_y/4
		end
	end
end