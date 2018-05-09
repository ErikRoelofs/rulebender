return function(objectFactory, id, cooldown, directions)
  local block = objectFactory(id)
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput(directions)
    :thatCanBeDrawn(function(self)
      love.graphics.print("pulser", 5, 25)
      love.graphics.setColor(0,0,1,1)
      love.graphics.rectangle("fill", 4, 10, self.cooldown / self.maxCooldown * 40, 10 )
    end)
    :go()
  
  block.maxCooldown = cooldown
  block.cooldown = block.maxCooldown
  
  block.dispatcher:listen("time.passes", function(event)
    block.cooldown = block.cooldown - event.value
    if block.cooldown < 0 then
      block.cooldown = block.maxCooldown
      block:pulse()
    end
  end)
  
  return block
end