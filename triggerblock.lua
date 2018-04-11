return function(objectFactory, dispatcher, effect)
    
  local block = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatCanBeDrawn(function(self) 
      love.graphics.print("trigger", 0, 20) 
      if self.active > 0 then
        love.graphics.setColor(0,0,1,self.active / self.maxActive)
        love.graphics.circle("fill", 5,5,5)
        love.graphics.setColor(1,1,1,1)
      end

    end)
    :go()

  block.effect = effect
  block.respondsTo = {}
  block.active = 0
  block.maxActive = 0.5

  dispatcher:listen("inputblock.pulse", function(event)
    for _, innerBlock in ipairs(block.respondsTo) do
      if innerBlock == event.value then
        block.effect()
        block.active = block.maxActive
      end
    end
  end)
  
  dispatcher:listen("room.objectsNowAdjacent", function(event)
    if event.objectA == block then
      block:respondTo(event.objectB)
    end
    if event.objectB == block then
      block:respondTo(event.objectA)
    end
  end)
  
  dispatcher:listen("room.objectsNoLongerAdjacent", function(event)
    if event.objectA == block then
      block:stopRespondingTo(event.objectB)
    end
    if event.objectB == block then
      block:stopRespondingTo(event.objectA)
    end
  end)
  
  block.respondTo = function(self, inputblock)
    table.insert(self.respondsTo, inputblock)
  end
  
  dispatcher:listen("time.passes", function(event)
    if block.active > 0 then
      block.active = block.active - math.min(event.value, block.active)
    end
  end)

  block.stopRespondingTo = function(self, inputblock)
    for key, innerblock in ipairs(self.respondsTo) do
      if innerblock == inputblock then
        table.remove(self.respondsTo, key)
      end
    end
  end
  
  return block
end