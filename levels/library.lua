return function(objectFactory, dispatcher)
  local keyblockFactory = require("input/keyblock")
  local pulserFactory = require("input/pulser")
  local motionFactory = require("input/motion")
  local collisionblockFactory = require("input/collisionblock")
  local remoteInputFactory = require("input/remote")
  local plateFactory = require("input/signalPlate")
  
  local triggerblockFactory = require("trigger/triggerblock")
  local directionblocksFactory = require("trigger/directionblocks") (objectFactory, dispatcher, triggerblockFactory)
  local doorFactory = require("trigger/door")
  local pusherblockFactory = require("trigger/pusherblock")
  local launcherFactory = require("trigger/launcher")
  
  local signalPasserFactory = require("combined/signalPasser")
  local signalDelayFactory = require("combined/signalDelay")
  
  
  return {
    -- bots, inputs, triggers, walls, doors, etc (factory functions only)
      input = {
        key = function(id, key, directions) return keyblockFactory(objectFactory, id, key, directions) end,
        collision = function(id, objectType, directions) return collisionblockFactory(objectFactory, id, objectType, directions) end,
        pulser = function(id, timer, directions) return pulserFactory(objectFactory, id, timer, directions) end,
        motion = function(id, timer, directions) return motionFactory(objectFactory, id, timer, directions) end,
        remote = function(id, directions) return remoteInputFactory(objectFactory, id, directions) end,
        plate = function(id) return plateFactory(objectFactory, id) end,
      },
      trigger = {
        move = {
          left = function(id, botId, directions) return directionblocksFactory.left(id, botId, directions) end,
          right = function(id, botId, directions) return directionblocksFactory.right(id, botId, directions) end,
          down = function(id, botId, directions) return directionblocksFactory.down(id, botId, directions) end,
          up = function(id, botId, directions) return directionblocksFactory.up(id, botId, directions) end,
        },
        door = function(id, targetId, directions) return doorFactory(triggerblockFactory, objectFactory, dispatcher, id, targetId, directions) end,
        death = function(id, directions) return triggerblockFactory(objectFactory, id, dispatcher, function(self) return function(event) dispatcher:dispatch({name="bot.death"}) end end, function(self) love.graphics.print("DEATH", 4, 20) end, directions) end,
        pusher = function(id, directions, pushDirections) return pusherblockFactory(triggerblockFactory, objectFactory, id, dispatcher, directions, pushDirections) end,
        crateLauncher = function(id, directions, launchDirections) return launcherFactory(triggerblockFactory, objectFactory, id, dispatcher, directions, launchDirections, "entity/crate") end,
        zapper = function(id, directions, zapDirections) return launcherFactory(triggerblockFactory, objectFactory, id, dispatcher, directions, zapDirections, "entity/zap") end,
        blammer = function(id, directions, blamDirections) return launcherFactory(triggerblockFactory, objectFactory, id, dispatcher, directions, blamDirections, "entity/blam") end,
        puller = function(id, directions, pullDirections) return launcherFactory(triggerblockFactory, objectFactory, id, dispatcher, directions, pullDirections, "entity/pull", 6) end,
        flag = function(id) return require("trigger/flag")(triggerblockFactory, dispatcher, objectFactory, id) end,
        remote = function(id, triggerId) return require("trigger/remote")(triggerblockFactory, dispatcher, objectFactory, id, triggerId) end,
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