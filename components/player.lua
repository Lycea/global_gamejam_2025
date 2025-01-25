local player = class_base:extend()
local weapon = require("../components/weapon")

function player:new()
 self.pos ={x=0,y=0}
 self.max_hp = 100
 self.current_hp = self.max_hp
 self.weapon = weapon()
 self.invis_time = 0.3
 self.invis_timer = timer(self.invis_time)
 self.alive = true
 self.size = {w=20,h=20}

end


function player:draw()
  love.graphics.print(self.current_hp)
  love.graphics.rectangle("line",scr_w/2 -20,scr_h/2 -30, 40,60)
  self.weapon:draw()
end

function player:move(x,y)
  self.pos.x = self.pos.x + x
  self.pos.y = self.pos.y + y
end

function player:update()
end

function player:collide(other)

  local other_points = h_.pos_size_to_two_points(other.pos, other.size)
  local self_points  = h_.pos_size_to_two_points(self.pos, self.size)

  return h_.rect_collision_tables(self_points[1],self_points[2],
                                  other_points[1],other_points[2])
end

function player:collide_item(item)
  if self:collide(item) == true then 

  end
end

function player:collide_enemy(enemy)
  if self:collide(enemy) == true then
    self:hit(enemy.dmg)
  end
end


function player:hit(dmg)
  if self.invis_timer:check() == true then
    self.current_hp = self.current_hp - dmg
  end

  if self.current_hp <= 0 then
    self.alive = false
  end

end

return player
