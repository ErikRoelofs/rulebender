return function(dispatcher)
  return function()
    local builder = {
      object = {
        dispatcher = dispatcher,
        draw = function() end,
      }
    }
    
    builder.thatCanBeDrawn = function(self, drawFunction)
      self.draw = drawFunction
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
    
    builder.thatIsATrigger = function(self)
      self.isTrigger = true
      return self
    end
  
    builder.thatIsAnInput = function(self)
      self.isInput = true
      return self
    end
    
    builder.go = function(self)
      if self.draw then
        self.object.draw = self.draw
      end

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
      
      if self.isInput or self.isTrigger then
        
        self.object.active = 0
        self.object.maxActive = 0.5
        
        self.object.activate = function(self)
          self.active = self.maxActive
        end
        
        self.object.isActive = function(self)
          return self.active > 0
        end
        
        self.object.getActiveColor = function(self)
          return {
            self.color[1],
            self.color[2],
            self.color[3],
            self.active / self.maxActive
          }
        end
        
        self.object.drawActiveMark = function(self)
          if self:isActive() then
            love.graphics.setColor(self:getActiveColor())
            love.graphics.circle("fill", 5,5,5)
            love.graphics.setColor(1,1,1,1)
          end
        end
        
        self.object.dispatcher:listen("time.passes", function(event)
          if self.object.active > 0 then
            self.object.active = self.object.active - math.min(event.value, self.object.active)
          end
        end)
      end
      
      if self.isInput then
        self.object.color = {0,1,0}
        
        local oldDraw = self.object.draw
        self.object.draw = function(self)
          love.graphics.setColor(0.3,0.3,0.3,1)
          love.graphics.rectangle("fill", 0, 0, 49, 49)
          
          love.graphics.setColor(0.5,0.5,0.5,1)
          love.graphics.rectangle("fill", 2, 2, 45, 45)
          
          love.graphics.setColor(1,1,1,1)
          oldDraw(self)
          
          self:drawActiveMark()
        end
        
      end
      
      if self.isTrigger then
        self.object.color = {0,0,1}
        
        local oldDraw = self.object.draw
        self.object.draw = function(self)
          love.graphics.setColor(0.3,0.3,0.8,1)
          love.graphics.rectangle("fill", 0, 0, 49, 49)
          
          love.graphics.setColor(0.5,0.5,0.9,1)
          love.graphics.rectangle("fill", 2, 2, 45, 45)
          
          love.graphics.setColor(1,1,1,1)
          oldDraw(self)
          
          self:drawActiveMark()
        end

      end
      
      
      return self.object
    end
    
    return builder
  end
end