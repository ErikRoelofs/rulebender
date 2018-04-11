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

]]

--[[
  - event / object factory




]]


function love.load()
  dispatcher = require("dispatcher")

  objectFactory = require("object")(dispatcher)

  eventLog = require("eventlog")(dispatcher)

  keyblockFactory = require("keyblock")
  local blockLeft = keyblockFactory(objectFactory, dispatcher, "a")
  local blockRight = keyblockFactory(objectFactory, dispatcher, "d")
  local blockUp = keyblockFactory(objectFactory, dispatcher, "w")
  local blockDown = keyblockFactory(objectFactory, dispatcher, "s")
  
  triggerblockFactory = require("triggerblock")
  directionblocks = require("directionblocks")(objectFactory, dispatcher, triggerblockFactory)
  
  room = require("room")(dispatcher, 4,8)
  local bot = require("bot")(dispatcher)
  
  local wall = require("wall")()
  
  room:placeObject(3, 3, blockLeft)
  room:placeObject(3, 2, directionblocks.left)
  
  room:placeObject(1, 2, blockRight)
  room:placeObject(1, 1, directionblocks.right)
  
  room:placeObject(2, 4, blockUp)
  room:placeObject(1, 4, directionblocks.up)

  room:placeObject(0, 0, blockDown)
  room:placeObject(0, 1, directionblocks.down)

  room:placeObject(3, 7, bot)
  room:placeObject(0, 6, wall)
  
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