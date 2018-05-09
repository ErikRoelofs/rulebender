return function(objectFactory, id)
  
  local wall = objectFactory(id)
    :thatIsSolid()
    :thatCanBePushed()
    :thatCanBeDrawn(function(self)
      love.graphics.setColor(0.8,0.5,0.5,1)
      love.graphics.rectangle("fill", 2, 2, CONST.TILE_WIDTH - 4, CONST.TILE_HEIGHT - 4)
      love.graphics.setColor(1,1,1,1)
    end)
    :go()
  
  return wall
end