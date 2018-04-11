return function(objectFactory, key)
  local block = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatCanBeDrawn(function(self) 
      love.graphics.print("key: " .. self.key, 0, 20) 
      if self.active > 0 then
        love.graphics.setColor(0,1,0,self.active / self.maxActive)
        love.graphics.circle("fill", 5,5,5)
        love.graphics.setColor(1,1,1,1)
      end
    end)
    :go()
  
  block.key = key
  block.active = 0
  block.maxActive = 0.5
  block.dispatcher:listen("keypressed", function(event)
    if event.key == block.key then
      newEvent = {
        name = "inputblock.pulse",
        value = block
      }
      block.dispatcher:dispatch(newEvent)
      block.active = block.maxActive
    end
  end)

  block.dispatcher:listen("time.passes", function(event)
    if block.active > 0 then
      block.active = block.active - math.min(event.value, block.active)
    end
  end)
  
  return block
end