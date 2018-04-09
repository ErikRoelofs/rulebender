return function (dispatcher, width, height) 
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
      room.tiles[i][j] = {}
      j = j + 1
    end
    i = i + 1
  end

  room.placeObject = function(self, x, y, object)
    assert( x < self.width and y < self.height and x >= 0 and y >= 0, "Cannot place object; out of bounds." )
    
    table.insert(self.tiles[x][y], object)
    self.objects[object] = {x = x, y = y}
    
    self:dispatchToAdjacentSquares(x, y, object, "room.objectsNowAdjacent")
  end
  
  room.findObjectLocation = function(self, object)
    return self.objects[object].x, self.objects[object].y
  end
  
  room.removeObject = function(self, object)
    local x = self.objects[object].x
    local y = self.objects[object].y
    
    for key, obj in ipairs(self.tiles[x][y]) do
      if obj == object then
        table.remove(self.tiles[x][y], key)
      end
    end
    
    self:dispatchToAdjacentSquares(x, y, object, "room.objectsNoLongerAdjacent")
  end
  
  room.moveObject = function (self, object, direction)
    local x,y = self:findObjectLocation(object)
    room:removeObject(object)
    if direction == "right" then
      room:placeObject(x + 1, y, object)
    elseif direction == "left" then
      room:placeObject(x - 1, y, object)
    elseif direction == "up" then
      room:placeObject(x, y + 1, object)
    elseif direction == "down" then
      room:placeObject(x, y - 1, object)
    end
  end
  
  room.dispatchToAdjacentSquares = function(self, x, y, object, name)
    self:dispatchAdjacencyEvent(x-1, y, object, name)
    self:dispatchAdjacencyEvent(x+1, y, object, name)
    self:dispatchAdjacencyEvent(x, y-1, object, name)
    self:dispatchAdjacencyEvent(x, y+1, object, name)
  end
  
  room.dispatchAdjacencyEvent = function(self, x, y, adjacentObject, eventName, direction)
    if x < 0 or x >= self.width or y < 0 or y >= self.height then return end
    for _, object in ipairs(self.tiles[x][y]) do
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
        --love.graphics.print(i .. ", " .. j, i * 50, j * 50 )
        love.graphics.rectangle("line", i * 50, j * 50, 50, 50)
        love.graphics.push()
        love.graphics.translate(i * 50, j * 50)
        for _, obj in ipairs(self.tiles[i][j]) do
          obj:draw()
        end
        love.graphics.pop()
        j = j + 1
      end
      i = i + 1
    end
  end

  return room
end