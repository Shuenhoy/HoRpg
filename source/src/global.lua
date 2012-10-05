
--------------------------------------------------------------------------------------
-- @class table
-- @name global_manager
--------------------------------------------------------------------------------------
-- @description 一些全局变量管理器
--------------------------------------------------------------------------------------
global_manager={
	
}
--------------------------------------------------------------------------------------
-- @class function
-- @name global_init
--------------------------------------------------------------------------------------
-- @description 初始化全局变量
--------------------------------------------------------------------------------------
function global_init()
	
	global_manager.player=Game_Player:new()
	global_manager.map=Game_Map:new()
	global_manager.display_map=Display_Map:new()
	global_manager.display_player=Display_Character:new(global_manager.player)
	global_manager.temp={
		message_text=nil,
	}
end