return function(objectFactory, id, directions)
  local block = objectFactory(id)
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput(directions)    
    :thatCanBeDrawn(function(self) 
      love.graphics.print("remote: " .. self.id, 5, 20) 
    end)
    :go()
  
  block.dispatcher:listen("remote.trigger", function(event)
    if event.id == block.id then
      block:pulse()    
    end
  end)

  return block
end