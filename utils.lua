function apply_physics()
    p.x += p.dx
    p.y += p.dy
    
    -- floor collision
    if p.y > 92 then
        p.y = 92
        p.dy = 0
    --wall collision
    elseif p.x < 0 then
    		p.x = 0
    		p.dx = 0
   	elseif p.x > 100 then
   			p.x = 100
   			p.dx = 0        
    end
end
-->8
--sprite rotation helper function
function rspr(id, sx, sy, a, flp)
 -- id: sprite id
 -- sx, sy: screen center position
 -- a: angle (0-1)
 -- flp: horizontal flip flag
 
 local sw = 8 -- sprite width
 local sh = 8 -- sprite height
 local x0 = (id % 16) * 8  -- sprite sheet x
 local y0 = flr(id / 16) * 8 -- sprite sheet y
 
 -- iterate through the 8x8 area
 for i=0, sw-1 do
  for j=0, sh-1 do
    
   local col = sget(x0+i, y0+j)
   -- don't draw transparent pixels (color 0)
   if col != 0 then
    -- calculate offset from center
    local dx = i - 4
    local dy = j - 4
    
    -- rotate offsets
    local rx = dx * cos(a) - dy * sin(a)
    local ry = dx * sin(a) + dy * cos(a)
    
    pset(sx + rx, sy + ry, col)
   end
  end
 end
end
