return function(objectFactory, dispatcher, effect, draweffect, directions)
    
  local block = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsATrigger(directions)
    :thatCanBeDrawn(function(self)     
      self:draweffect()
      self:drawActiveMark()
    end)
    :go()

  block.effect = effect(block)
  block.draweffect = draweffect

  dispatcher:listen("object.triggered", function(event)
    if event.object == block and block.triggerDirections[inverseDirection(event.direction)] then
      block.effect()
      block:activate()
    end
  end)
  
  return block
end