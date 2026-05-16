-- Constants for easy tuning
const = {
    grav = 0.5,
    jmp = -4.5,
    floor_y = 92,
}

function make_player()
	p={}
	p.x=64 --position
    p.y=64  
	p.dx=0 --velocity
    p.dy=0  
	p.sp=1 --sprite id
	p.flp=false --horizontal flip
	
	--physics constants
	p.acc=0.5 --acceleration
	p.fric=0.8 --friction
	p.grav=0.5 --gravity
	p.jmp=-4.5 --jump power
	
	-- weapon variables
	p.wx=0 -- weapon position
    p.wy=0 
    p.w_angle = 0    -- rotation in "turns" (0 to 1)
    p.w_av = 0 -- angular velocity
    p.w_dist = 10  -- how far the weapon is from the player center
    p.w_sp = 16    -- the sprite id for your weapon
	
	-- heavy physics
	p.w_acc = 0.005 -- weapon acceleration
	p.w_fric = 0.94 -- air resistance
    
	p.state="menu" --player state
end


function update_player()
    states[p.state].update()
end

function draw_player()
  states[p.state].draw()
end

function calculate_weapon_position()
    -- 4. calc weapon position based on the new p.x and p.y
    p.wx = p.x + 4 + cos(p.w_angle) * p.w_dist
    p.wy = p.y + 4 + sin(p.w_angle) * p.w_dist
    
end

function  calculate_weapon_collision()
    -- 4. calculate the "hook point" (bottom-right of sprite)
    -- we rotate the offset (3,3) by the axe's angle
    local h_off_x = -3 * cos(p.w_angle) - 3 * sin(p.w_angle)
    local h_off_y = -3 * sin(p.w_angle) + 3 * cos(p.w_angle)
    local hx = p.wx + h_off_x
    local hy = p.wy + h_off_y   

    -- 5. weapon collision
    -- check map for Flag 1
    local tile = mget(hx/8, hy/8)
    local is_hooked = fget(tile, 1)

    if is_hooked then
        -- hook physics: pull player toward the hook point
        local pull_x = hx - (p.x + 4)
        local pull_y = hy - (p.y + 4)
        
        -- the "stiffness" of the hook
        p.dx += pull_x * 0.1
        p.dy += pull_y * 0.1
        
        -- friction while hooked (prevents infinite vibration)
        p.dx *= 0.9
        p.dy *= 0.9
        
        -- kill some rotation speed when caught
        p.w_av *= 0.8
        
        -- visual feedback: change handle color
        p.line_col = 11 -- lime green
    else
        p.line_col = 7  -- white

    end

    -- check collisiion with floor (simple y check)
    if p.wy > 100 then
        -- how far is the axe underground?
        local dist_under = p.wy - 100
        
        -- move the player up by that exact amount 
        -- this stops the "velocity accumulation" glitch
        p.y -= dist_under        
        -- update weapon y so it stays on top of the floor
        p.wy = 100
        
        p.w_av *=0.5
        
        -- calculate the push vector
        local push_x = (p.x + 4) - p.wx
        local push_y = (p.y + 4) - p.wy
        
        -- apply a smaller, controlled burst of speed
        p.dx += push_x * 0.1
        -- we use a negative value to ensure we go up
        p.dy = -1.5 + (push_y * 0.2) 
   
   					-- add screen shake
   					shake = 1
                    shake_amount = p.w_av * 150 -- the stronger the weapon acceleration, the stronger the shake
   					
   					-- play sfx
   					sfx(0)
    end

    -- check collision with collider tiles (Flag 0)

    end