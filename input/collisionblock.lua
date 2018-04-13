return function(objectFactory, collisionType)
  local block = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput()
    :thatCanBeDrawn(function(self)
     
      love.graphics.print("collide", 5, 20) 
      
    end)
    :go()
  
  block.dispatcher:listen("room.objectsCollided", function(event)
    if event.objectA:hasType(collisionType) or event.objectB:hasType(collisionType) then
      block:pulse()
    end
  end)

  return block
end