return function (dispatcher, width, height, which) 
  local tileFactory = require("tile")
  
  local room = {
    width = width,
    height = height,
    tiles = {},
    objects = {},
    dispatcher = dispatcher,
    activated = {},
    directions = CONST.DIRECTIONS(),
    which = which
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
  
  room.placeMovingObject = function(self, x, y, object, direction, speed, dashing)
    assert( self:withinBounds(x,y), "Cannot place object; out of bounds." )
    
    local added
    local originalLocation = nil
    if self.objects[object.id] then
      originalLocation = self:_findObjectLocation(object)
    end
    self.objects[object.id] = {x = x, y = y, object = object}
    if direction then
      added = self.tiles[x][y]:addMovingObject(object, direction, speed, dashing)
    else
      added = self.tiles[x][y]:addObject(object)
    end
    if added then
      self:dispatchToAdjacentSquares(x, y, object, "room.objectsNowAdjacent")
    else
      self.objects[object.id] = originalLocation
    end
    return added
  end

  room._findObjectLocation = function(self, object)
    return self.objects[object.id].x, self.objects[object.id].y
  end
  
  dispatcher:listen("create.adjacent.moving", function(event)
    if room.objects[event.existingObject.id] then
      local x, y = room:_findObjectLocation(event.existingObject)
      x, y = morphCoordinates(event.direction, x, y)
      room:placeMovingObject(x,y, event.newObject, event.direction, event.speed, event.dashing)
    end
  end)
  
  dispatcher:listen("move", function(event)
    if room.objects[event.object.id] then
      room:moveObject(room.objects[event.object.id].object, event.direction, event.speed, event.dashing)
    end
  end)
 
  dispatcher:listen("push", function(event)
    if room.objects[event.object.id] then
      local x, y = room:_findObjectLocation(event.object)
      x, y = morphCoordinates(event.direction, x, y)
      room:_pushIntoTile(x,y,event.direction, event.speed)      
    end
  end)
  
  room._pushIntoTile = function (self, x, y, direction, speed)
    if not self:withinBounds(x,y) then return end
    room.tiles[x][y]:pushContents(direction, speed)
  end
    
  dispatcher:listen("signal", function(event)
    if room.objects[event.object.id] then
      room:applySignal(room.objects[event.object.id].object, event.direction, event.impactSignal)
    end
  end)

  room.applySignal = function(self, object, direction, impactSignal)
    if room.objects[object.id] then
      local x, y = room:_findObjectLocation(object)
      if not impactSignal then
        x, y = morphCoordinates(direction, x, y)
      end
      room:_applySignalInDirection(x,y,direction)    
    end
  end
  
  room._applySignalInDirection = function(self, x, y, direction)
    if not self:withinBounds(x,y) then return end
    if room.activated[room.tiles[x][y]] then return end
    room.activated[room.tiles[x][y]] = true
    room.tiles[x][y]:signalContents(direction)
  end
  
  dispatcher:listen("object.replace", function(event)
    if room.objects[event.existingObject.id] then      
      local x, y = room:_findObjectLocation(event.existingObject)
      room:removeObject(event.existingObject)
      local success = room:placeObject(x, y, event.newObject)
      if not success then
        room:placeObject(x,y,event.existingObject)
      end
    end
  end)
  
  dispatcher:listen("object.remove", function(event)
    if room.objects[event.object.id] then      
      local x, y = room:_findObjectLocation(event.object)
      room:removeObject(event.object)
    end
  end)

  dispatcher:listen("time.passes", function(event)
    room.activated = {}
  end)
  
  room.removeObject = function(self, object)
    local x, y = self:_findObjectLocation(object)
    self:dispatchToAdjacentSquares(x, y, object, "room.objectsNoLongerAdjacent")
    self.tiles[x][y]:removeObject(object)
    self.objects[object.id] = nil
  end
  
  room.moveObject = function (self, object, direction, speed, dashing)
    if self.objects[object.id] then
      local x, y = room:_findObjectLocation(object)
      x, y = morphCoordinates(direction, x, y)
      self:tryMoveTo(x,y,object, direction, speed, dashing)
    end
  end
  
  room.tryMoveTo = function(self, x, y, object, direction, speed, dashing)
      if self:canMoveTo(x, y, object, direction, speed) then
        self:removeObject(object)
        self:placeMovingObject(x, y, object, direction, speed, dashing)
      else
        local blocking = self:getBlockingObject(x, y, object)
        if blocking then
          local event = {
            name = "room.objectsCollided",
            objectA = object,
            objectB = blocking
          }
          self.dispatcher:dispatch(event)
          return
        end
        if not self:withinBounds(x,y) then
          local event = {
            name = "room.objectMapEdgeCollision",
            object = object            
          }
          self.dispatcher:dispatch(event)          
        end
      end
  end
  
  room.withinBounds = function(self, x,y)
    if x < 0 or x >= self.width or y < 0 or y >= self.height then
      return false
    end
    return true
  end
  
  room.getBlockingObject = function(self, x, y, object)
    if not self:withinBounds(x,y) then return end
    return self.tiles[x][y]:findBlockingObject(object)
  end
  
  room.canMoveTo = function(self, x, y, object, direction, speed)
    if not self:withinBounds(x,y) then return false end
    return self.tiles[x][y]:canAddMovingObject(object, direction, speed)
  end
  
  room.dispatchToAdjacentSquares = function(self, x, y, object, name)
    for direction in pairs(self.directions) do
      local nX, nY = morphCoordinates(direction, x, y)
      self:dispatchAdjacencyEvent(nX, nY, object, name, direction)
    end
  end
  
  room.dispatchAdjacencyEvent = function(self, x, y, adjacentObject, eventName, direction)
    if not self:withinBounds(x,y) then return end
    for _, object in ipairs(self.tiles[x][y]:getContents()) do      
      local event = {
        name = eventName,
        objectA = object,
        objectB = adjacentObject,
        newObject = adjacentObject,
        existingObject = object,
        direction = direction
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