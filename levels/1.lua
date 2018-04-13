return function(dispatcher, library)
  
  local room = require("room")(dispatcher, 4,8)

  room:placeObject(3, 3, library.input.key("a"))
  --room:placeObject(3, 3, library.input.pulser(1.0))
  --room:placeObject(3, 3, collisionblock)
  room:placeObject(3, 2, library.trigger.move.left())
  room:placeObject(3, 4, library.trigger.door("someId"))
  
  room:placeObject(2, 3, library.input.motion(0.3))

  room:placeObject(1, 2, library.input.key("d"))
  room:placeObject(1, 1, library.trigger.move.right())

  room:placeObject(2, 4, library.input.key("w"))
  room:placeObject(1, 4, library.trigger.move.up())

  room:placeObject(0, 0, library.input.key("s"))
  room:placeObject(1, 0, library.trigger.death())
  room:placeObject(0, 1, library.trigger.move.down())

  room:placeObject(3, 7, library.entities.bot())
  room:placeObject(0, 6, library.entities.wall())
  room:placeObject(0, 7, library.entities.door("someId"))

  room:placeObject(1, 5, library.entities.flag())

  dispatcher:listen("room.objectsCollided", function(event)
    if event.objectA:hasType("bot") and event.objectB:hasType("flag")
    or event.objectB:hasType("bot") and event.objectA:hasType("flag") then
      dispatcher:dispatch({name="level.completed"})
    end
      
  end)

  return room
end