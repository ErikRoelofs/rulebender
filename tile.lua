return function(dispatcher)
  local tile = {
    content = {},
    dispatcher = dispatcher,
    movingObjects = {},
    dashingObjects = {}
  }
  
  tile.canAddObject = function(self, objectToPlace)
    if objectToPlace.state == "solid" then
      for _, existingObject in ipairs(self.content) do
        if existingObject.state == "solid" then
          return false
        end
      end
    end
    return true
  end
  
  tile.canAddMovingObject = function(self, objectToPlace, direction, speed)
    if objectToPlace.state == "solid" then
      self:pushContents(direction, speed)
    end
    return tile:canAddObject(objectToPlace)
  end

  tile.pushContents = function(self, direction, speed)
    for _, existingObject in ipairs(self.content) do
      if existingObject.state == "solid" then
        local event = {
          name = "object.pushed",
          object = existingObject,
          direction = direction,
          speed = speed
        }
        self.dispatcher:dispatch(event)
      end
    end    
  end
  
  tile.signalContents = function(self, direction)
    for _, existingObject in ipairs(self.content) do
      local event = {
        name = "object.triggered",
        object = existingObject,
        direction = direction
      }
      self.dispatcher:dispatchDelayed(event, 0)      
    end
  end

  tile.findBlockingObject = function(self, object)
    for _, obj in ipairs(self.content) do
      if obj.state == "solid" then
        return obj
      end
    end 
  end
  
  tile.addObject = function(self, object)
    if not self:canAddObject(object) then return end
    table.insert(self.content, object)
    for _, existingObject in ipairs(self.content) do
      if object.id ~= existingObject.id then
        local event = {
          name = "object.collision",
          existingObject = existingObject,
          newObject = object
        }
        dispatcher:dispatch(event)
      end
    end
    return true
  end
  
  tile.addMovingObject = function(self, object, direction, speed, dashing)
    if tile:addObject(object) then
      self.movingObjects[object.id] = {time = 1 / speed, maxTime = 1 / speed, direction = direction, speed = speed, object = object}
      if dashing then self.dashingObjects[object.id] = true end
      local event = {
        name = "object.moving",
        object = object,
        dashing = dashing
      }
      tile.dispatcher:dispatch(event)
      return true
    end
  end

  tile.removeObject = function(self, object)
    for key, obj in ipairs(self.content) do
      if obj.id == object.id then
        table.remove(self.content, key)
        return
      end
    end
    error "object not in tile?"
  end
  
  tile.draw = function(self)
    for _, obj in ipairs(self.content) do
      love.graphics.push()
      if self.movingObjects[obj.id] then
        self.translateForMovement(self.movingObjects[obj.id].time, self.movingObjects[obj.id].maxTime, self.movingObjects[obj.id].direction)
      end
      obj:draw()
      love.graphics.pop()
    end
  end
  
  tile.translateForMovement = function(time, maxTime, direction)
    if direction == "right" then
      love.graphics.translate(-CONST.TILE_WIDTH * (time/maxTime), 0)
    elseif direction == "left" then
      love.graphics.translate(CONST.TILE_WIDTH * (time/maxTime), 0)
    elseif direction == "up" then
      love.graphics.translate(0, CONST.TILE_HEIGHT * (time/maxTime))
    elseif direction == "down" then
      love.graphics.translate(0, -CONST.TILE_HEIGHT * (time/maxTime))
    end
  end
  
  tile.getContents = function(self)
    return self.content
  end
  
  tile.dispatchToContent = function(self, event)
    for _, obj in ipairs(self.content) do
      self.dispatcher:dispatch(event)
    end
  end
  
  tile.dispatcher:listen("time.passes", function(event)
    local remove = {}
    for id, vector in pairs(tile.movingObjects) do
      vector.time = vector.time - math.min(vector.time, event.value)
      if vector.time == 0 then
        remove[id] = vector.object
      end
    end
    for id, obj in pairs(remove) do
      local direction = tile.movingObjects[id].direction
      local speed = tile.movingObjects[id].speed
      tile.movingObjects[id] = nil
      local event = {
        name = "object.arrived",
        object = obj
      }      
      tile.dispatcher:dispatch(event)
      if tile.dashingObjects[id] then
        tile.dashingObjects[id] = nil
        local moveEvent = {
          name = "move",
          object = obj,
          direction = direction,
          speed = speed,
          dashing = true
        }
        tile.dispatcher:dispatch(moveEvent)
      end
    end
  end)
  
  return tile
end