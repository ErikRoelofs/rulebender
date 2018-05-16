return function(objectFactory, dispatcher)
  local keyblockFactory = require("input/keyblock")
  local pulserFactory = require("input/pulser")
  local motionFactory = require("input/motion")
  local collisionblockFactory = require("input/collisionblock")
  local triggerblockFactory = require("trigger/triggerblock")
  local directionblocksFactory = require("trigger/directionblocks") (objectFactory, dispatcher, triggerblockFactory)
  local doorFactory = require("trigger/door")
  local pusherblockFactory = require("trigger/pusherblock")
  local launcherFactory = require("trigger/launcher")
  local zapperFactory = require("trigger/zapper")
  local signalPasserFactory = require("combined/signalPasser")
  local signalDelayFactory = require("combined/signalDelay")
  
  return {
    -- bots, inputs, triggers, walls, doors, etc (factory functions only)
      input = {
        key = function(id, key, directions) return keyblockFactory(objectFactory, id, key, directions) end,
        collision = function(id, objectType, directions) return collisionblockFactory(objectFactory, id, objectType, directions) end,
        pulser = function(id, timer, directions) return pulserFactory(objectFactory, id, timer, directions) end,
        motion = function(id, timer, directions) return motionFactory(objectFactory, id, timer, directions) end,
      },
      trigger = {
        move = {
          left = function(id, directions) return directionblocksFactory.left(id, directions) end,
          right = function(id, directions) return directionblocksFactory.right(id, directions) end,
          down = function(id, directions) return directionblocksFactory.down(id, directions) end,
          up = function(id, directions) return directionblocksFactory.up(id, directions) end,
        },
        door = function(id, targetId, directions) return doorFactory(triggerblockFactory, objectFactory, dispatcher, id, targetId, directions) end,
        death = function(id, directions) return triggerblockFactory(objectFactory, id, dispatcher, function(self) return function(event) dispatcher:dispatch({name="bot.death"}) end end, function(self) love.graphics.print("DEATH", 4, 20) end, directions) end,
        pusher = function(directions, id, pushDirections) return pusherblockFactory(triggerblockFactory, objectFactory, id, dispatcher, directions, pushDirections) end,
        launcher = function(id, directions, launchDirections) return launcherFactory(triggerblockFactory, objectFactory, id, dispatcher, directions, launchDirections) end,
        zapper = function(id, directions, zapDirections) return zapperFactory(triggerblockFactory, objectFactory, id, dispatcher, directions, zapDirections) end,
        flag = function(id) return require("trigger/flag")(triggerblockFactory, dispatcher, objectFactory, id) end,
      },
      combined = {
        wire = function(id, inputDirections, triggerDirections) return signalPasserFactory(objectFactory, id, inputDirections, triggerDirections) end,
        delay = function(id, inputDirections, triggerDirections, delay) return signalDelayFactory(objectFactory, id, inputDirections, triggerDirections, delay) end,
      },
      entities = {
        bot = function(id) return require("entity/bot")(objectFactory, id) end,
        wall = function(id) return require("entity/wall")(objectFactory, id) end,
        crate = function(id) return require("entity/crate")(objectFactory, id) end,
        door = function(id) return require("entity/door")(objectFactory, id) end,      
      }
        
  }
end