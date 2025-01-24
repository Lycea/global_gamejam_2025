local weapon = class_base:extend()

function weapon:new()
end

function weapon:draw()
  love.graphics.rectangle("line", scr_w / 2 - 20, scr_h / 2 - 30, 20, 20)
end

function weapon:update()
end

return weapon
