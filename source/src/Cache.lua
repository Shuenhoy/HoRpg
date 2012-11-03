local Image,Sprite=HoGE.Image,HoGE.Sprite
local string=string
Cache={}

do local _ENV=Cache
  cache={}
  
  
  function load_file(path,filename)
    local fn
    if not filename then
      fn=path
    else
      fn=string.format("%s/%s",path,filename)
    end
    if not include(fn) then
      cache[fn]=Image:FromFile(fn)
    end
    return cache[fn]
  end
  function include(filename)
    return cache[filename]~=nil
  end

end


