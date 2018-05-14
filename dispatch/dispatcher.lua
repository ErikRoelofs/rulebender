local dispatcher = {
  timer = 0,
  listeners = {},
  queue = {},
  history = {}
}

local dispatchTo = function(name, listeners, event)
  if listeners[name] then
    for _, callback in ipairs(listeners[name]) do
        callback(event)
    end
  end
end

dispatcher.dispatch = function(self, event)  
  if event.name == "time.passes" then
    self:_handleTimePassing(event)
    self:_doDispatch(event)
  else
    table.insert(self.history, { time = self.timer, event = event })
    self:_doDispatch(event)
  end  
end

dispatcher._doDispatch = function(self, event)
  dispatchTo('*', self.listeners, event)
  dispatchTo(event.name, self.listeners, event)  
end

dispatcher.dispatchDelayed = function(self, event, delay)
  if event.name == "time.passes" then
    error("Time waits for nobody. (You cannot delay a time.passes event, the delay system depends on exactly that event.)")
  end
  table.insert(self.queue, {delay = delay, event = event})
end

dispatcher.listen = function(self, name, callback)
  if not self.listeners[name] then
    self.listeners[name] = {}
  end
  table.insert(self.listeners[name], callback)
  return function()
    dispatcher:deregister(name, callback)
  end
end

dispatcher._handleTimePassing = function(self, event)
  self.timer = self.timer + event.value
  for key, queued in ipairs(self.queue) do
    queued.delay = queued.delay - event.value
    if queued.delay <= 0 then
      self:dispatch(queued.event)      
    end
  end
  
  local i = #self.queue
  while i > 0 do
    if self.queue[i].delay <= 0 then
      table.remove(self.queue)
    end
    i = i - 1
  end
end 

dispatcher.deregister = function(self, name, callback)
  if not self.listeners[name] then return end
  for key, registeredCallback in ipairs(self.listeners[name]) do
    if callback == registeredCallback then
      table.remove(self.listeners[name], key)
      return
    end
  end
  error("Cannot deregister, function not recognized?")
end

dispatcher.flush = function(self)
  self.listeners = {}
end

dispatcher.getHistory = function(self)
  return self.history
end

return dispatcher