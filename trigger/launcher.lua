return function(triggerblockFactory, objectFactory, dispatcher, triggerDirections, launchDirections)
  return triggerblockFactory(objectFactory, dispatcher, 
    function(self) return function()
      local event = {
        name = "create.adjacent.moving",
        existingObject = self,
        newObject = require("entity/crate")(objectFactory),
        direction = "down",
        speed = 1,
        dashing = true
      }
      self.dispatcher:dispatch(event)
    end end,
    function()
      love.graphics.print("launcher", 4, 20)
    end, 
    triggerDirections
  )
end