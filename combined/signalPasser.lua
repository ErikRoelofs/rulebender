return function(objectFactory, inputDirections, triggerDirections)
  local block = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput(directions)    
    :thatIsATrigger(directions)
    :thatCanBeDrawn(function(self) 
      love.graphics.print("wire", 5, 20) 
      self:drawActiveMark()
    end)
    :go()
  
  block.respondsTo = {}
  
  dispatcher:listen("inputblock.pulse", function(event)
    for _, innerBlock in ipairs(block.respondsTo) do
      if innerBlock == event.value then
        block:pulse()
        block:activate()
      end
    end
  end)
  
  dispatcher:listen("room.objectsNowAdjacent", function(event)    
    if event.newObject == block then
      if  event.existingObject:hasType("input") 
      and event.existingObject ~= block
      and event.existingObject.inputDirections[event.direction] 
      and event.newObject.triggerDirections[inverseDirection(event.direction)]
      then
        block:respondTo(event.existingObject)
      end
    end
    if event.existingObject == block then
      if  event.newObject:hasType("input") 
      and event.newObject ~= block
      and event.newObject.inputDirections[inverseDirection(event.direction)] 
      and event.existingObject.triggerDirections[event.direction]
      then
        block:respondTo(event.newObject)
      end
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