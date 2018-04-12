return function(dispatcher, library)
  local room = require("room")(dispatcher, 3,3)
  return room
end