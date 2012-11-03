--------------------------------------------------------------------------------------
-- @class file
-- @name main.lua
--------------------------------------------------------------------------------------
-- @author Shuenhoy
-- @copyright Shuenhoy (C)
-- @release 这个文件由HoGE自动生成,请按照您的需要进行修改
--------------------------------------------------------------------------------------

global_init()
global_manager.scene=Scene_Map:new()
local key={0x11,0x18,0x37,0x82,0x84,0x93,0xd6,0xb8,0xc2,0xf9,0x7f,0x11,0x33,0xed,0x7b,0xf0}
for i=1,#key do
  key[i]=string.char(key[i])

end
loader_init("data/_datas",table.concat(key))
--------------------------------------------------------------------------------------
-- @class function
-- @name Update
--------------------------------------------------------------------------------------
-- @description 逻辑刷新函数
-- @param 无
-- @return 无
--------------------------------------------------------------------------------------
function Update()

  global_manager.scene:update()
  
  sleep(0.05)
end


--------------------------------------------------------------------------------------
-- @class function
-- @name Event
--------------------------------------------------------------------------------------
-- @description 事件函数
-- @param msg事件变量
-- @return 无
--------------------------------------------------------------------------------------
function Event(msg)
  if msg.type == HoGE.KEYDOWN then
    if msg.KeyCode==19 then
      os.execute("pause")
    end
  end
  if global_manager.scene.event then
    global_manager.scene:event(msg)
  end
  --  o:moveto(p.x,o.y)
  
end
--开始主循环
HoGE.Loop()
