return function (dispatcher, width, height) 
  
  local tileFactory = require("tile")
  
  local room = {
    width = width,
    height = height,
    tiles = {},
    objects = {},
    dispatcher = dispatcher
  }
  
  local i, j = 0, 0
  while i < width do
    room.tiles[i] = {}
    j = 0
    while j < height do
      room.tiles[i][j] = tileFactory(dispatcher)
      j = j + 1
    end
    i = i + 1
  end

  room.placeObject = function(self, x, y, object)
    return self:placeMovingObject(x, y, object)
  end
  
  room.placeMovingObject = function(self, x, y, object, direction, speed)
    assert( x < self.width and y < self.height and x >= 0 and y >= 0, "Cannot place object; out of bounds." )
    
    local added
    if direction then
      added = self.tiles[x][y]:addMovingObject(object, direction, speed)
    else
      added = self.tiles[x][y]:addObject(object)
    end
    if added then
      self.objects[object] = {x = x, y = y}
      self:dispatchToAdjacentSquares(x, y, object, "room.objectsNowAdjacent")
    end
    return added
  end

  room._findObjectLocation = function(self, object)
    return self.objects[object].x, self.objects[object].y
  end
  
  dispatcher:listen("move", function(event)
    if room.objects[event.object] then
      room:moveObject(event.object, event.direction, event.speed)
    end
  end)
  
  dispatcher:listen("object.replace", function(event)
    if room.objects[event.existingObject] then      
      local x, y = room:_findObjectLocation(event.existingObject)
      room:removeObject(event.existingObject)
      local success = room:placeObject(x, y, event.newObject)
      if not success then
        room:placeObject(x,y,event.existingObject)
      end
    end
  end)
  
  room.removeObject = function(self, object)
    local x, y = self:_findObjectLocation(object)
    self.tiles[x][y]:removeObject(object)
    self.objects[object] = nil
    self:dispatchToAdjacentSquares(x, y, object, "room.objectsNoLongerAdjacent")
  end
  
  room.moveObject = function (self, object, direction, speed)
    local x,y = self:_findObjectLocation(object)
    
    if direction == "right" then
      self:tryMoveTo(x+1,y,object, direction, speed)
    elseif direction == "left" then
      self:tryMoveTo(x-1,y,object, direction, speed)
    elseif direction == "up" then
      self:tryMoveTo(x,y-1,object, direction, speed)
    elseif direction == "down" then
      self:tryMoveTo(x,y+1,object, direction, speed)
    end
  end
  
  room.tryMoveTo = function(self, x, y, object, direction, speed)
      if self:canMoveTo(x, y, object, direction, speed) then
        self:removeObject(object)
        self:placeMovingObject(x, y, object, direction, speed)
      else
        local blocking = self:getBlockingObject(x, y, object)
        if blocking then
          local event = {
            name = "room.objectsCollided",
            objectA = object,
            objectB = blocking
          }
          self.dispatcher:dispatch(event)
        end
      end
  end
  
  room.getBlockingObject = function(self, x, y, object)
    if x < 0 or x >= self.width or y < 0 or y >= self.height then
      return nil
    end
    return self.tiles[x][y]:findBlockingObject(object)
  end
  
  room.canMoveTo = function(self, x, y, object, direction, speed)
    if x < 0 or x >= self.width or y < 0 or y >= self.height then
      return false
    end
    return self.tiles[x][y]:canAddMovingObject(object, direction, speed)
  end
  
  room.dispatchToAdjacentSquares = function(self, x, y, object, name)
    self:dispatchAdjacencyEvent(x-1, y, object, name)
    self:dispatchAdjacencyEvent(x+1, y, object, name)
    self:dispatchAdjacencyEvent(x, y-1, object, name)
    self:dispatchAdjacencyEvent(x, y+1, object, name)
  end
  
  room.dispatchAdjacencyEvent = function(self, x, y, adjacentObject, eventName, direction)
    if x < 0 or x >= self.width or y < 0 or y >= self.height then return end
    for _, object in ipairs(self.tiles[x][y]:getContents()) do
      local event = {
        name = eventName,
        objectA = object,
        objectB = adjacentObject
      }
      self.dispatcher:dispatch(event)
    end
  end
  
  room.draw = function(self)
    local i, j = 0, 0
    while i < self.width do
      j = 0
      while j < self.height do
        love.graphics.setColor(0.8, 0.2, 0.2, 0.4)
        love.graphics.rectangle("line", i * CONST.TILE_WIDTH, j * CONST.TILE_HEIGHT, CONST.TILE_WIDTH, CONST.TILE_HEIGHT)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.push()
        love.graphics.translate(i * CONST.TILE_WIDTH, j * CONST.TILE_HEIGHT)
        self.tiles[i][j]:draw()
        love.graphics.pop()
        j = j + 1
      end
      i = i + 1
    end
  end
  
  return room
end