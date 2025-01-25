local weapon = class_base:extend()
local particles = {}



function weapon:new(parent,enemies)
  self.particel_spawn_time = 0.5
  self.spawn_timer = timer(self.particel_spawn_time)

  self.pirce_amount = 0

  self.particle_spawn_amount = 1
  self.spawn_angle = 30
  self.spawn_directions=1   -- 1,2,4 possible

  self.rotation_speed = 0
  self.rotation_offset = 0

  self.parent = parent
  self.enemies = enemies

  self.last_valid_movement = {x=-1,y=0}
end

function weapon:draw()
  love.graphics.rectangle("line", scr_w / 2 - 20, scr_h / 2 - 30, 20, 20)

  for i, particle in pairs(particles) do
    love.graphics.circle("line",particle.pos.x,particle.pos.y, 10)
  end
end


function weapon:update(dt)
  if self.parent.last_movement.x == 0 and
     self.parent.last_movement.y == 0 then

  else
    self.last_valid_movement.y = self.parent.last_movement.y
    self.last_valid_movement.x = self.parent.last_movement.x
  end
  for i, p in pairs(particles) do
    p.pos.x = p.pos.x + (p.m_x * p.speed) * dt 
    p.pos.y = p.pos.y + (p.m_y * p.speed) * dt
  end

  local remove_list = {}

  --check collisiones (scarry stuff)
  for i,p in pairs(particles) do
    for en_i ,enemy in pairs(self.enemies) do
      if math.abs( p.pos.x - enemy.pos.x ) < 40 then
        if h_.circle_rectangle_collision(p.pos.x,p.pos.y,p.size.w,
                                enemy.pos.x,enemy.pos.y,enemy.size.w,enemy.size.h) == true then
          table.insert(remove_list,1, en_i)
        end
      end
    end
  end

  for id ,v in ipairs(remove_list) do
    table.remove(self.enemies,v)
  end

  --add new particle(s) on timer
  if self.spawn_timer:check() then
    local new_bubble = {
      pos={
        x = self.parent.pos.x,
        y = self.parent.pos.y
      },
      m_x = self.last_valid_movement.x,
      m_y = self.last_valid_movement.y,
      size = { w = 10, h = 10 },
      speed = 400,
      
    }
    table.insert(particles,new_bubble)
  end



end

return weapon
