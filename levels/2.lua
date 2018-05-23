return function(dispatcher, library)
  local room = require("room")(dispatcher, 6,6, math.random(1,100))
  return room
end