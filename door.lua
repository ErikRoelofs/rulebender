return function(objectFactory, id)
  
  local closedDoor = objectFactory()
    :thatIsSolid()
    :withIdentifier(id)
    :thatCanBeDrawn(function(self)
      love.graphics.setColor(0.7,0.2,0.2,1)
      love.graphics.rectangle("fill", 2, 2, 46, 46)
      love.graphics.setColor(1,1,1,1)
    end)
    :go()
  
  local openDoor = objectFactory()
    :withIdentifier(id)
    :thatCanBeDrawn(function(self)
      love.graphics.setColor(0.7,0.2,0.2,0.4)
      love.graphics.rectangle("fill", 2, 2, 46, 46)
      love.graphics.setColor(1,1,1,1)    
    end)
    :go()
  
  closedDoor.open = function(event)
    if event.targetId ~= closedDoor.id then return end
    local newEvent = {
      name = "object.replace",
      existingObject = closedDoor,
      newObject = openDoor
    }
    openDoor.dispatcher:dispatch(newEvent)    
  end
  
  openDoor.close = function(event)
    if event.targetId ~= openDoor.id then return end
    local newEvent = {
      name = "object.replace",
      existingObject = openDoor,
      newObject = closedDoor
    }
    openDoor.dispatcher:dispatch(newEvent)
  end
  
  closedDoor.dispatcher:listen("door.open", closedDoor.open)
  openDoor.dispatcher:listen("door.close", openDoor.close)  
  
  return closedDoor
end