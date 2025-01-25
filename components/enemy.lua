local enemy = class_base:extend()

local function lerp_(x,y,t) local num = x+t*(y-x)return num end

local function lerp_point(x1,y1,x2,y2,t)
  local x = lerp_(x1,x2,t)
  local y = lerp_(y1,y2,t)
  --print(x.." "..y)
  return x,y
end

local function distance(self ,other)
  local dx = other.x-self.x
  local dy = other.y-self.y
  return math.sqrt(math.pow(dx,2)+math.pow(dy,2))
end


function enemy:new(x,y,w,h,max_hp)
  self.pos = { x = x, y = y }
  self.max_hp = max_hp
  self.current_hp = self.max_hp
  self.size={w=w,h=h}
  self.speed = 0.05
end

function enemy:draw()
  love.graphics.rectangle("line",self.pos.x,self.pos.y , self.size.w ,self.size.h)
end


function enemy:update(dt , goal)
  local dist = distance(self.pos, goal.pos)

  local perc_to_move =  self.speed / dist

  print("perc",perc_to_move)
  local new_x,new_y = lerp_point(self.pos.x,self.pos.y,goal.pos.x,goal.pos.y,perc_to_move)
 self.pos.x = new_x
 self.pos.y = new_y

 --TODO: calculate and use speed correctly  =  100% = dist  -> 100% / speed = perc moved

--self.pos.x = self.pos.x +0.1
end

return enemy
