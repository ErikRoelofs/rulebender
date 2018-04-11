return function(objectFactory, dispatcher, triggerblockFactory)
  
  function makeDirectionBlock(eventName, text)
    return triggerblockFactory(objectFactory, dispatcher, function()
      local event = {
        name = eventName
      }
      dispatcher:dispatch(event)
    end, function() 
      love.graphics.print(text, 3, 20)
    end)
  end

  return {
    left = makeDirectionBlock("bot.left", "go left"),
    right = makeDirectionBlock("bot.right", "go right"),
    up = makeDirectionBlock("bot.up", "go up"),
    down = makeDirectionBlock("bot.down", "go down")
  }
end