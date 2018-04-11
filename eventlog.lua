return function(dispatcher)
    
  local eventLog = {
    dispatcher = dispatcher,
    events = {}
  }
  
  dispatcher:listen("*", function(event)
    if event.name ~= "time.passes" then
      eventLog:addEvent(event)
    end
  end)

  eventLog.draw = function(self)
    for i, event in ipairs(self.events) do
      love.graphics.print(event.name, 0, i * 15)
    end
  end

  eventLog.addEvent = function(self, event)
    table.insert(self.events, event)
    if #self.events > 25 then
      table.remove(self.events, 1)
    end
  end

  return eventLog
end