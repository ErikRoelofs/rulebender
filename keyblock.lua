return function(dispatcher, key)
  local inputblock = {
    key = key
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
  
  inputblock.draw = function(self)
    love.graphics.print("input", 0, 20)
  end

  return inputblock
end