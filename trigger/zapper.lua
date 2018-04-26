return function(triggerblockFactory, objectFactory, dispatcher, triggerDirections, zapDirections)
  return triggerblockFactory(objectFactory, dispatcher, 
    function(self) return function()
      for direction in pairs(zapDirections) do
        local event = {
          name = "create.adjacent.moving",
          existingObject = self,
          newObject = require("entity/zap")(objectFactory, direction),
          direction = direction,
          speed = 1,
          dashing = true
        }
        self.dispatcher:dispatch(event)
      end
    end end,
    function()
      love.graphics.print("zapper", 4, 20)
    end, 
    triggerDirections
  )
end