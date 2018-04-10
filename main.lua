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

function love.load()
  dispatcher = require("dispatcher")
  dispatcher:listen("inputblock.pulse", function(event)
    print(event.value.key)
  end)

  eventLog = require("eventlog")(dispatcher)

  keyblockFactory = require("keyblock")
  local blockA = keyblockFactory(dispatcher, "a")
  local blockB = keyblockFactory(dispatcher, "b")
  
  triggerblockFactory = require("triggerblock")
  counter = 0
  local triggerA = triggerblockFactory(dispatcher, function()
      counter = counter + 1
      local event = {
        name = "bot.left"
      }
      dispatcher:dispatch(event)
    end)
  triggerA:respondTo(blockA)
  triggerA:stopRespondingTo(blockA)
  
  room = require("room")(dispatcher, 4,8)
  local bot = require("bot")(dispatcher, room)
  
  local wall = require("wall")()
  
  room:placeObject(3, 3, blockA)
  room:placeObject(1, 1, blockB)
  room:placeObject(3, 2, triggerA)
  room:placeObject(3, 7, bot)
  room:placeObject(0, 7, wall)
  
end

function love.update(dt)
  
end

function love.draw()
  love.graphics.print(counter, 300, 10)
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