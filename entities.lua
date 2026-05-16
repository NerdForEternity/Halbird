function setup_entities()
    entities = {}
end

function spawn_entity(x, y, sp, hp)
    local e = {
        x = x,
        y = y,
        sp = sp,
        hp = hp
    }
    add(entities, e)
end

function update_entities()
    for e in all(entities) do
        e.y += 1 --make enemies fall
        
        -- Remove enemy if health is zero
        if e.hp <= 0 then
            del(entities, e)
        end
    end
end


function draw_entities()
    for e in all(entities) do
        spr(e.sp, e.x, e.y)
    end
end