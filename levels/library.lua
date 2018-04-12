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
        },
        door = function(identifier)          
          local doorIsClosed = true 
          return triggerblockFactory(objectFactory, dispatcher, 
            function()
              if doorIsClosed then
                doorIsClosed = false
                dispatcher:dispatch({name="door.open", targetId=identifier})
              else
                doorIsClosed = true
                dispatcher:dispatch({name="door.close", targetId=identifier})
              end            
            end,
            function()
              love.graphics.print("doorswitch", 4, 20)
            end
          )
        end
      },
      entities = {
        bot = function() return require("bot")(objectFactory) end,
        flag = function() return require("flag")(objectFactory) end,
        wall = function() return require("wall")(objectFactory) end,
        door = function(id) return require("door")(objectFactory, id) end,      
      }
        
  }
end