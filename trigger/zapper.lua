return function(triggerblockFactory, objectFactory, id, dispatcher, triggerDirections, zapDirections)
  local spawnId = id * 50000
  local nextId = function()
    spawnId = spawnId + 1
    return spawnId
  end
  return triggerblockFactory(objectFactory, id, dispatcher,
    function(self) return function()
      for direction in pairs(zapDirections) do
        local event = {
          name = "create.adjacent.moving",
          existingObject = self,
          newObject = require("entity/zap")(objectFactory, nextId(), direction),
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