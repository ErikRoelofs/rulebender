return function(objectFactory, id, inputDirections, triggerDirections)
  local block = objectFactory(id)
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
      block:pulse(inverseDirection(event.direction))
      block:activate(false, true)
    end
  end)

  return block
end