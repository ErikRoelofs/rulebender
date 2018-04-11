return function(dispatcher)
  return function()
    local builder = {
      object = {
        draw = function() end,
      }
    }
    
    builder.thatCanBeDrawn = function(self, drawFunction)
      self.object.draw = drawFunction
      return self
    end
    
    builder.thatCanBePushed = function(self)
      self.pushable = true
      return self
    end

    builder.thatIsSolid = function(self)
      self.object.state = "solid"
      return self
    end
    
    builder.go = function(self)
      if self.pushable then
        dispatcher:listen("object.pushed", function(event)
          if event.object == self.object then
            local newEvent = {
              name = "move",
              direction = event.direction,
              object = self.object,
              speed = event.speed
            }
            dispatcher:dispatch(newEvent)
          end
        end)
      end
      
      return self.object
    end
    
    return builder
  end
end