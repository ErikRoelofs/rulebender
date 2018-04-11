return function(objectFactory, dispatcher, effect, draweffect)
    
  local block = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsATrigger()
    :thatCanBeDrawn(function(self)     
      self:draweffect()
      self:drawActiveMark()
    end)
    :go()

  block.effect = effect
  block.draweffect = draweffect
  block.respondsTo = {}

  dispatcher:listen("inputblock.pulse", function(event)
    for _, innerBlock in ipairs(block.respondsTo) do
      if innerBlock == event.value then
        block.effect()
        block:activate()
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
  
  block.stopRespondingTo = function(self, inputblock)
    for key, innerblock in ipairs(self.respondsTo) do
      if innerblock == inputblock then
        table.remove(self.respondsTo, key)
      end
    end
  end
  
  return block
end