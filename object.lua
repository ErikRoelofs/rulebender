return function(dispatcher)
  return function()
    local builder = {
      object = {
        types = {
          object = true
        },
        dispatcher = dispatcher,
        draw = function() end,
        addType = function(self, newType)
          self.types[newType] = true
        end,
        hasType = function(self, someType)
          return self.types[someType]
        end
      }
    }
    
    builder.thatCanBeDrawn = function(self, drawFunction)
      self.draw = drawFunction
      self.object.types.drawable = true
      return self
    end
    
    builder.thatCanBePushed = function(self)
      self.pushable = true
      self.object.types.pushable = true
      return self
    end

    builder.thatIsSolid = function(self)
      self.object.state = "solid"
      self.object.types.solid = true
      return self
    end
    
    builder.thatIsATrigger = function(self, directions)
      self.isTrigger = true
      if directions then
        self.object.triggerDirections = directions
      else
        self.object.triggerDirections = CONST.DIRECTIONS()
      end
      self.object.types.trigger = true
      return self
    end
  
    builder.thatIsAnInput = function(self, directions)
      self.isInput = true
      if directions then
        self.object.inputDirections = directions
      else
        self.object.inputDirections = CONST.DIRECTIONS()
      end
      self.object.types.input = true
      return self
    end
        
    builder.withIdentifier = function(self, identifier)
      self.object.id = identifier
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
        self.object.maxActive = 0.8
        
        self.object.activate = function(self, input, trigger)
          self.active = self.maxActive
          self.triggerActive = trigger
          self.inputActive = input
          local dereg
          dereg = self.dispatcher:listen("time.passes", function(event)
            self.active = self.active - math.min(event.value, self.active)
            if self.active <= 0 then              
              dereg()
            end
          end)
        end
        
        self.object.isActive = function(self)
          return self.active > 0        
        end
        
        self.object.getActiveColor = function(self)
          local green, blue = 0, 0
          if self.inputActive then green = 0.5 end
          if self.triggerActive then blue = 0.5 end
          return {
            0,
            green,
            blue,
            self.active / (self.maxActive*3)
          }
        end
        
        self.object.drawActiveMark = function(self)
          if self:isActive() then
            love.graphics.setColor(self:getActiveColor())
            love.graphics.rectangle("fill", 0, 0, CONST.TILE_WIDTH, CONST.TILE_HEIGHT)
            love.graphics.setColor(1,1,1,1)
          end
        end        
        
      end
      
      if self.isInput then        
        local oldDraw = self.object.draw
        self.object.draw = function(self)
          love.graphics.setColor(0.3,0.3,0.3,1)
          love.graphics.rectangle("fill", 0, 0, CONST.TILE_WIDTH, CONST.TILE_HEIGHT)
          
          love.graphics.setColor(0.5,0.5,0.5,1)
          love.graphics.rectangle("fill", 2, 2, CONST.TILE_WIDTH - 4, CONST.TILE_HEIGHT - 4)
          
          love.graphics.setColor(1,1,1,1)
          oldDraw(self)
          
          self:drawActiveMark()
          
          love.graphics.setColor(0,1,0,1)
          if self.inputDirections.left then
            local xTip = 2
            local yTip = (CONST.TILE_HEIGHT / 2) - 5
            love.graphics.polygon("fill", xTip, yTip, xTip + 5, yTip + 5, xTip + 5, yTip- 5)
          end
          if self.inputDirections.right then
            local xTip = CONST.TILE_WIDTH - 2
            local yTip = (CONST.TILE_HEIGHT / 2) + 5
            love.graphics.polygon("fill", xTip, yTip, xTip - 5, yTip + 5, xTip - 5, yTip- 5)
          end
          if self.inputDirections.down then
            local xTip = CONST.TILE_WIDTH / 2 - 5
            local yTip = CONST.TILE_HEIGHT - 2
            love.graphics.polygon("fill", xTip, yTip, xTip - 5, yTip - 5, xTip + 5, yTip - 5)
          end
          if self.inputDirections.up then
            local xTip = CONST.TILE_WIDTH / 2 + 5
            local yTip = 2
            love.graphics.polygon("fill", xTip, yTip, xTip - 5, yTip + 5, xTip + 5, yTip + 5)            
          end

        end
        
        self.object.delayedPulse = function(self, delay, omitDirection)
          self.activationTime = delay
          local dereg 
          dereg = self.dispatcher:listen("time.passes", function(event)
            self.activationTime = self.activationTime - event.value
            if self.activationTime <= 0 then
              dereg()
              self:pulse(omitDirection)
            end
          end)
        end
        
        self.object.pulse = function(self, omitDirection)
          for direction in pairs(self.inputDirections) do
            if direction ~= omitDirection then
              newEvent = {
                name = "signal",
                object = self,
                direction = direction
              }
              self.dispatcher:dispatch(newEvent)
            end
          end
          self:activate(true, false)
        end
        
      end
      
      if self.isTrigger then
        local oldDraw = self.object.draw
        self.object.draw = function(self)
          love.graphics.setColor(0.3,0.3,0.8,1)
          love.graphics.rectangle("fill", 0, 0, CONST.TILE_WIDTH, CONST.TILE_HEIGHT)
          
          love.graphics.setColor(0.5,0.5,0.9,1)
          love.graphics.rectangle("fill", 2, 2, CONST.TILE_WIDTH - 4, CONST.TILE_HEIGHT - 4)
          
          love.graphics.setColor(1,1,1,1)
          oldDraw(self)
          
          self:drawActiveMark()
          
          love.graphics.setColor(0,0,1,1)
          if self.triggerDirections.left then
            local xTip = 7
            local yTip = (CONST.TILE_HEIGHT / 2) + 5
            love.graphics.polygon("fill", xTip, yTip, xTip - 5, yTip + 5, xTip - 5, yTip- 5)
          end
          if self.triggerDirections.right then
            local xTip = CONST.TILE_WIDTH - 7
            local yTip = (CONST.TILE_HEIGHT / 2) - 5
            love.graphics.polygon("fill", xTip, yTip, xTip + 5, yTip + 5, xTip + 5, yTip- 5)
          end
          if self.triggerDirections.down then
            local xTip = CONST.TILE_WIDTH / 2 + 5
            local yTip = CONST.TILE_HEIGHT - 7
            love.graphics.polygon("fill", xTip, yTip, xTip - 5, yTip + 5, xTip + 5, yTip + 5)
          end
          if self.triggerDirections.up then
            local xTip = CONST.TILE_WIDTH / 2 - 5
            local yTip = 7
            love.graphics.polygon("fill", xTip, yTip, xTip - 5, yTip - 5, xTip + 5, yTip - 5)            
          end

        end

      end
      
      
      return self.object
    end
    
    return builder
  end
end