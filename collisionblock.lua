return function(objectFactory)
  local block = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput()
    :thatCanBeDrawn(function(self)
     
      love.graphics.print("collide", 5, 20) 
      
    end)
    :go()
  
  block.dispatcher:listen("room.objectsCollided", function(event)
    newEvent = {
      name = "inputblock.pulse",
      value = block
    }
    block.dispatcher:dispatch(newEvent)
    block:activate()
  end)

  return block
end