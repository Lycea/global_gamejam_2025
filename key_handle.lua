 key_list ={

 }
 
 
 
 key_mapper={
   a = "left",
   d = "right",
   w ="up",
   s ="down",
   
   escape="exit",
   ["space"] ="use",
   ["return"] = "select",
   
   mt={
     __index=function(table,key) 
      return  "default"
     end
     
     }
   }
 
 setmetatable(key_mapper,key_mapper.mt)
 


key_list_game={
  up={move={0,-1}},
  down={move={0,1}},
  left={move={-1,0}},
  right={move={1,0}},
  
  attack={attack=true},
  
  exit = {exit = true},
  default={},
  mt={
     __index=function(table,key) 
      return  {}
     end
     
     }
}



key_list_main_manue={
    up={menue_idx_change={0,-1}},
    down={menue_idx_change={0,1}},
    use={selected_item = true},
    exit = {exit = true},
    mt={
     __index=function(table,key) 
      return  {}
     end
     }
}




key_list_paused={
    inventory={show_inventory = true},
    exit = {exit = true},
    mt={
     __index=function(table,key) 
      return  {}
     end
     
     }
}


key_list_end_menue = {
  use = { selected_item = true },
  mt = {
    __index = function(table, key)
      return {}
    end
  }
}

key_list_upgrade_menue = {
  left = { idx_change = { -1, 0 } },
  right = { idx_change = { 1, 0 } },
  use = { selected_item = true },
  mt = {
    __index = function(table, key)
      return {}
    end
  }
}
setmetatable(key_list_main_manue, key_list_main_manue.mt)
setmetatable(key_list_paused, key_list_paused.mt)
setmetatable(key_list_game, key_list_game.mt)

setmetatable(key_list_upgrade_menue, key_list_upgrade_menue.mt)
setmetatable(key_list_end_menue, key_list_end_menue.mt)






local exit_timer



function handle_main_menue(key)
  debuger.on()
  return key_list_main_manue[key_mapper[key]]
end


function handle_end_menue(key)
  debuger.on()
  return key_list_end_menue[key_mapper[key]]
end

function handle_upgrade_menue(key)
  debuger.on()
  return key_list_upgrade_menue[key_mapper[key]]
end

function handle_keys(key)
    debuger.on()
    local state_caller_list ={
      [GameStates.PLAYING] = key_list_game,
      [GameStates.PAUSED] = key_list_paused,
    }

     return state_caller_list[game_state][key_mapper[key]]
end


--------------------------------------------------------------------------------------
---- KEY HANDLE END MOUSE START
--------------------------------------------------------------------------------------



function handle_mouse(mouse_event)
    if mouse_event ~= nil then
        
    end
end
