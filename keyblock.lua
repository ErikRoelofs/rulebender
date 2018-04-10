return function(objectFactory, dispatcher, key)
  local inputblock = objectFactory()
    :thatIsSolid()
    :thatCanBePushed()
    :thatCanBeDrawn(function(self) love.graphics.print("input", 0, 20) end)
    :go()
  
  inputblock.key = key
  dispatcher:listen("keypressed", function(event)
    if event.key == inputblock.key then
      newEvent = {
        name = "inputblock.pulse",
        value = inputblock
      }
      dispatcher:dispatch(newEvent)
    end
  end)
  
  return inputblock
end