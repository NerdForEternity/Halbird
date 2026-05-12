pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	make_player()
	state="menu"
end

function _update()
	if (state == "menu") menu_update()
	if (state == "play") play_update()
end

function _draw()
	if (state == "menu") menu_draw()
	if (state == "play") play_draw()
end

function menu_update()
--add buttons and menu
	if (btnp(4)) then
		state = "play"
	end
end

function menu_draw()
	cls()
--draw box for menu background
	rect(20,50,107,77,7)
	print("press 🅾️ to start",30,60,7)
end

function play_update()
--actual game loop
	update_player()
end

function play_draw()
--draw game loop
	cls()
	print("press ❎ to\nhold out your axe\n\nidk why it bounces\nthe physics are\nmad glitchy too",30,30,14)
	draw_player()
end




-->8
function update_player()
  if (p.state == "move") then
  	update_player_move()
  elseif (p.state=="swing") then
  	update_player_swing()
  end
  
--logic to switch btwn states
--hold ❎ to enter swing mode
  if btn(5) then
        p.state = "swing"
    else
        p.state = "move"
  end
  
end

function draw_player()
	draw_player_state()
end

function draw_player_state()
	if (game_over) then
		spr(3, p.x, p.y)
	else
	-- draw player body
    spr(p.sp, p.x, p.y, 1, 1, p.flp)
    
    -- only draw weapon if swinging
    if p.state == "swing" then
        -- draw the handle
        line(p.x + 4, p.y + 4, p.wx, p.wy, 7)
        -- use our new rotated sprite function
            -- we pass p.wx/p.wy as the center of the rotation
            rspr(p.w_sp, p.wx, p.wy, p.w_angle)    end
 	end
end

function make_player()
	p={}
	p.x=64  --position
	p.y=64
	p.dx=0 --velocity
	p.dy=0
	p.sp=1 --sprite id
	p.flp=false --horizontal flip
	
	--physics constants
	p.acc=0.5 --acceleration
	p.fric=0.8 --friction
	p.grav=0.7 --gravity
	p.jmp=-4.5 --jump power
	
	-- weapon variables
				p.wx=0
				p.wy=0
    p.w_angle = 0    -- rotation in "turns" (0 to 1)
    p.w_dist = 10    -- how far the weapon is from the player center
    p.w_sp = 16       -- the sprite id for your weapon
	
	p.state="move" --player state
end

function update_player_move()
-- horizontal movement
    if btn(0) then p.dx -= p.acc p.flp = true end
    if btn(1) then p.dx += p.acc p.flp = false end
    
    p.dx *= p.fric
    p.dy += p.grav
    
    -- jump (only if on floor)
    if btnp(4) and p.y >= 100 then 
        p.dy = p.jmp 
    end
    
    apply_physics()
end

function update_player_swing()
-- 1. rotate weapon
    if btn(0) then p.w_angle -= 0.04 end
    if btn(1) then p.w_angle += 0.04 end

-- 2. physics
    p.dy += p.grav
    p.dx *= 0.95 -- slightly less friction in air for swinging

    apply_physics()
-- 3. calc weapon position
    p.wx = p.x + 4 + cos(p.w_angle) * p.w_dist
    p.wy = p.y + 4 + sin(p.w_angle) * p.w_dist

    
    
-- 4. weapon collision (the push)
    if p.wy > 100 and p.wy > p.y + 4 then
        -- calculate vector from weapon head to player center
        local push_x = (p.x + 4) - p.wx
        local push_y = (p.y + 4) - p.wy
        
        -- apply force to player
        p.dx += push_x * 0.1
        p.dy += push_y * 0.3
        
        -- keep weapon from sinking
        p.wy = 100
    end
    
end

function apply_physics()
    p.x += p.dx
    p.y += p.dy
    
    -- floor collision
    if p.y > 100 then
        p.y = 100
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
function rspr(id, sx, sy, a)
 -- id: sprite id
 -- sx, sy: screen center position
 -- a: angle (0-1)
 
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
__gfx__
00000000000007700007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000070070070070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000070070070070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000707700007700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000007000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700007000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070700000070700000770770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000070700000700070077007777000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000554000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000050000055500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000550000455550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
44445554004405500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005550044005000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055555440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00005550400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0202020202000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100003967035670326702e6602a6602565027640216301c6501665010650156101261009610186301f630176400e630076200461004600006000e600006000e6000e6000e6000e6000e6000c6000c6000c600
001100000c0500c0502200018050310001205012000260002700028000280000000029000290002a0002a0002a000250002b0002b0002b0002b0002b0002a000290002700025000220001e0001a0000000000000
__music__
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 01424344

