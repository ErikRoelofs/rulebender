if arg[#arg] == "-debug" then debug = true else debug = false end
if debug then require("mobdebug").start() end

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
    v motion
    - destruction
    
  triggers:
    - object movement
    - damage/death
    v pushing
    - open/close
    v win
    - on/off
    - shoot/attack
    - grab/drop
    - rotate
    - manipulate state
    
  combined:
    - counters
    v delays
    v signal pass-through
    - signal teleport

]]

--[[
    refactor: object factory should be built from parts
    refactor: events or other objects for motion, instead of arg passing
]]

-- global constants
CONST = {
  TILE_WIDTH = 60,
  TILE_HEIGHT = 60,
  DIRECTIONS = function() return { left = true, right = true, up = true, down = true } end
}

inverseDirection = function(direction)
  if direction == "left" then return "right" end
  if direction == "right" then return "left" end
  if direction == "up" then return "down" end
  if direction == "down" then return "up" end
  error("Called without a proper direction!")
end

morphCoordinates = function(direction, x, y)
  if direction == "left" then return x - 1, y end
  if direction == "right" then return x + 1, y end
  if direction == "up" then return x, y - 1 end
  if direction == "down" then return x, y + 1 end
  error("Called without a proper direction!")
end

function love.load()
  dispatcher = require("dispatcher")
  objectFactory = require("object")(dispatcher)
  eventLog = require("eventlog")(dispatcher)
  library = require("levels/library")(objectFactory, dispatcher)
    
  local loader = require("levels/loader")(dispatcher, eventLog, library)
  room = loader(1)
  
  dispatcher:listen("level.completed", function(event)
    wait = 0.2
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
  love.graphics.translate(600,0)
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