--------------------------------------------------------------------------------------
-- @class file
-- @name main.lua
--------------------------------------------------------------------------------------
-- @author Shuenhoy
-- @copyright Shuenhoy (C)
-- @release 这个文件由HoGE自动生成,请按照您的需要进行修改
--------------------------------------------------------------------------------------

global_init()
global_manager.map:setup(dofile("data/map1.lua"))

global_manager.display_map:setup(global_manager.map)
a=Display_Character:new(global_manager.player)
a:set_image(HoGE.Image:FromFile("img/a.png"))

--------------------------------------------------------------------------------------
-- @class function
-- @name Update
--------------------------------------------------------------------------------------
-- @description 逻辑刷新函数
-- @param 无
-- @return 无
--------------------------------------------------------------------------------------
function Update()
	--o.step=o.step+1
--	if o.step==5 then o.step=1 end
	a:update()
	global_manager.display_map:update()
	global_manager.player:update()
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
	
	--	o:moveto(p.x,o.y)
	
end
--开始主循环
HoGE.Loop()
