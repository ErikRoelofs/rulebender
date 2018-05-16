return function(dispatcher, library)
  local room = require("room")(dispatcher, 3,3, math.random(1,100))
  return room
end