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
  library = require("levels/library")(objectFactory, dispatcher)
    
  local loader = require("levels/loader")(dispatcher, eventLog, library)
  room = loader(1)
  
  dispatcher:listen("level.completed", function(event)
    wait = 1
    dispatcher:listen("time.passes", function(event)
      wait = wait - event.value
      if wait <= 0 then
        dispatcher:dispatch({name = "level.next"})
      end
    end)
  end)

  dispatcher:listen("level.next", function(event)
    room = loader(2)
  end)
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