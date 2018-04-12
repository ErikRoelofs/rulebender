return function(objectFactory)
  
  local wall = objectFactory()
    :thatIsSolid()
    :thatCanBeDrawn(function(self)
      love.graphics.setColor(1,0,0,1)
      love.graphics.rectangle("fill", 2, 2, 46, 46)
      love.graphics.setColor(1,1,1,1)
    end)
    :go()
  
  return wall
end