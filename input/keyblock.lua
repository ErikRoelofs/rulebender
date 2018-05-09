return function(objectFactory, id, key, directions)
  local block = objectFactory(id)
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput(directions)    
    :thatCanBeDrawn(function(self) 
      love.graphics.print("key: " .. self.key, 5, 20) 
      self:drawActiveMark()
    end)
    :go()
  
  block.key = key
  block.dispatcher:listen("keypressed", function(event)
    if event.key == block.key then
      block:pulse()    
    end
  end)

  return block
end