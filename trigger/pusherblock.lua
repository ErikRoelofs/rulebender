return function(triggerblockFactory, objectFactory, id, dispatcher, signalDirections, pushDirections)
  if not pushDirections then
    pushDirections = CONST.DIRECTIONS()
  end
  return triggerblockFactory(objectFactory, id, dispatcher, 
    function(self) return function()
      for direction in pairs(pushDirections) do
        dispatcher:dispatch({name = "push", direction = direction, speed = 2, object = self})
      end
    end end,
    function()
      love.graphics.print("pusher", 4, 20)
    end,
    signalDirections
  )
end