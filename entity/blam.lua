return function(objectFactory, id, direction)
  
  local blam = objectFactory(id)
    :thatCanBeDrawn(function(self)
      love.graphics.setColor(0,1,1,1)
      love.graphics.print("blam!", 25, 25)
      love.graphics.setColor(1,1,1,1)
    end)
    :go()
  
  blam.dispatcher:listen("object.collision", function(event)
    if event.existingObject.id == blam.id or event.newObject.id == blam.id then
      local hitObject
      if event.existingObject.id == blam.id then
        hitObject = event.newObject
      else
        hitObject = event.existingObject
      end
      if not hitObject.types.solid then return end
      
      local event = {
        name = "object.pushed",
        object = hitObject,
        direction = direction,
        speed = 2
      }
      blam.dispatcher:dispatchDelayed(event, 0.5)
      
      local removeEvent = {
        name = "object.remove",
        object = blam
      }
      blam.dispatcher:dispatchDelayed(removeEvent, 0.5)
    end
  end)
  
  blam.dispatcher:listen("room.objectMapEdgeCollision", function(event)
    if event.object.id == blam.id then
      local removeEvent = {
        name = "object.remove",
        object = blam
      }
      blam.dispatcher:dispatch(removeEvent)      
    end
  end)
  
  return blam
end