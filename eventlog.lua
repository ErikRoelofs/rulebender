return function(dispatcher)
    
  local eventLog = {
    dispatcher = dispatcher,
    events = {},
    total = 0
  }
  
  eventLog.register = function(self)  
    dispatcher:listen("*", function(event)
      if event.name ~= "time.passes" then
        eventLog:addEvent(event)
      end
    end)
  end

  eventLog.draw = function(self)
    love.graphics.print(self.total .. " events", 0, 0 )
    for i, entry in ipairs(self.events) do
      love.graphics.print(entry.event.name .. " x " .. entry.times, 0, i * 15)
    end
  end

  eventLog.addEvent = function(self, event)
    self.total = self.total + 1
    if #self.events > 0 and self.events[#self.events].event.name == event.name then
      self.events[#self.events].times = self.events[#self.events].times + 1
    else      
      table.insert(self.events, {event = event, times = 1})
    end
    if #self.events > 25 then
      table.remove(self.events, 1)
    end
  end
  
  eventLog.flush = function(self, event)
    self.events = {}
  end

  return eventLog
end