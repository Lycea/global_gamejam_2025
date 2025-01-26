local sample_state =class_base:extend()
local player =require("../components/player")
local enemy = require("../components/enemy")
local stage_handler = require("../components/stage_handler")
local end_menue = require("../states/end_menue")
local upgrade_menue = require("../states/upgrade_menue")

local active_player = nil
local enemies = {}

local key_handler = nil
local stage = nil

local is_upgrading = false
local level_up = false


local end_screen = nil
local upgrade_screen = nil

local idx_change_timer = timer(0.1)

stats = {}



function sample_state:new()

end


function sample_state:startup()
 print("startup")
 enemies = {}
 stats   = {}

 active_player =player(enemies)
 stage=stage_handler("first_stage",enemies,active_player)

 --table.insert(enemies,enemy(-40,-40, 10,10, 5))
 end_screen = end_menue()
 upgrade_screen = upgrade_menue(3, active_player.weapon:get_upgrade_list() )
 upgrade_screen:select_upgrades()
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

    active_player.weapon:draw()
  love.graphics.pop()

  love.graphics.print( " DEBUG:\n  hp:"..active_player.current_hp.."\n  enemies:"..enemy_num.."\n  fps"..love.timer.getFPS())

  if is_upgrading == true then
    upgrade_screen:draw()
  end

  if active_player.alive == false then
    end_screen:draw()
  end

end


function sample_state:update(dt, key_list)


  if active_player.alive and is_upgrading == false then
    for key, v in pairs(key_list) do
      attack       = false
      movement     = { x = 0, y = 0 }
      --print("got some id",plid)
      --print(key,v)
      local action = key_handler(key) --get key callbacks

      if action["move"] and game_state == GameStates.PLAYING then
        movement.x = movement.x + action["move"][1]
        movement.y = movement.y + action["move"][2]

        active_player:move(movement.x, movement.y, dt)
      end
    end

    for idx, enemy_obj in pairs(enemies) do
      enemy_obj:update(dt, active_player)
      active_player:collide_enemy(enemy_obj)
    end

    level_up = active_player:update(dt)


    if level_up == true then
      upgrade_screen:select_upgrades()
      level_up = false
      is_upgrading = true
    end

    stage:update(dt)
  end
  --  xp formula   = 1.1^lvl
  if is_upgrading == true then
    local movement = { 0, 0 }
    local selected = false

    for key, v in pairs(key_list) do
      local action = handle_upgrade_menue(key)

      if action["idx_change"] then
        movement = action["idx_change"]
      end

      if action["selected_item"] then
        selected = true
      end
    end

    if selected == true then
      upgrade_screen:selected()
      is_upgrading = false
    end

    if idx_change_timer:check() then
      upgrade_screen:upgrade(movement)
    end
  end

  if active_player.alive == false then

    game_state = GameStates.MAIN_MENUE
    previous_game_state = game_state

    show_main_menue = true
    main_menue_item = 1

    selected_state_idx = 1

  end
end

function sample_state:shutdown()
    
end





return sample_state()
