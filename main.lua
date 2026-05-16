shake = 0
shake_amount = 0

function _init()
  make_player()
  setup_entities()
  spawn_entity(120, 92, 64, 3) -- example enemy
end

function _update()
  update_screen_shake() -- keep logic separate from draw
  
  if p.state == "menu" then
    if (btnp(4)) p.state = "move"
  elseif p.state == "move"  or p.state == "swing" then
    update_player()
  end
end

background_text = "move: ⬅️➡️\njump: 🅾️\naxe: ❎\nrotate axe: ⬅️➡️"

function _draw()
  cls()
  apply_camera_shake() -- sets camera offsets
  -- draw map for testing

  if p.state == "menu" then
    rect(20, 50, 107, 77, 7)
    print("press 🅾️ to start", 30, 60, 7)
  elseif p.state == "move" or p.state == "swing" then
    print(background_text, 2, 2, 14)
    draw_player()
    draw_entities()
  elseif p.state == "game_over" then
    spr(3, p.x, p.y)
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