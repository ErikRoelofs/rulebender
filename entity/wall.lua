return function(objectFactory, id)
  
  local wall = objectFactory(id)
    :thatIsSolid()
    :thatCanBeDrawn(function(self)
      love.graphics.setColor(1,0,0,1)
      love.graphics.rectangle("fill", 2, 2, CONST.TILE_WIDTH - 4, CONST.TILE_HEIGHT - 4)
      love.graphics.setColor(1,1,1,1)
    end)
    :go()
  
  return wall
end