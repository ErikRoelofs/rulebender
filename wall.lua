return function(objectFactory)
  
  local wall = objectFactory()
    :thatIsSolid()
    :thatCanBeDrawn(function(self)
      love.graphics.print("wall", 0, 20)
    end)
    :go()
  
  return wall
end