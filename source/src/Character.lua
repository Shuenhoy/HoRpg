local Sprite,Image,Rect=HoGE.Sprite,HoGE.Image,HoGE.Rect
local global_manager=global_manager
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
    self.real_x=0
    self.real_y=0
    self.x=1
    self.y=1
    self.z=ZPosSet.Character
    
  
  
    self.move_speed=4
    self.anime_count=0
    
  end
  function __c:moveto(x,y)
    
    self.x = x % global_manager.map.width
    self.y = y % global_manager.map.height
    self.real_x = (self.x-1) * 128
    self.real_y = (self.y-1) * 128
    self.prelock_direction = 0
  end
  function __c:get_rect(w,h)
    return w/self.w*(self.step-1),h/self.h*(self.direction-1)+1,w/self.w,h/self.h 
  end
  function __c:up() 
  self.direction=4
    if self:passable(self.x,self.y,4) then
      
      self.y=self.y-1
    end
  end
  function __c:down() 
  self.direction=1
    if self:passable(self.x,self.y,1) then
      
      self.y=self.y+1
    end
  end
  function __c:left()
  self.direction=2
  if self:passable(self.x,self.y,2) then
    
    self.x=self.x-1
  end
  end
  function __c:right() 
    self.direction=3
    if self:passable(self.x,self.y,3) then
    self.x=self.x+1
    end
  end
  
  function __c:moving()
    if self.real_x~=(self.x-1)*128 or self.real_y~=(self.y-1)*128 then
      return true
    end
  end
  function __c:update_move()
    local  distance = 2 ^ (self.move_speed+1)
    --下
    if self.direction==1 then
      self.real_y=math.min(self.real_y+distance,(self.y-1)*128)
    --左
    elseif self.direction==2 then
      self.real_x=math.max(self.real_x-distance,(self.x-1)*128)      
    --右
    elseif self.direction==3 then 
        self.real_x=math.min(self.real_x+distance,(self.x-1)*128)
    --上
    elseif self.direction==4 then 
        self.real_y=math.max(self.real_y-distance,(self.y-1)*128)
    end
    self.anime_count=self.anime_count+5
    --self.real_x=self.real_x+distance
  end
  function __c:passable(x,y,d)
    
    local next_x = x+(d==3 and 1 or d==2 and -1 or 0)
    local next_y = y+(d==1 and 1 or d==4 and -1 or 0)
    
    return global_manager.map:passable(next_x,next_y,d)
  end
  function __c:update()
  
    if self:moving() then
      self:update_move()
    
    if self.anime_count>18-(self.move_speed+1)*2 then
      self.step=(self.step-2)%4+1
      self.anime_count=0
    end
    end
  end

  
end


class. Game_Player(Game_Character) do
  local CENTER_X = (getIntPart(Game.Width/2) - 16) * 4  
  local CENTER_Y = (getIntPart(Game.Height/2) - 16) * 4   
  function __c:ctor()
    Game_Player.create_super(self)
    self.file="img/mrk.png"
   
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
      
      if HoGE.KeyDown(32) then
        
      end
    end
    local last_real_x=self.real_x
    local last_real_y=self.real_y
    Game_Player.superclass.update(self)
    
    if self.real_y>last_real_y and self.real_y-global_manager.map.display_y > CENTER_Y then 
      global_manager.map:scroll_down(self.real_y-last_real_y)
    end
    if self.real_y<last_real_y and self.real_y-global_manager.map.display_y < CENTER_Y then 
      global_manager.map:scroll_up((last_real_y-self.real_y))
    end
    
    if self.real_x>last_real_x and self.real_x-global_manager.map.display_x > CENTER_X then 
      global_manager.map:scroll_right(self.real_x-last_real_x)
    end
    if self.real_x<last_real_x and self.real_x-global_manager.map.display_x < CENTER_X then 
      global_manager.map:scroll_left((last_real_x-self.real_x))
    end
  end
end

class. Game_Event(Game_Character) do
  function __c:ctor(map_id,eventdata)
    Game_Event.create_super(self)
    
    --Game_Event.superclass.ctor(self)-- create_super(self)
    self.map_id=map_id
    self.id=eventdata.id
    self.event=eventdata
    self.file=eventdata.pages[1].graphic
    self:moveto(unpack(eventdata.pos))
    
  end
  function __c:start()
    global_manager.map.interpreter:load(loadstring(self.event.pages[1].work))
  end
  function __c:update()
    Game_Event.superclass.update(self)
    
  end

end





class. Display_Character() do  
  function __c:ctor(character)
    self.z=0
    self.sprite=Sprite:new(ZPosSet.Character)
    self.image=nil
    self.character=character
    
    self.rect=Rect:new(0,0,0,0)
    self.sprite.Rect=self.rect
    self.file=""
    self.x=self.character.x
    self.y=0
    
   
   
   
   
  end
  function __c:set_image(img)
    self.image=img
    self.sprite:Image(img)
    self.rect:Set(self.character:get_rect(img.Width,img.Height))
    
  end
  function __c:display_pos()
    return (self.character.real_x)/4,(self.character.real_y)/4+16
  end
  function __c:update()
   

    if self.file~=self.character.file then
      self.file=self.character.file
      
      self:set_image(Cache.load_file(self.character.file))
      
    end
    if self.file~="" then
      self.sprite.Rect:Set(self.character:get_rect(self.image.Width,self.image.Height))
      self.sprite.X,self.sprite.Y=self:display_pos()
    
      self.sprite.OX=global_manager.map.display_x/4
      self.sprite.OY=global_manager.map.display_y/4
    end
    if  self.y~=global_manager.player.y then 
      self.y=global_manager.player.y
      self.sprite:Z(ZPosSet.Character)

    end

  end
  
end

