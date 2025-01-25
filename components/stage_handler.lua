local timer = require("../helper/timer")
local enemy = require("../components/enemy")

local stage_handler = class_base:extend()



function stage_handler:new(stage,enemy_list,player)
  self.spawn_interval = 0.1
  self.sub_stage_timing = 10000000
  self.substages = {}

  self.enemy_list = enemy_list
  self.player = player
  self.spawn_timer = timer(self.spawn_interval)
end



function calculate_point(base_pos, min_dist,max_dist)
  local dist = love.math.random(min_dist,max_dist)
  local angle = love.math.random(0,360)
  -- Convert angle from degrees to radians
  local angle_rad = math.rad(angle)
  -- Calculate the new point
  local x2 = base_pos.x + dist * math.cos(angle_rad)
  local y2 = base_pos.y + dist * math.sin(angle_rad)

  return x2, y2
end

function stage_handler:update(dt)
 if self.spawn_timer:check() == true then
   local pos_x,pos_y = calculate_point(self.player.pos, 400,400 )
   table.insert(self.enemy_list,enemy(pos_x,pos_y,20,20,5))
 end
end

return stage_handler
