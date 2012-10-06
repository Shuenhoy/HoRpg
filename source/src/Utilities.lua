

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

function Split(str, delim, maxNb)   
    -- Eliminate bad cases...   
    if string.find(str, delim) == nil then  
        return { str }  
    end  
    if maxNb == nil or maxNb < 1 then  
        maxNb = 0    -- No limit   
    end  
    local result = {}  
    local pat = "(.-)" .. delim .. "()"   
    local nb = 0  
    local lastPos   
    for part, pos in string.gfind(str, pat) do  
        nb = nb + 1  
        result[nb] = part   
        lastPos = pos   
        if nb == maxNb then break end  
    end  
    -- Handle the last field   
    if nb ~= maxNb then  
        result[nb + 1] = string.sub(str, lastPos)   
    end  
    return result   
end  


--- 获取utf8编码字符串正确长度的方法
-- @param str
-- @return number
function string.utf8len(str)
	local len = #str
	local left = len
	local cnt = 0
	local arr={0,0xc0,0xe0,0xf0,0xf8,0xfc}
	while left ~= 0 do
		local tmp=string.byte(str,-left)
		local i=#arr
		while arr[i] do
			if tmp>=arr[i] then 
				left=left-i
				break
			end
			i=i-1
		end
		cnt=cnt+1
	end
	return cnt
end