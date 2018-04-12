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
end

dispatcher.flush = function(self)
  self.listeners = {}
end

return dispatcher