return function(dispatcher)
  local tile = {
    content = {},
    dispatcher = dispatcher,
    movingObjects = {}
  }
  
  tile.canAddObject = function(self, object)
    for _, obj in ipairs(self.content) do
      if obj.state == "solid" then
        return false
      end
    end
    return true
  end
  
  tile.canAddMovingObject = function(self, object, direction, speed)
    for _, obj in ipairs(self.content) do
      if obj.state == "solid" then
        local event = {
          name = "object.pushed",
          object = obj,
          direction = direction,
          speed = speed
        }
        self.dispatcher:dispatch(event)
      end
    end
    
    for _, obj in ipairs(self.content) do
      if obj.state == "solid" then
        return false
      end
    end
    
    return true
  end

  tile.findBlockingObject = function(self, object)
    for _, obj in ipairs(self.content) do
      if obj.state == "impassable" then
        return obj
      end
    end 
  end
  
  tile.addObject = function(self, object)
    if not self:canAddObject(object) then return end
    table.insert(self.content, object)
  end
  
  tile.addMovingObject = function(self, object, direction, speed)
    if not self:canAddObject(object) then return end
    table.insert(self.content, object)
    self.movingObjects[object] = {time = 1 / speed, direction = direction}
  end

  tile.removeObject = function(self, object)
    for key, obj in ipairs(self.content) do
      if obj == object then
        table.remove(self.content, key)
      end
    end
  end
  
  tile.draw = function(self)
    for _, obj in ipairs(self.content) do
      obj:draw()
      if self.movingObjects[obj] then
        love.graphics.print(self.movingObjects[obj].time, 0, 0)
      end
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
    for obj, vector in pairs(tile.movingObjects) do
      vector.time = vector.time - math.min(vector.time, event.value)
      if vector.time == 0 then
        table.insert(remove, obj)
      end
    end
    for _, obj in ipairs(remove) do
      tile.movingObjects[obj] = nil
    end
  end)
  
  return tile
  
end