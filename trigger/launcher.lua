return function(triggerblockFactory, objectFactory, id, dispatcher, triggerDirections, launchDirections)
  local spawnId = id * 50000
  local nextId = function()
    spawnId = spawnId + 1
    return spawnId
  end

  return triggerblockFactory(objectFactory, id, dispatcher, 
    function(self) return function()
      for direction in pairs(launchDirections) do
        local event = {
          name = "create.adjacent.moving",
          existingObject = self,
          newObject = require("entity/crate")(objectFactory, nextId()),
          direction = direction,
          speed = 1,
          dashing = true
        }
        self.dispatcher:dispatch(event)
      end
    end end,
    function()
      love.graphics.print("launcher", 4, 20)
    end, 
    triggerDirections
  )
end