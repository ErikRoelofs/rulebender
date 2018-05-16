return function(triggerblockFactory, dispatcher, objectFactory, id)
  
  local flag = triggerblockFactory(objectFactory, id, dispatcher, function(self) return function()    
    local event = {
      name = "level.completed"
    }
    dispatcher:dispatch(event)
  end end, function() 
    love.graphics.print("Win!", 3, 20)
  end,
  directions)

  flag:addType("flag")
  
  return flag
end