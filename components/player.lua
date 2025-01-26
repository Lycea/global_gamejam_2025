local player = class_base:extend()
local weapon = require("../components/weapon")

function player:new(enemies)
 self.pos ={x=0,y=0}
 self.last_movement ={x=0,y=0}

 self.max_hp = 100
 self.current_hp = self.max_hp

 self.invis_time = 0.3
 self.invis_timer = timer(self.invis_time)

 self.alive = true

 self.size = {w=20,h=20}

 self.norm_speed = 80
 self.cur_speed = self.norm_speed

 self.weapon = weapon(self,enemies)

 self.exp_needed = 50
 self.cur_exp = 0
 self.exp_multi = 1.1
end


function player:draw()
  love.graphics.print(self.current_hp)
  love.graphics.rectangle("line",scr_w/2 -self.size.w/2 ,scr_h/2 -self.size.h/2  , self.size.w, self.size.h)
end


function player:move(x, y, dt)
  self.last_movement.x = self.last_movement.x + x
  self.last_movement.y = self.last_movement.y + y

  x=x*self.cur_speed
  y=y*self.cur_speed

  print(x,y)
  self.pos.x = self.pos.x + (x  * dt)
  self.pos.y = self.pos.y + (y * dt)
end



function player:update(dt)
  local exp_gained = self.weapon:update(dt)
  local level_up = false

  if self.cur_exp + exp_gained >= self.exp_needed then
    self.cur_exp = math.abs( self.exp_needed - (self.cur_exp + exp_gained) )
    level_up = true
    self.exp_needed = self.exp_needed * self.exp_multi
  else
    self.cur_exp = self.cur_exp + exp_gained
  end

  self.last_movement.x = 0
  self.last_movement.y = 0

  return level_up
end

function player:collide(other)

  if math.abs(self.pos.x - other.pos.x)  < self.size.w + other.size.w then

    local other_points = h_.pos_size_to_two_points(other.pos, other.size)
    local self_points  = h_.pos_size_to_two_points(self.pos, self.size)

    return h_.rect_collision_tables(self_points[1],self_points[2],
                                    other_points[1],other_points[2])
  end

  return false
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
