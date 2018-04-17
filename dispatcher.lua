local dispatcher = {
  listeners = {}
}

local dispatchTo = function(name, listeners, event)
  if listeners[name] then
    for _, callback in ipairs(listeners[name]) do
        callback(event)
    end
  end
end

dispatcher.dispatch = function(self, event)
  dispatchTo('*', self.listeners, event)
  dispatchTo(event.name, self.listeners, event)
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

return dispatcher