return function(objectFactory, id, delay, directions)
  local block = objectFactory(id)
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput(directions)
    :thatCanBeDrawn(function(self) 
      love.graphics.print("motion sensor", 5, 20) 
    end)
    :go()
  
  block.delaying = 0
  block.dispatcher:listen("object.arrived", function(event)
    if event.object.id == block.id then
      block.delaying = delay
    end
  end)

  dispatcher:listen("room.objectsNowAdjacent", function(event)
    if event.objectA.id == block.id or event.objectB.id == block.id then
      block.delaying = delay
    end
  end)
  
  dispatcher:listen("room.objectsNoLongerAdjacent", function(event)
    if event.objectA.id == block.id or event.objectB.id == block.id then
      block.delaying = delay
    end
  end)

  block.dispatcher:listen("time.passes", function(event)
    if block.delaying > 0 then
      block.delaying = block.delaying - event.value
      if block.delaying <= 0 then
        block:pulse()
      end
    end
  end)

  return block
end