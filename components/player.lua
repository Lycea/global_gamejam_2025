local player = class_base:extend()
local weapon = require("../components/weapon")

function player:new()
 self.pos ={x=0,y=0}
 self.max_hp = 100
 self.current_hp = self.max_hp
 self.weapon = weapon()
end


function player:draw()
  love.graphics.rectangle("line",scr_w/2 -20,scr_h/2 -30, 40,60)
  self.weapon:draw()
end

function player:move(x,y)
  self.pos.x = self.pos.x + x
  self.pos.y = self.pos.y + y
end

function player:update()
end

return player
