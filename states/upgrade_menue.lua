local upgrade_menue = class_base:extend()



local col ={
  black = {0,0,0},
  white = {255,255,255},
  green = {0,255,0},
  pink  = {255,255,0}
}


-- choices is the amount of choices and the list shall contain something like:
-- {{<name>,<desc>,<rarity>,<chance>,<max_amount>,<used_amount>,<intern_name>}}
 function upgrade_menue:new(choices,choice_list_probs)
  self.available_choices = choice_list_probs
  self.choice_num = choices

  self.cur_idx = 1

  self.cur_selections = {}
end

gr = love.graphics

function upgrade_menue:select_upgrades()
  self.cur_selections ={
    {"upgrade 1", " TODO information","white",0, 20,0, "upg_1" },
    {"upgrade 2", " TODO","green",0, 20,0, "upg_1" },
    {"upgrade 3", " TODO ","pink",0, 20,0, "upg_1"}
  }
end

function filled_bordered_rect(pos, size, outside_c, inside_c, selected)
  gr.setColor(inside_c)
  gr.rectangle("fill", pos.x, pos.y, size.w, size.h)

  gr.setColor(outside_c)
  gr.rectangle("line", pos.x, pos.y, size.w, size.h)

  if selected == true then
    gr.setColor(col["white"])
    gr.rectangle("line", pos.x - 2, pos.y - 2, size.w + 4, size.h + 4)
  end
end

function upgrade_menue:draw()
  local window_w = scr_w - 50 * 2
  local window_h = scr_h - 50 * 2
  local window_size = {w=window_w,h=window_h}

  local window_pos={x=50,y=50}
  filled_bordered_rect(window_pos,window_size,col.white,col.black,false)

  local c = 0
  local _rect_sizes ={
    w = (window_w - 2 * 20  - (self.choice_num -1)*10 ) / self.choice_num,
    h = window_h - 2 * 20
  }

  for id, choice in  pairs(self.cur_selections) do
    local upgrade_pos ={
      x = window_pos.x + 20 + c*10  + _rect_sizes.w * c ,
      y = window_pos.y + 20
    }
    
    filled_bordered_rect(upgrade_pos,_rect_sizes, col[choice[3]],col.black, self.cur_idx == c+1 )

    gr.print(choice[1],upgrade_pos.x + 5, upgrade_pos.y +5 )
    gr.print(choice[2],upgrade_pos.x +5, upgrade_pos.y + 20)

    c=c+1
  end
end

function upgrade_menue:upgrade(movement)

  self.cur_idx = self.cur_idx + movement

  if self.cur_idx < 1 then
    self.cur_idx = self.choice_num
  end
  if self.cur_idx > self.choice_num then
    self.cur_idx = 1
  end

end

function upgrade_menue:selected(idx)

end



return upgrade_menue
