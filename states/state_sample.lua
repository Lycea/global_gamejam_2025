local sample_state =class_base:extend()
local player =require("../components/player")
local enemy = require("../components/enemy")
local stage_handler = require("../components/stage_handler")

local active_player = nil
local enemies = {}

local key_handler = nil
local stage = nil
function sample_state:new()

end


function sample_state:startup()
 print("startup")
 active_player =player()
 stage=stage_handler("first_stage",enemies,active_player)

 --table.insert(enemies,enemy(-40,-40, 10,10, 5))
end

function sample_state:set_key_handle(handle)
  key_handler = handle
end

function sample_state:draw()
  love.graphics.setColor(0,0,255,255)
  active_player:draw()

  local enemy_num = 0

  love.graphics.setColor(255,0,0,255)
  love.graphics.push()
    love.graphics.translate(-active_player.pos.x +scr_w/2,-active_player.pos.y +scr_h/2)

    for idx,enemy_obj in pairs(enemies) do
      enemy_num = enemy_num +1
      enemy_obj:draw()
    end

  love.graphics.pop()

  love.graphics.print( " DEBUG:\n  hp:"..active_player.current_hp.."\n  enemies:"..enemy_num.."\n  fps"..love.timer.getFPS())
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
    end

    active_player:move(movement.x,movement.y)

  end

  for idx, enemy_obj in pairs(enemies) do
    enemy_obj:update(dt, active_player)
    active_player:collide_enemy(enemy_obj)
  end
  stage:update(dt)
end

function sample_state:shutdown()
    
end





return sample_state()
