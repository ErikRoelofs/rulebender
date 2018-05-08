local facade = {}

facade.mainDispatch = require("dispatch/dispatcher")
facade.historyDispatch = require("dispatch/replayer")
facade.dispatcher = facade.mainDispatch

facade.dispatch = function(self, event)  
  self.dispatcher:dispatch(event)
end

facade.dispatchDelayed = function(self, event, delay)
  self.dispatcher:dispatchDelayed(event, delay)
end

facade.listen = function(self, name, callback)
  return self.dispatcher:listen(name, callback)
end

facade.deregister = function(self, name, callback)
  self.dispatcher:deregister(name, callback)
end

facade.flush = function(self)
  self.dispatcher:flush()
end

facade.startReplayMode = function(self)
  self.historyDispatch:flush()
  self.historyDispatch:receiveHistory(self.mainDispatch:getHistory())
  self.dispatcher = self.historyDispatch
end

return facade