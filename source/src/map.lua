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
function print_r(root)
	local cache = {  [root] = "." }
	local function _dump(t,space,name)
		local temp = {}
		for k,v in pairs(t) do
			local key = tostring(k)
			if cache[v] then
				tinsert(temp,"+" .. key .. " {" .. cache[v].."}")
			elseif type(v) == "table" then
				local new_key = name .. "." .. key
				cache[v] = new_key
				tinsert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. srep(" ",#key),new_key))
			else
				tinsert(temp,"+" .. key .. " [" .. tostring(v).."]")
			end
		end
		return tconcat(temp,"\n"..space)
	end
	print(_dump(root, "",""))
end
function getIntPart(x)
	if x <= 0 then
	return math.ceil(x);
	end
	
	if math.ceil(x) == x then
	x = math.ceil(x);
	else
	x = math.ceil(x) - 1;
	end
	return x;
end

local int_part=getIntPart
local print_r=print_r
class. Display_Map() do
	function __c:ctor()
		do local _ENV=self
			sprite=Sprite:new()
			data=dofile("data/map1.lua")
			tile=Image:FromFile(data.tilesets[1].image)
			image=Image:new(data.width*data.tilewidth,data.height*data.tileheight)
			width=data.width
			height=data.height
			real_width=data.width*data.tilewidth
			real_height=data.height*data.tileheight
			self:display()
			sprite:Image(image)
		end
	end
	function __c:display()
		do local _ENV=self
			local render=image:Draw()
			for k1,v1 in ipairs(data.layers) do
				for k2,v2 in ipairs(v1.data) do
					render:Save()
					local y=int_part(k2/data.height)
					local x=k2%data.width
					local y2,x2
					do local _ENV=data.tilesets[1]
						
						y2=int_part(v2*tileheight/(imageheight))
						x2=v2*tilewidth%(imagewidth)
						print("x2 is ",x2)
					end
					print(self:getpos(x,y,x2,y2))
					render:Translate(self:getpos(x,y,x2,y2))
					render:SetSource(tile)

					

					render:Rectangle(x,y,data.tileheight,data.tileheight)--self:getrect(x,y,x2,y2))
					--render:Clip()
					render:Paint()
					render:Restore()
				end
			end
			render:End()
		end
	end
	function __c:getpos(x,y,x2,y2)
		local _ENV=self
		return x*data.tilewidth-x2,y*data.tileheight-y2

	end
	function __c:getrect(x1,y1,x2,y2)
		return x1*32+x2,y1*data.tileheight+y2,32,32
	end
end