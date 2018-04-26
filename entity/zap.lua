return function(objectFactory, direction)
  
  local zap = objectFactory()
    :thatCanBeDrawn(function(self)
      love.graphics.setColor(0,1,1,1)
      love.graphics.print("ZAP!", 25, 25)
      love.graphics.setColor(1,1,1,1)
    end)
    :go()
  
  zap.dispatcher:listen("object.collision", function(event)
    if event.existingObject == zap or event.newObject == zap then
      local event = {
        name = "signal",
        object = zap,
        direction = direction,
        impactSignal = true
      }
      zap.dispatcher:dispatch(event)
      
      local removeEvent = {
        name = "object.remove",
        object = zap
      }
      zap.dispatcher:dispatch(removeEvent)      
    end
  end)
  
  zap.dispatcher:listen("room.objectMapEdgeCollision", function(event)
    if event.object == zap then
      local removeEvent = {
        name = "object.remove",
        object = zap
      }
      zap.dispatcher:dispatch(removeEvent)      
    end
  end)
  
  return zap
end