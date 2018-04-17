return function(objectFactory, dispatcher)
  local keyblockFactory = require("input/keyblock")
  local pulserFactory = require("input/pulser")
  local motionFactory = require("input/motion")
  local collisionblockFactory = require("input/collisionblock")
  local triggerblockFactory = require("trigger/triggerblock")
  local directionblocksFactory = require("trigger/directionblocks") (objectFactory, dispatcher, triggerblockFactory)
  local doorFactory = require("trigger/door")
  local pusherblockFactory = require("trigger/pusherblock")
  
  return {
    -- bots, inputs, triggers, walls, doors, etc (factory functions only)
      input = {
        key = function(key, directions) return keyblockFactory(objectFactory, key, directions) end,
        collision = function(objectType, directions) return collisionblockFactory(objectFactory, objectType, directions) end,
        pulser = function(timer, directions) return pulserFactory(objectFactory, timer, directions) end,
        motion = function(timer, directions) return motionFactory(objectFactory, timer, directions) end,
      },
      trigger = {
        move = {
          left = function(directions) return directionblocksFactory.left(directions) end,
          right = function(directions) return directionblocksFactory.right(directions) end,
          down = function(directions) return directionblocksFactory.down(directions) end,
          up = function(directions) return directionblocksFactory.up(directions) end,
        },
        door = function(identifier, directions) return doorFactory(triggerblockFactory, objectFactory, dispatcher, identifier, directions) end,
        death = function(directions) return triggerblockFactory(objectFactory, dispatcher, function(self) return function(event) dispatcher:dispatch({name="bot.death"}) end end, function(self) love.graphics.print("DEATH", 4, 20) end, directions) end,
        pusher = function(directions, pushDirections) return pusherblockFactory(triggerblockFactory, objectFactory, dispatcher, directions, pushDirections) end,
      },
      entities = {
        bot = function() return require("entity/bot")(objectFactory) end,
        flag = function() return require("entity/flag")(objectFactory) end,
        wall = function() return require("entity/wall")(objectFactory) end,
        door = function(id) return require("entity/door")(objectFactory, id) end,      
      }
        
  }
end