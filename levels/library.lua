return function(objectFactory, dispatcher)
  local keyblockFactory = require("keyblock")
  local pulserFactory = require("pulser")
  local collisionblockFactory = require("collisionblock")
  local triggerblockFactory = require("triggerblock")
  local directionblocksFactory = require("directionblocks") (objectFactory, dispatcher, triggerblockFactory)
  
  return {
    -- bots, inputs, triggers, walls, doors, etc (factory functions only)
      input = {
        key = function(key) return keyblockFactory(objectFactory, key) end,
        collision = function(objectType) return collisionblockFactory(objectFactory, objectType) end,
        pulser = function(timer) return pulserFactory(objectFactory, timer) end,
      },
      trigger = {
        move = {
          left = function() return directionblocksFactory.left() end,
          right = function() return directionblocksFactory.right() end,
          down = function() return directionblocksFactory.down() end,
          up = function() return directionblocksFactory.up() end,
        }
      },
      entities = {
        bot = function() return require("bot")(objectFactory) end,
        flag = function() return require("flag")(objectFactory) end,
        wall = function() return require("wall")(objectFactory) end,
        door = function() return require("door")(objectFactory) end,      
      }
        
  }
end