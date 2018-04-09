return function(dispatcher)
  local tile = {
    content = {},
    dispatcher = dispatcher
  }
  
  tile.canAddObject = function(self, object)
    for _, obj in ipairs(self.content) do
      if obj.state == "impassable" then
        return false
      end
    end
    return true
  end
  
  tile.addObject = function(self, object)
    if not self:canAddObject(object) then return end
    table.insert(self.content, object)
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
  
  return tile
  
end