return function(objectFactory, id, direction, speed, drawF, impactEventF)
  
  local impacter = objectFactory(id)
    :thatCanBeDrawn(drawF)
    :go()
  
  impacter.dispatchCollision = function(self, other, delay)
      local event = impactEventF(self, other, direction, speed)
      self.dispatcher:dispatchDelayed(event, delay)
      
      local removeEvent = {
        name = "object.remove",
        object = self
      }
      self.dispatcher:dispatchDelayed(removeEvent, delay)
      self.dying = true
  end
  
  impacter.dispatcher:listen("object.collision", function(event)
    if impacter.dying then return end
    if (event.newObject.id == impacter.id and event.existingObject.types.solid) then
      -- I am bumping into something
      impacter:dispatchCollision(event.existingObject, 0.5 / speed)
    end
    if (event.existingObject.id == impacter.id and event.newObject.types.solid) then
      -- something else bumped into me
      impacter:dispatchCollision(event.newObject, 0)
    end    
  end)
  
  impacter.dispatcher:listen("room.objectMapEdgeCollision", function(event)
    if event.object.id == impacter.id then
      local removeEvent = {
        name = "object.remove",
        object = impacter
      }
      impacter.dispatcher:dispatch(removeEvent)      
    end
  end)
  
  return impacter
end