return function(triggerblockFactory, objectFactory, dispatcher, id, targetId, directions)       
  local doorIsClosed = true 
  return triggerblockFactory(objectFactory, id, dispatcher, 
    function(self) return function()
      if doorIsClosed then
        doorIsClosed = false
        dispatcher:dispatch({name="door.open", targetId=targetId})
      else
        doorIsClosed = true
        dispatcher:dispatch({name="door.close", targetId=targetId})
      end            
    end end,
    function()
      love.graphics.print("doorswitch", 4, 20)
    end, 
    directions
  )
end