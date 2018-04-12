--[[
  objects (game internal)
  - inputblocks
    (listens to event stream)
    (turns on/off)
  - effectblocks
    (listens to event stream)
    (executes self)
  - room
    (tracks entity positions)
    (pushes collisions)
  - bot
    (listens to commands)
    (executes commands)

]]

--[[
  inputs:
    v key
    / collision
    v time
    - fromTrigger?
    - motion
    - destruction
    
  triggers:
    - object movement
    - damage/death
    - pushing
    - open/close
    - win
    - on/off
    - shoot/attack
    - grab/drop
    - rotate
    - manipulate state
    
  combined:
    - counters
    - delays
    - signal pass-through
    - signal teleport

]]

function love.load()
  dispatcher = require("dispatcher")
  objectFactory = require("object")(dispatcher)
  eventLog = require("eventlog")(dispatcher)

  keyblockFactory = require("keyblock")
  local blockLeft = keyblockFactory(objectFactory, "a")
  local blockRight = keyblockFactory(objectFactory, "d")
  local blockUp = keyblockFactory(objectFactory, "w")
  local blockDown = keyblockFactory(objectFactory, "s")
  
  collisionblock = require("collisionblock")(objectFactory, "trigger")
  
  pulserFactory = require("pulser")
  local pulserBlock = pulserFactory(objectFactory, 1.5)
  
  triggerblockFactory = require("triggerblock")
  directionblocks = require("directionblocks")(objectFactory, dispatcher, triggerblockFactory)
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
  
  
  room = require("room")(dispatcher, 4,8)
  local bot = require("bot")(objectFactory)
  
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
  
end

function love.update(dt)
  local event = {
    name = "time.passes",
    value = dt
  }
  dispatcher:dispatch(event)
end

function love.draw()
  room:draw()
  
  love.graphics.push()
  love.graphics.translate(500,0)
  eventLog:draw()
  love.graphics.pop()
end

function love.keypressed(key)
  local event = {
      name = "keypressed",
      key = key
  }
  dispatcher:dispatch(event)
end