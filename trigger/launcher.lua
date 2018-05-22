return function(triggerblockFactory, objectFactory, id, dispatcher, triggerDirections, launchDirections, launchEntity, launchSpeed)
  local spawnId = id * 50000
  local nextId = function()
    spawnId = spawnId + 1
    return spawnId
  end
  launchSpeed = launchSpeed or 2

  return triggerblockFactory(objectFactory, id, dispatcher, 
    function(self) return function()
      for direction in pairs(launchDirections) do
        local event = {
          name = "create.adjacent.moving",
          existingObject = self,
          newObject = require(launchEntity)(objectFactory, nextId(), direction, launchSpeed),
          direction = direction,
          speed = launchSpeed,
          dashing = true
        }
        self.dispatcher:dispatch(event)
      end
    end end,
    function()
      love.graphics.print("launcher", 4, 20)
    end, 
    triggerDirections,
    1 / launchSpeed + 0.1
  )
end