return function(objectFactory, cooldown)
  local block = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatCanBeDrawn(function(self) 
      love.graphics.print("pulser", 0, 20) 
      if self.active > 0 then
        love.graphics.setColor(0,1,0,self.active / self.maxActive)
        love.graphics.circle("fill", 5,5,5)
        love.graphics.setColor(1,1,1,1)
      end
    end)
    :go()
  
  block.maxCooldown = cooldown
  block.cooldown = block.maxCooldown
  
  block.active = 0
  block.maxActive = 0.5
  
  block.dispatcher:listen("time.passes", function(event)
    if block.active > 0 then
      block.active = block.active - math.min(event.value, block.active)
    end
    block.cooldown = block.cooldown - event.value
    if block.cooldown < 0 then
      block.cooldown = block.maxCooldown
      block.dispatcher:dispatch({name = "inputblock.pulse", value=block})
      block.active = block.maxActive
    end
  end)
  
  return block
end