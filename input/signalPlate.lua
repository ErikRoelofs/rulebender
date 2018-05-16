return function(objectFactory, id, directions)
  local block = objectFactory(id)
    :thatIsAnInput(directions)    
    :thatCanBeDrawn(function(self) 
      love.graphics.print("plate", 5, 20) 
    end)
    :go()
  
  block.dispatcher:listen("object.collision", function(event)
    if event.existingObject.id == block.id then
      local event = {
        name = "signal",
        object = block,
        impactSignal = true
      }
      block.dispatcher:dispatchDelayed(event, 0.5)      
    end
  end)

  return block
end