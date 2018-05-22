return function(dispatcher, library)
  local room = require("room")(dispatcher, 5,5, math.random(1,100))
  
  local curId = 1
  id = function()
    curId = curId + 1
    return curId
  end

  room:placeObject(0, 0, library.trigger.zapper(id(), nil, { down = true }))
  room:placeObject(1, 0, library.input.key(id(), "s"))

  room:placeObject(0, 3, library.trigger.pusher(id(), nil, { right = true }))
  room:placeObject(1, 3, library.combined.wire(id(), {left = true, right = true},{left = true, right = true}))
  room:placeObject(2, 3, library.combined.wire(id(), {left = true, right = true},{left = true, right = true}))
  room:placeObject(3, 3, library.input.key(id(), "a", { down = true }))

  local doorId = id()
  room:placeObject(0, 2, library.entities.door(doorId))

  room:placeObject(4, 0, library.input.pulser(id(), 2))
  room:placeObject(4, 1, library.trigger.door(id(), doorId))

  room:placeObject(4, 4, library.trigger.flag(id()))
  
  
  return room
end