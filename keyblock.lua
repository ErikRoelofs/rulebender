return function(dispatcher, key)
  local inputblock = {
    key = key,
    state = "solid"
  }
  dispatcher:listen("keypressed", function(event)
    if event.key == inputblock.key then
      newEvent = {
        name = "inputblock.pulse",
        value = inputblock
      }
      dispatcher:dispatch(newEvent)
    end
  end)
    
  dispatcher:listen("object.pushed", function(event)
    if event.object == inputblock then
      local newEvent = {
        name = "move",
        direction = event.direction,
        object = inputblock
      }
      dispatcher:dispatch(newEvent)
    end
  end)

  inputblock.draw = function(self)
    love.graphics.print("input", 0, 20)
  end

  return inputblock
end