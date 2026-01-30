local weapon = class_base:extend()
local particles = {}



function weapon:new(parent,enemies)
  self.particel_spawn_time = 0.5
  self.spawn_timer = timer(self.particel_spawn_time)

  self.pirce_amount = 1

  self.particle_spawn_amount = 1
  self.spawn_angle = 30
  self.spawn_directions=1   -- 1,2,3 possible

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

local upgrade_info_list ={
  particel_spawn_time = { -0.05, 10, 9, "Faster bubbles", "Increase the speed\n at which bubbles spawn", "white" },
  pirce_amount = { 1, 7, 7, "more pirce", "Increases the amount \n of pirce by a bubble +1", "white" },
  particle_spawn_amount = { 1, 10, 9, "more bubbles", "Increase the amount of bubbles per blow +1", "green" },
  spawn_angle = { 5, 90, 12, "spread increase", "Incrise the area spread\n of bubbles +1 ", "white" },
  spawn_directions = { 1, 3, 2, "More directions",
    "Increase the directions\n in which bubbles are blown\n simultaneously", "pink" }
}

function weapon:get_upgrade_list()
  local changed_list ={}

  for name, upgrade  in pairs(upgrade_info_list) do
    
    table.insert(changed_list,{ upgrade[4] , upgrade[5] , upgrade[6] , 0, upgrade[3], 0 , name  })
  end

  return changed_list
end

function weapon:upgrade(upgrade_name)
  print(upgrade_name)
  print(self[upgrade_name])
  self[upgrade_name] =  self[upgrade_name] + upgrade_info_list[upgrade_name][1] 

  self.spawn_timer=timer(self.particel_spawn_time)
end


function weapon:spawn_bubble(x,y)
  local new_bubble = {
    pos = {
      x = self.parent.pos.x + love.math.random(-4, 4),
      y = self.parent.pos.y + love.math.random(-4, 4)
    },
    m_x = x,
    m_y = y,
    pirce = self.pirce_amount,
    size = { w = 10, h = 10 },
    speed = 400,
    lifetime = 1

  }
  print("bubble,pirce",new_bubble.pirce)
  table.insert(particles, new_bubble)
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
  local remove_list_particles = {}

  --check collisiones (scarry stuff)
  for i, p in pairs(particles) do
    local added_to_remove = false
    p.lifetime = p.lifetime - dt
    for en_i, enemy in pairs(self.enemies) do
      if math.abs(p.pos.x - enemy.pos.x) < 40 then
        if h_.circle_rectangle_collision(p.pos.x, p.pos.y, p.size.w,
                                         enemy.pos.x, enemy.pos.y, enemy.size.w, enemy.size.h) == true then
          p.pirce = p.pirce - 1
          if p.pirce <= 0 then
            table.insert(remove_list_particles, 1, i)
            added_to_remove = true
          end
          
          table.insert(remove_list, 1, en_i)
        end
      end
    end
    if added_to_remove == false and p.lifetime < 0 then
      table.insert(remove_list_particles,1,i)
    end
      
  end

  local gained_exp = 0

  table.sort(remove_list, function (a, b) return a > b end  )

  local check_removed ={}
  for id ,v in ipairs(remove_list) do
    if check_removed[v] == nil then

      local tmp_enemy = table.remove(self.enemies, v)
      gained_exp = gained_exp + tmp_enemy.exp
      check_removed[v] = true
    end
  end

  for id, v in ipairs(remove_list_particles) do
      local tmp_part = table.remove(particles, v)
  end

  --add new particle(s) on timer
  if self.spawn_timer:check() then

    if self.spawn_directions == 1 then
      for i=1, self.particle_spawn_amount  do

        self:spawn_bubble(self.last_valid_movement.x,self.last_valid_movement.y)
      end
    end

    if self.spawn_directions == 2 then
      for i = 1, self.particle_spawn_amount do
        self:spawn_bubble(self.last_valid_movement.x, self.last_valid_movement.y)
        self:spawn_bubble(self.last_valid_movement.x*-1, self.last_valid_movement.y*-1)
      end
    end

    if self.spawn_directions >= 3 then
      for i = 1, self.particle_spawn_amount do
        self:spawn_bubble(1, 0)
        self:spawn_bubble(-1, 0)
        self:spawn_bubble(0, -1)
        self:spawn_bubble(0, 1)
      end
    end

  end

  return gained_exp

end

return weapon
