return function(objectFactory, id, inputDirections, triggerDirections)
  local block = objectFactory(id)
    :thatIsSolid()
    :thatCanBePushed()
    :thatIsAnInput(inputDirections)    
    :thatIsATrigger(triggerDirections)
    :thatCanBeDrawn(function(self) 
      --love.graphics.print("wire", 5, 20) 
      love.graphics.setColor(1,0,0)
      love.graphics.circle("fill", CONST.TILE_WIDTH / 2, CONST.TILE_HEIGHT / 2, 8)
      if self.inputDirections.up or self.triggerDirections.up then
          love.graphics.rectangle("fill", CONST.TILE_WIDTH / 2 - 2, CONST.TILE_HEIGHT / 2 - 2, 4, CONST.TILE_HEIGHT / 2)
      end
      if self.inputDirections.down or self.triggerDirections.down then
          love.graphics.rectangle("fill", CONST.TILE_WIDTH / 2 - 2, CONST.TILE_HEIGHT / 2 + 2, 4, -CONST.TILE_HEIGHT / 2)
      end
      if self.inputDirections.left or self.triggerDirections.left then
          love.graphics.rectangle("fill", CONST.TILE_WIDTH / 2 - 2, CONST.TILE_HEIGHT / 2 - 2,  -CONST.TILE_WIDTH / 2 , 4)
      end
      if self.inputDirections.right or self.triggerDirections.right then
          love.graphics.rectangle("fill", CONST.TILE_WIDTH / 2 - 2, CONST.TILE_HEIGHT / 2 - 2,  CONST.TILE_WIDTH / 2 , 4)
      end
        
      love.graphics.setColor(1,1,1)
      self:drawActiveMark()
    end)
    :go()
  
    dispatcher:listen("object.triggered", function(event)
    if event.object.id == block.id and block.triggerDirections[inverseDirection(event.direction)] then
      if block.moving then return end
      block:pulse(inverseDirection(event.direction))
      block:activate(false, true)
    end
  end)

  return block
end