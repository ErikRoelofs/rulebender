return function(triggerblockFactory, objectFactory, dispatcher, identifier)       
  local doorIsClosed = true 
  return triggerblockFactory(objectFactory, dispatcher, 
    function()
      if doorIsClosed then
        doorIsClosed = false
        dispatcher:dispatch({name="door.open", targetId=identifier})
      else
        doorIsClosed = true
        dispatcher:dispatch({name="door.close", targetId=identifier})
      end            
    end,
    function()
      love.graphics.print("doorswitch", 4, 20)
    end    
  )
end