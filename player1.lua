-- Constants for easy tuning
const = {
  grav = 0.5,
  jmp = -4.5,
  floor_y = 92,
  axe_dist = 10,
  axe_acc = 0.005,
  axe_fric = 0.94,
  hook_stiff = 0.1,
  hook_fric = 0.9
}

function make_player()
	p={}
	p.x=64, p.y=64  --position
	p.dx=0, p.dy=0  --velocity
	p.sp=1 --sprite id
	p.flp=false --horizontal flip
	
	--physics constants
	p.acc=0.5 --acceleration
	p.fric=0.8 --friction
	p.grav=0.5 --gravity
	p.jmp=-4.5 --jump power
	
	-- weapon variables
	p.wx=0, p.wy=0 -- weapon position
    p.w_angle = 0    -- rotation in "turns" (0 to 1)
    p.w_av = 0 -- angular velocity
    p.w_dist = 10  -- how far the weapon is from the player center
    p.w_sp = 16    -- the sprite id for your weapon
	
	-- heavy physics
	p.w_acc = 0.005 -- weapon acceleration
	p.w_fric = 0.94 -- air resistance
    
	p.state="move" --player state
end

states = {}

states.move = {

    update = function()
        -- horizontal movement
        if btn(0) then p.dx -= p.acc p.flp = true end
        if btn(1) then p.dx += p.acc p.flp = false end
    
        p.dx *= p.fric
        p.dy += p.grav
    
        -- jump (only if on floor)
        if btnp(4) and p.y >= 92 then p.dy = p.jmp end
    
        apply_physics()

        -- transition to swing
        if btn(5) then p.state = "swing" end
    end

    draw = function()
        spr(p.sp, p.x, p.y, 1, 1, p.flp)
    end


}

states.swing = {


    update = function()
        -- 1. rotate weapon
    if btn(1) then p.w_av -= p.w_acc end
    if btn(0) then p.w_av += p.w_acc end
				
				p.w_av *= p.w_fric
				p.w_angle += p.w_av
    
    -- 2. apply gravity and friction
    p.dy += p.grav
    p.dx *= 0.95 
    p.dy *= 0.95 -- add vertical friction to stop infinite bouncing
    
    -- 3. move the player first
    apply_physics()

    -- 4. calc weapon position based on the new p.x and p.y
    p.wx = p.x + 4 + cos(p.w_angle) * p.w_dist
    p.wy = p.y + 4 + sin(p.w_angle) * p.w_dist
    
    -- 4. calculate the "hook point" (bottom-right of sprite)
    -- we rotate the offset (3,3) by the axe's angle
    local h_off_x = -3 * cos(p.w_angle) - 3 * sin(p.w_angle)
    local h_off_y = -3 * sin(p.w_angle) + 3 * cos(p.w_angle)
    local hx = p.wx + h_off_x
    local hy = p.wy + h_off_y   

    -- 5. weapon collision

    -- 5. check map for Flag 1
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
end
end
    
    draw = function()
        -- draw the handle
        line(p.x + 4, p.y + 4, p.wx, p.wy, 7)
        -- use our new rotated sprite function
            -- we pass p.wx/p.wy as the center of the rotation
            rspr(p.w_sp, p.wx, p.wy, p.w_angle)    end

            -- debug: draw the hook point so you can see it
             local h_off_x = -3  * cos(p.w_angle) - 3 * sin(p.w_angle)
             local h_off_y = -3 * sin(p.w_angle) + 3 * cos(p.w_angle)
             pset(p.wx + h_off_x, p.wy + h_off_y, 8)
 	end

}
