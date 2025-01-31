gr = love.graphics


debuger = {
  on = function() if debuger.no_print then return end print("Not able to turn debuger on , start in debug mode")end,
  off = function() if debuger.no_print then return end print("Not able to turn debuger off , start in debug mode")end,
  start = function() if debuger.no_print then return end print("Not able to start debuging , start in debug mode")end,
  no_print = true
}


class_base= require("helper.classic")
console =require("helper.console")
timer =require("helper.timer")

h_=require("helper.helpers")

game =require("game")



local profile = false


local maj,min,rev=love.getVersion()
if maj >= 11 then
    require("helper.cindy").applyPatch()
end



last_axis_1_angle = 0
last_axis_2_angle = 0


function love.load(args)
  

  if profile == true then
    love.profiler = require('helper.profil')
    love.profiler.start()
  end

  for idx, arg in pairs(args) do
      if arg == "-debug" then
        debuger = require("mobdebug")
        debuger.start()
        debuger.off()
        break
      end
  end
  
  
  scr_w,scr_h =love.graphics.getDimensions()
  --love.window.setMode(80*tile_size,50*tile_size)
  game.load()
  
  --love.keyboard.setKeyRepeat(true)
end

love.frame = 0
function love.update(dt)

  if profile == true then
    love.frame = love.frame + 1
    if love.frame % 100 == 0 then
      love.report = love.profiler.report(20)
      love.profiler.reset()
    end
  end

  game.update(dt)
  
end

function love.draw()
  game.draw()

  if profile == true then
    love.graphics.print(love.report or "Please wait...")
  end
end


function love.keypressed(k,s,r)
  game.keyHandle(k,s,r,true)
  if key == "escape" then
    love.event.quit()
  end
  
end

function love.keyreleased(k)
    game.keyHandle(k,0,0,false)
end

function love.mousepressed(x,y,btn,t)
  game.MouseHandle(x,y,btn,t)
end

function love.mousemoved(x,y,dx,dy)
    game.MouseMoved(x,y)
end

function love.joystickpressed(j,b)
    b_to_k ={
        [1] ="x"
    }
    if b_to_k[b]~= nil then
        print(j,b)
        game.joy_handle(j,b_to_k[b],true)
    end
end

function love.joystickreleased(j,b)
    b_to_k ={
        [1] ="x"
    }
    if b_to_k[b]~= nil then
        print(j,b)
        game.joy_handle(j,b_to_k[b],false)
    end
end



function love.joystickaxis(j,a,v)
    print("------------------------------")
    print(j:getName(),a,v)
    print(j:getAxis(a))
    --print(j)
    
    --print(j.getGamepadAxis(j,2))
    
    game.joy_move(j,a,v)
    

end


function love.resize(w,h)
        scr_h=h
        scr_w=w
end
