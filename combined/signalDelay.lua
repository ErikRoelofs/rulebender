return function(objectFactory, id, inputDirections, triggerDirections, delay)
  local block = objectFactory(id)
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput(directions)    
    :thatIsATrigger(directions)
    :thatCanBeDrawn(function(self) 
      love.graphics.print("delay", 5, 20) 
      self:drawActiveMark()
    end)
    :go()
  
    dispatcher:listen("object.triggered", function(event)
    if event.object == block and block.triggerDirections[inverseDirection(event.direction)] then
      block:delayedPulse(delay, inverseDirection(event.direction))
      block:activate(false, true)
    end
  end)

  return block
end