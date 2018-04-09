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

  keyblockFactory = require("keyblock")
  local blockA = keyblockFactory(dispatcher, "a")
  local blockB = keyblockFactory(dispatcher, "b")
  
  triggerblockFactory = require("triggerblock")
  counter = 0
  local triggerA = triggerblockFactory(dispatcher, function()
      counter = counter + 1
    end)
  triggerA:respondTo(blockA)
  
end

function love.update(dt)
  
end

function love.draw()
  love.graphics.print(counter, 100, 100)
end

function love.keypressed(key)
  local event = {
      name = "keypressed",
      key = key
  }
  dispatcher:dispatch(event)
end