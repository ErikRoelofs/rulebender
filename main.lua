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
    v fromTrigger? (remote signal activation)
    v motion
    - specific object motion
    - destruction
    v ranged zap
    
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
    v zapper
    - pusher-launcher
    - puller
    
  non-solid:
    - belt
    - rotator
    v up-signal
    
  combined:
    - counters
    v delays
    v signal pass-through
    - signal teleport

]]

--[[
    refactor: object factory should be built from parts
    refactor: events or other objects for motion, instead of arg passing
    bugfix: interactions between moving objects (specifically zaps and such fired in close succession)
]]

--[[ game parts needed
  - level selection / menu
  - graphics & decoration
  - images / animations 
]]

-- global constants
CONST = {
  TILE_WIDTH = 75,
  TILE_HEIGHT = 75,
  DIRECTIONS = function() return { left = true, right = true, up = true, down = true } end
}

paused = false

local gametime = 0
local history = {}

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
  
  dispatcher = require("dispatch/dispatcher")()
  objectFactory = require("object")(dispatcher)
  eventLog = require("eventlog")(dispatcher)
  library = require("levels/library")(objectFactory, dispatcher)
    
  loader = require("levels/loader")(dispatcher, eventLog, library)
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
  if not paused then
    if not replay then
      gametime = gametime + dt
    end
    local event = {
      name = "time.passes",
      value = math.min(dt, 0.1)
    }
    dispatcher:dispatch(event)
  end
end

function love.draw()
  local replayText = "normal play"
  if replay then 
    replayText = "replaying"
  end
  love.graphics.print(replayText, 900, 500)
  room:draw()
  
  love.graphics.push()
  love.graphics.translate(600,0)
  eventLog:draw()
  love.graphics.pop()
end

function love.keypressed(key)
  if not paused and not replay then
    if key ~= "r" and key ~= "space" then
      local event = { 
          name = "keypressed",
          key = key
      }
      dispatcher:dispatch(event)
      table.insert(history, {time = gametime, event = event})
    end
  end
  if key == 'space' then
    if paused then
      local event = {
        name = "game.unpaused"        
      }
      dispatcher:dispatch(event)
      paused = false
    else
      local event = {
        name = "game.paused"
      }
      dispatcher:dispatch(event)
      paused = true
    end
  end
  if key == 'r' then
    if not replay then
      replay = true
      oldRoom = room
      oldDispatcher = dispatcher
      oldEventlog = eventLog
      oldLibrary = library
      oldObjectFactory = objectFactory

      dispatcher = require("dispatch/dispatcher")()
      eventLog = require("eventlog")(dispatcher)
      objectFactory = require("object")(dispatcher)
      library = require("levels/library")(objectFactory, dispatcher)
      loader = require("levels/loader")(dispatcher, eventLog, library)
      room = loader(1)
      for _, entry in ipairs(history) do
        dispatcher:dispatchDelayed(entry.event, entry.time)
      end
    else
      replay = false
      room = oldRoom
      eventLog = oldEventlog
      library = oldLibrary
      objectFactory = oldObjectFactory
      dispatcher:flush()
      dispatcher = oldDispatcher
    end
  end

end