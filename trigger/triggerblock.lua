return function(objectFactory, id, dispatcher, effect, draweffect, directions, cooldown)
    
  local block = objectFactory(id)
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsATrigger(directions)
    :thatCanBeDrawn(function(self)     
      self:draweffect()
      self:drawActiveMark()
      if self.maxCooldown > 0 then
        if self.cooldown <= 0 then
          love.graphics.print("Ready!", 5,50)
        else
          local length = self.cooldown / self.maxCooldown * 60
          love.graphics.rectangle("fill", 5, 50, length, 5)          
        end
      end
    end)
    :go()

  block.effect = effect(block)
  block.draweffect = draweffect
  block.maxCooldown = cooldown or 0
  block.cooldown = 0

  dispatcher:listen("object.triggered", function(event)
    if block.cooldown <= 0 and event.object.id == block.id and (not event.direction or block.triggerDirections[inverseDirection(event.direction)]) then
      block.effect()
      block:activate(false, true)
      block.cooldown = block.maxCooldown
    end
  end)

  dispatcher:listen("time.passes", function(event)
    block.cooldown = block.cooldown - event.value
  end)
  
  return block
end