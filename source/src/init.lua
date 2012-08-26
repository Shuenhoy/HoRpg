--------------------------------------------------------------------------------------
-- @class file
-- @name init.lua
--------------------------------------------------------------------------------------
-- @author Shuenhoy编写,HoGE.lua生成
-- @copyright 2012 Shuenhoy - HoGE project
-- @release 这是HoGE自动生成的初始化程序,除初始化游戏部分外尽量不要修改
--------------------------------------------------------------------------------------


--初始化游戏
--VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
local Game={
	Title='HoRPG Framework',	--标题
	Width=800,					--宽度
	Height=600,					--高度
	FPS=60,						--最大帧率
	EventFunction='Event',		--事件函数名称
	UpdateFunction='Update',	--刷新函数名称
	ShowCursor=true,			--是否显示鼠标指针
	ThreeRender=false			--是否开启3倍渲染
}
HoGELua.Init(
	Game.Title,
	Game.Width,
	Game.Height,
	Game.FPS,
	Game.EventFunction,
	Game.UpdateFunction,
	Game.ShowCursor,
	Game.ThreeRender)
--AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
--------------------------------------------------------------------------------------
-- @class function
-- @name get_create_object_func
--------------------------------------------------------------------------------------
-- @description 取得带有GC的构造方法
-- @param func 原构造方法
-- @return 带有gc的构造方法
--------------------------------------------------------------------------------------
local get_create_object_func=function(func)
	return function(self,...)
		local ret=func(self,...)
		tolua.takeownership(ret)
		return ret
	end
end

--依次为各个类别绑定GC
-- *没有绑定Sprite,请使用Spriteobj:delete()手动清除
HoGE.Color.new			=	get_create_object_func(HoGE.Color.new)
HoGE.Rect.new			=	get_create_object_func(HoGE.Rect.new)
HoGE.Image.new			=	get_create_object_func(HoGE.Image.new)
HoGE.Image.FromFile		=	get_create_object_func(HoGE.Image.FromFile)
HoGE.Image.FromBuffer	=	get_create_object_func(HoGE.Image.FromBuffer)
HoGE.Image.FromFp		=	get_create_object_func(HoGE.Image.FromFp)
HoGE.Pattern.new		=	get_create_object_func(HoGE.Pattern.new)
HoGE.Pattern.Linear		=	get_create_object_func(HoGE.Pattern.Linear)
HoGE.Pattern.Radial		=	get_create_object_func(HoGE.Pattern.Radial)
HoGE.Matirx.new			=	get_create_object_func(HoGE.Matirx.new)
HoGE.Timer.new			=	get_create_object_func(HoGE.Timer.new)
HoGE.TextRender.new		=	get_create_object_func(HoGE.TextRender.new)

--调试模式下的控制台输出
if arg[2]=="-debug" then
	--------------------------------------------------------------------------------------
	-- @class function
	-- @name print
	--------------------------------------------------------------------------------------
	-- @description 覆盖掉默认的print函数(使用Console.puts输出到游戏调试控制台
	-- @param ... 可变参数,输出内容
	-- @return 无
	--------------------------------------------------------------------------------------
	function print(...)
		local resultt={}
		for k,v in ipairs({...}) do
			table.insert(resultt,tostring(v))
		end
		local r=table.concat(resultt,"\t")
		Console.puts(r)
	end
	print("==以调试模式进入游戏==")
end


--------------------------------------------------------------------------------------
-- @class function
-- @name GBK
--------------------------------------------------------------------------------------
-- @description 将字符串从UTF8转为GBK
-- @param s utf8串
-- @return gbk串
--------------------------------------------------------------------------------------
function GBK(s)
	return coding.utoa(coding.u8tou(s))
end

--------------------------------------------------------------------------------------
-- @class function
-- @name table.copy
--------------------------------------------------------------------------------------
-- @description lua没有默认的表拷贝函数,这个函数实现了表的拷贝
-- @param ori_tab原表
-- @return 新表
--------------------------------------------------------------------------------------
function table.copy(ori_tab)
    if (type(ori_tab) ~= "table") then
        return nil;
    end
    local new_tab = {};
    for i,v in pairs(ori_tab) do
        local vtyp = type(v);
        if (vtyp == "table") then
            new_tab[i] = table.copy(v);
        elseif (vtyp == "thread") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        elseif (vtyp == "userdata") then
            -- TODO: dup or just point to?
            new_tab[i] = v;
        else
            new_tab[i] = v;
        end
    end
    return new_tab;
end


--引入socket库,这里用于sleep
require "socket"

--------------------------------------------------------------------------------------
-- @class function
-- @name sleep
--------------------------------------------------------------------------------------
-- @description 休眠函数
-- @param sec 休眠的时间,以秒为单位
-- @return 无
-- (* 不久之后可能这个函数将会被废除,HoGE将自绑定Sleep函数以减少库的引用数量)
--------------------------------------------------------------------------------------
function sleep(sec)
    socket.select(nil, nil, sec)
end


