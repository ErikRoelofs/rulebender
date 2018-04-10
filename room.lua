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
    assert( x < self.width and y < self.height and x >= 0 and y >= 0, "Cannot place object; out of bounds." )
    
    self.tiles[x][y]:addObject(object)
    self.objects[object] = {x = x, y = y}
    
    self:dispatchToAdjacentSquares(x, y, object, "room.objectsNowAdjacent")
  end
  
  room._findObjectLocation = function(self, object)
    return self.objects[object].x, self.objects[object].y
  end
  
  dispatcher:listen("move", function(event)
    if room.objects[event.object] then
      room:moveObject(event.object, event.direction)
    end
  end)
  
  room.removeObject = function(self, object)
    local x, y = self:_findObjectLocation(object)
    self.tiles[x][y]:removeObject(object)
    self:dispatchToAdjacentSquares(x, y, object, "room.objectsNoLongerAdjacent")
  end
  
  room.moveObject = function (self, object, direction)
    local x,y = self:_findObjectLocation(object)
    
    if direction == "right" then
      self:tryMoveTo(x+1,y,object, direction)
    elseif direction == "left" then
      self:tryMoveTo(x-1,y,object, direction)
    elseif direction == "up" then
      self:tryMoveTo(x,y-1,object, direction)
    elseif direction == "down" then
      self:tryMoveTo(x,y+1,object, direction)
    end
  end
  
  room.tryMoveTo = function(self, x, y, object, direction)
      if self:canMoveTo(x, y, object, direction) then
        self:removeObject(object)
        self:placeObject(x, y, object)
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
  
  room.canMoveTo = function(self, x, y, object, direction)
    if x < 0 or x >= self.width or y < 0 or y >= self.height then
      return false
    end
    return self.tiles[x][y]:canAddMovingObject(object, direction)
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
        love.graphics.rectangle("line", i * 50, j * 50, 50, 50)
        love.graphics.push()
        love.graphics.translate(i * 50, j * 50)
        self.tiles[i][j]:draw()
        love.graphics.pop()
        j = j + 1
      end
      i = i + 1
    end
  end

  return room
end