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
  
    dispatcher:listen("object.triggered", function(event)
    if event.object == block and block.triggerDirections[inverseDirection(event.direction)] then
      block:pulse()
      block:activate()
    end
  end)

  return block
end