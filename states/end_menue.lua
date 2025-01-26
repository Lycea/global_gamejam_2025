local end_menue = class_base:extend()






-- choices is the amount of choices and the list shall contain something like:
-- {{<name>,<desc>,<rarity>,<chance>,<max_amount>}}
function end_menue:new(stats)
  self.stats = stats
end

function end_menue:update(dt)
  
end

function end_menue:calc_score()
end

function end_menue:draw_stats()
end
gr=love.graphics
function end_menue:draw()
  love.graphics.setColor(0,0,0,255)
  love.graphics.rectangle("fill",30,30,scr_w-60,scr_h-60)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print("GAME OVER",scr_w/2,scr_h/2)


  love.graphics.setColor(0, 0, 0, 255)
  self:draw_stats()

  love.graphics.setColor(255, 255, 255, 255)
  --gr.rectangle("line",)
  
end



return end_menue
