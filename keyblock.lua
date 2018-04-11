return function(objectFactory, key)
  local block = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput()
    :thatCanBeDrawn(function(self) 
      love.graphics.print("key: " .. self.key, 5, 20) 
      self:drawActiveMark()
    end)
    :go()
  
  block.key = key
  block.dispatcher:listen("keypressed", function(event)
    if event.key == block.key then
      newEvent = {
        name = "inputblock.pulse",
        value = block
      }
      block.dispatcher:dispatch(newEvent)
      block:activate()
    end
  end)

  return block
end