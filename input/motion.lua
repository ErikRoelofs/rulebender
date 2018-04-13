return function(objectFactory, delay)
  local block = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput()
    :thatCanBeDrawn(function(self) 
      love.graphics.print("motion sensor", 5, 20) 
      self:drawActiveMark()
    end)
    :go()
  
  block.delaying = 0
  block.dispatcher:listen("object.arrived", function(event)
    if event.object == block then
      block.delaying = delay
    end
  end)

  dispatcher:listen("room.objectsNowAdjacent", function(event)
    if event.objectA == block or event.objectB == block then
      block.delaying = delay
    end
  end)
  
  dispatcher:listen("room.objectsNoLongerAdjacent", function(event)
    if event.objectA == block or event.objectB == block then
      block.delaying = delay
    end
  end)

  block.dispatcher:listen("time.passes", function(event)
    if block.delaying > 0 then
      block.delaying = block.delaying - event.value
      if block.delaying <= 0 then
        newEvent = {
          name = "inputblock.pulse",
          value = block
        }
        block.dispatcher:dispatch(newEvent)
        block:activate()
      end
    end
  end)

  return block
end