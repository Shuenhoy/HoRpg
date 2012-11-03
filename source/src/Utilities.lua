
--引入socket库,这里用于sleep
require "socket"

require("coding")
local yaml=require "yaml"
local zlib=require "lua-zlib"
local tea=coding.tea
local teadec=coding.teadec
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



local function myteadec(input,key)
  local output_byte={}
  local length=#input
  for i=1,length,8 do 
    local temp=string.sub(input,i,i+7)
    local out1=teadec(temp,key)
    table.insert(output_byte,out1)
  end
  local out_str=table.concat(output_byte)
  local n=string.byte(out_str,-1)

  return string.sub(out_str,1,#out_str-n)
end



local argv
local data
function loader_init(filname,k)
  argv=arg
  local uncompress = zlib.inflate()  
  if arg[2]~="-debug" then
    local fp=io.open(filname,"rb")
    require("cjson")
    
    
    if fp==nil then  
      error [[cannot find the Resource file]];  
    end
    
    
    data=cjson.decode(myteadec(uncompress(file),k));
    fp:close()
  end  
end
function load_data(name,t)
  if arg[2]=="-debug" then
    local fp=assert(io.open(name,t or "r"))
    local a=fp:read("*a")
    fp:close()
    return a
  else
    return data[name]
  end
end
function table.foreach(t,f)
  for k,v in pairs(t) do
    f(k,v)
  end
end
function table.foreachi(t,f)
  for i,v in ipairs(t) do
    f(i,v)
  end
end

function samepos(a,b)
  return (a.x or a.X) == (b.x or b.X) and (a.y or a.Y) == (b.y or b.Y)
end
function frontof(a,b,d)
  if d==4 then
    return (a.x or a.X) == (b.x or b.X) and (a.y or a.Y) == (b.y or b.Y) - 1
  elseif d==1 then
    return (a.x or a.X) == (b.x or b.X) and (a.y or a.Y) == (b.y or b.Y) + 1
  elseif d==2 then
    return (a.x or a.X) == (b.x or b.X) - 1 and (a.y or a.Y) == (b.y or b.Y)
  elseif d==3 then
    return (a.x or a.X) == (b.x or b.X) + 1 and (a.y or a.Y) == (b.y or b.Y)
  end
end
function frontpos(a,d)
  if d==4 then
    return (a.x or a.X) , (a.y or a.Y) - 1
  elseif d==1 then
    return (a.x or a.X) , (a.y or a.Y)  + 1
  elseif d==2 then
    return (a.x or a.X) - 1 ,(a.y or a.Y) 
  elseif d==3 then
    return (a.x or a.X)  + 1 , (a.y or a.Y)
  end
end


ZPosSet={
  MapBottom     =   1 ;
  MapTop        =  10 ; 
  Character     =   4 ;
  Window        =  50 ;
  WindowText    =  51 ;
  UnderWindow   =  49 ;
}




