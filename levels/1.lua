return function(dispatcher, objectFactory)
    local keyblockFactory = require("keyblock")
    local blockLeft = keyblockFactory(objectFactory, "a")
    local blockRight = keyblockFactory(objectFactory, "d")
    local blockUp = keyblockFactory(objectFactory, "w")
    local blockDown = keyblockFactory(objectFactory, "s")
    
    local collisionblock = require("collisionblock")(objectFactory, "trigger")
    
    local pulserFactory = require("pulser")
    local pulserBlock = pulserFactory(objectFactory, 1.5)
    
    local triggerblockFactory = require("triggerblock")
    local directionblocks = require("directionblocks")(objectFactory, dispatcher, triggerblockFactory)
    local didOpen = false
    local doorTrigger = triggerblockFactory(objectFactory, dispatcher, function()
        local event = {}
        if didOpen then
          event = {        
            name = "door.close"
          }      
          didOpen = false
        else
          event = {        
            name = "door.open"
          }
          didOpen = true
        end
        dispatcher:dispatch(event)
      end, function() 
        love.graphics.print("open", 3, 20)
      end)
    
    

  local room = require("room")(dispatcher, 4,8)
  local bot = require("bot")(objectFactory)
  local flag = require("flag")(objectFactory)

  local wall = require("wall")(objectFactory)
  local door = require("door")(objectFactory)

  room:placeObject(3, 3, blockLeft)
  --room:placeObject(3, 3, pulserBlock)
  --room:placeObject(3, 3, collisionblock)
  room:placeObject(3, 2, directionblocks.left)
  room:placeObject(3, 4, doorTrigger)

  room:placeObject(1, 2, blockRight)
  room:placeObject(1, 1, directionblocks.right)

  room:placeObject(2, 4, blockUp)
  room:placeObject(1, 4, directionblocks.up)

  room:placeObject(0, 0, blockDown)
  room:placeObject(0, 1, directionblocks.down)

  room:placeObject(3, 7, bot)
  room:placeObject(0, 6, wall)
  room:placeObject(0, 7, door)

  room:placeObject(1, 5, flag)

  dispatcher:listen("room.objectsCollided", function(event)
    if event.objectA:hasType("bot") and event.objectB:hasType("flag")
    or event.objectB:hasType("bot") and event.objectA:hasType("flag") then
      dispatcher:dispatch({name="level.completed"})
    end
      
  end)

  return room
end