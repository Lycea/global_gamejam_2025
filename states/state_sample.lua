local sample_state =class_base:extend()
local player =require("../components/player")

local active_player = nil
local enemies = {}

local key_handler = nil

function sample_state:new()

    
end


function sample_state:startup()
 print("startup")
 active_player =player()

 table.insert(enemies,{pos={x=-40,y=-40}})
end

function sample_state:set_key_handle(handle)
  key_handler = handle
end

function sample_state:draw()
  love.graphics.setColor(0,0,255,255)
  active_player:draw()

  love.graphics.setColor(255,0,0,255)
  love.graphics.push()
    love.graphics.translate(-active_player.pos.x +scr_w/2,-active_player.pos.y +scr_h/2)
    print("player:",active_player.pos.x,active_player.pos.y)

    for idx,enemy in pairs(enemies) do
      love.graphics.rectangle("line",enemy.pos.x,enemy.pos.y,10,10)
    end

  love.graphics.pop()
end



function sample_state:update(dt, key_list)
  for key, v in pairs(key_list) do
    attack       = false
    movement     = { x = 0, y = 0 }
    --print("got some id",plid)
    --print(key,v)
    local action = key_handler(key)   --get key callbacks

    if action["move"] and game_state == GameStates.PLAYING then
      movement.x = movement.x + action["move"][1]
      movement.y = movement.y + action["move"][2]
      print(movement.x, movement.y)
    end

    active_player:move(movement.x,movement.y)
  end
end

function sample_state:shutdown()
    
end





return sample_state()
