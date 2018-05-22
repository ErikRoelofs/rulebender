return function(objectFactory, id, direction, speed)
  
  local zap = objectFactory(id)
    :thatCanBeDrawn(function(self)
      love.graphics.setColor(0,1,1,1)
      love.graphics.print("ZAP!", 25, 25)
      love.graphics.setColor(1,1,1,1)
    end)
    :go()
  
  zap.dispatcher:listen("object.collision", function(event)
    if event.existingObject.id == zap.id or event.newObject.id == zap.id then
      local event = {
        name = "signal",
        object = zap,
        direction = direction,
        impactSignal = true
      }
      zap.dispatcher:dispatchDelayed(event, 0.5 / speed)
      
      local removeEvent = {
        name = "object.remove",
        object = zap
      }
      zap.dispatcher:dispatchDelayed(removeEvent, 0.5 / speed)
    end
  end)
  
  zap.dispatcher:listen("room.objectMapEdgeCollision", function(event)
    if event.object.id == zap.id then
      local removeEvent = {
        name = "object.remove",
        object = zap
      }
      zap.dispatcher:dispatch(removeEvent)      
    end
  end)
  
  return zap
end