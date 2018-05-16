return function(triggerblockFactory, dispatcher, objectFactory, id, triggerId)
  
  local trigger = triggerblockFactory(objectFactory, id, dispatcher, function(self) return function()    
    local event = {
      name = "remote.trigger",
      id = triggerId
    }
    dispatcher:dispatch(event)
  end end, function() 
    love.graphics.print("Trigger: " .. triggerId, 3, 20)
  end,
  directions)

  trigger:addType("remote")
  
  return trigger
end