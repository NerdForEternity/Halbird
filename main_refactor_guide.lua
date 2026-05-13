function _init()
  make_player()
  state = "menu"
end

function _update()
  update_screen_shake() -- keep logic separate from draw
  
  if state == "menu" then
    if (btnp(4)) state = "play"
  elseif state == "play" then
    update_player()
  end
end

function _draw()
  cls()
  apply_camera_shake() -- sets camera offsets
  
  map(0, 0, 0, 0, 16, 16)
  
  if state == "menu" then
    rect(20, 50, 107, 77, 7)
    print("press 🅾️ to start", 30, 60, 7)
  elseif state == "play" then
    print(background_text, 2, 2, 14)
    draw_player()
  end
end

-- helper for camera effects
function update_screen_shake()
  if shake > 0 then
    shake -= 0.5
  else
    shake = 0
  end
end

function apply_camera_shake()
  if shake > 0 then
    local sx = 2 - shake_amount + (rnd(3)/3)
    local sy = 2 - shake_amount + (rnd(3)/3)
    camera(sx, sy)
  else
    camera(0, 0)
  end
end