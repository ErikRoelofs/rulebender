return function(dispatcher, library)
  local room = require("room")(dispatcher, 5,5, math.random(1,100))
  return room
end