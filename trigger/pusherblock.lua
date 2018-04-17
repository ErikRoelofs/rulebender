return function(triggerblockFactory, objectFactory, dispatcher, directions)
  return triggerblockFactory(objectFactory, dispatcher, 
    function(self) return function()
      dispatcher:dispatch({name = "push", direction = "down", speed = 2, object = self})
      dispatcher:dispatch({name = "push", direction = "left", speed = 2, object = self})
      dispatcher:dispatch({name = "push", direction = "right", speed = 2, object = self})
      dispatcher:dispatch({name = "push", direction = "up", speed = 2, object = self})
    end end,
    function()
      love.graphics.print("pusher", 4, 20)
    end,
    directions
  )
end