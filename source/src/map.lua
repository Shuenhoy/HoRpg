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
		--判断是否在地图内
		if not self:valid(x,y) then
			return false
		end--if
		for k,v in ipairs(self.data.layers) do
			--仅当为「对象层」 类型为「pass」(通行层)时
			if v.type == "objectgroup" and v.properties["type"] == "pass"  then
				for k2,v2 in ipairs(v.objects) do
					local start_x,start_y = v2.x/self.data.tilewidth+1,v2.y/self.data.tileheight
					
					--块状通行快
					if v2.width>0 or v2.height>0 then
						local w,h=v2.width/self.data.tilewidth-1,v2.height/self.data.tileheight-1						
						--不能走进去
						if x>=start_x and x<= start_x+w and y>=start_y and y<= start_y+h then
							return false
						end--if
					else--if
					--线型通行
					
						local last_x,last_y=start_x,start_y
						for k3,v3 in ipairs(v2.polyline) do
							local next_x,next_y=start_x+v3.x/self.data.tilewidth-1,start_y+v3.y/self.data.tileheight
							
							--「↑↓」方向的通行判断
							
							--自左向右连线
							if next_x > last_x  then
								--是横线且角色位置处于横线处,分别判断「↑↓」方向
								if is_width_liner(next_y,last_y) and x>last_x and x<= next_x then
									if d==1 and y == next_y then
										return false
									end--if
									if d==4 and y == next_y-1 then
										return false
									end--if
								end--if
								
							--自右向左连线
							elseif next_x < last_x then
								--同上
								if is_width_liner(next_y,last_y) and x > next_x and x<=last_x  then
									if d==1 and y == next_y then
										return false
									end--if
									if d==4 and y == next_y-1 then
										return false
									end--if
								end--if
							end--if
							
							--「←→」方向的通行判断,同上
							if next_y > last_y  then
								if is_height_liner(next_x,last_x) and y>=last_y and y < next_y then
									if d==2 and x == next_x then
										return false
									end--if
									if d==3 and x == next_x+1 then
										return false
									end--if
								end--if
							elseif next_y < last_y then
								if is_height_liner(next_x,last_x) and y >= next_y and y<last_y then
									if d==2 and x == next_x then
										return false
									end--if
									if d==3 and x == next_x+1 then
										return false
									end--if
								end--if
							end--if
							
							--接着判断下一条线
							last_x,last_y=next_x,next_y
						end--for
						
					end--if
				end--for
			end--if
		end--for
		--可以通行了
		return true
	end--function
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



class. Scene_Map() do
	function __c:ctor()
		global_manager.map:setup(dofile("data/map1.lua"))
		global_manager.display_map:setup(global_manager.map)
		global_manager.display_player:set_image(HoGE.Image:FromFile("img/a.png"))
		self.ev=Event_Interpreter:new()
		self.window_message=Window_Message:new(50,430,700,130)
		self.ev:load(function()
			MessageBox("阿拉阿拉我就是%c[0.8,0.9,0.9]萌%c[0,0,0]RK哦","萌のRK酱")
			MessageBox("呵呵,怎么样这个对话框很%s[30]萌%s[22]吧~","萌のRK酱")
			MessageBox(
[[事件系统初步完成了呢,多亏伟大的%c[0.3,0.3,0.8]@Shuenhoy%c[0,0,0]呢
(虽然这个是直接写在地图的构造函数里=-=阿拉阿拉
期待伟大的%c[0.3,0.3,0.7]@Shuenhoy%c[0,0,0]加入更多功能吧!]],"萌のRK酱")
		end)
		
	end
	function __c:update()
		global_manager.display_player:update()
		global_manager.display_map:update()
		global_manager.player:update()
		self.window_message:update()
		self.ev:update()
	end
end

