return function(objectFactory, id, direction, speed)
  
  local pull = objectFactory(id)
    :thatCanBeDrawn(function(self)
      love.graphics.setColor(0,1,1,1)
      love.graphics.print("pull!", 25, 25)
      love.graphics.setColor(1,1,1,1)
    end)
    :go()
  
  pull.dispatcher:listen("object.collision", function(event)
    if event.existingObject.id == pull.id or event.newObject.id == pull.id then
      local hitObject
      if event.existingObject.id == pull.id then
        hitObject = event.newObject
      else
        hitObject = event.existingObject
      end
      if not hitObject.types.solid then return end
      
      local event = {
        name = "object.pushed",
        object = hitObject,
        direction = inverseDirection(direction),
        speed = 1
      }
      pull.dispatcher:dispatchDelayed(event, 1 / speed + 0.05)
      
      local removeEvent = {
        name = "object.remove",
        object = pull
      }
      pull.dispatcher:dispatchDelayed(removeEvent, 1 / speed)
    end
  end)
  
  pull.dispatcher:listen("room.objectMapEdgeCollision", function(event)
    if event.object.id == pull.id then
      local removeEvent = {
        name = "object.remove",
        object = pull
      }
      pull.dispatcher:dispatch(removeEvent)      
    end
  end)
  
  return pull
end