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
    end,

    draw = function()
        spr(p.sp, p.x, p.y, 1, 1, p.flp)
    end


}

states.swing = {
    update = function(self)
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

    calculate_weapon_position()
    calculate_weapon_collision()

    -- 6. transition back to move state if weapon button released
    if not btn(5) then p.state = "move" end


    end
, 
    draw = function()
        --draw player sprite
        spr(p.sp, p.x, p.y, 1, 1, p.flp)
        -- draw the handle
        line(p.x + 4, p.y + 4, p.wx, p.wy, 7)
        -- use our new rotated sprite function
            -- we pass p.wx/p.wy as the center of the rotation
            rspr(p.w_sp, p.wx, p.wy, p.w_angle)

            -- debug: draw the hook point so you can see it
            local h_off_x = -3  * cos(p.w_angle) - 3 * sin(p.w_angle)
            local h_off_y = -3 * sin(p.w_angle) + 3 * cos(p.w_angle)
            pset(p.wx + h_off_x, p.wy + h_off_y, 8)
 	end
}

states.game_over = {
    update = function()
        -- game over logic here
    end,
    draw = function()
        spr(3, p.x, p.y)
    end
}

states.menu = {
    update = function()
        if (btnp(4)) p.state = "move"
    end,
    draw = function()
        rect(20, 50, 107, 77, 7)
        print("press 🅾️ to start", 30, 60, 7)
    end
}
