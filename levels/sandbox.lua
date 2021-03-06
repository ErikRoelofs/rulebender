return function(dispatcher, library)
  local room = require("room")(dispatcher, 4,12, math.random(1,100))

  local curId = 1
  id = function()
    curId = curId + 1
    return curId
  end

  local botId = id()

  room:placeObject(3, 3, library.input.key(id(), "a", { up = true, left = true }))
  --room:placeObject(3, 3, library.input.pulser(1.0))
  --room:placeObject(3, 3, collisionblock)
  room:placeObject(3, 2, library.trigger.move.left(id(), botId, { down = true}))
  room:placeObject(3, 4, library.trigger.door(id(), "someId"))
  
  room:placeObject(2, 3, library.input.motion(id(), 0.6))
  room:placeObject(2, 5, library.trigger.puller(id(), {up = true, down = true}, {down = true, left = true, right = true }))
  room:placeObject(2, 2, library.combined.delay(id(), nil, nil, 0.3))
  room:placeObject(1, 3, library.combined.wire(id(), nil, nil, 0.3))
  room:placeObject(2, 8, library.trigger.move.up(id(), botId))

  room:placeObject(1, 2, library.input.key(id(), "d"))
  room:placeObject(1, 1, library.trigger.move.right(id(), botId))

  room:placeObject(2, 4, library.input.key(id(), "w"))
--  room:placeObject(1, 4, library.trigger.move.up(id()))

  room:placeObject(0, 0, library.input.key(id(), "s"))
--room:placeObject(2, 0, library.trigger.death(id(), {up = true, down = true, right=true}))
  room:placeObject(0, 1, library.trigger.move.down(id(), botId))

  room:placeObject(3, 11, library.entities.bot(botId))
  room:placeObject(0, 6, library.entities.wall(id()))
  room:placeObject(0, 7, library.entities.door("someId"))

--  room:placeObject(1, 5, library.trigger.flag(id()))
  
  room:placeObject(1, 5, library.input.plate(id()))
  room:placeObject(1, 5, library.trigger.move.left(id(), id()))
  
  local remoteInput = id()
  room:placeObject(3, 0, library.input.remote(remoteInput))
  room:placeObject(1, 4, library.trigger.remote(id(), remoteInput))

  return room
end