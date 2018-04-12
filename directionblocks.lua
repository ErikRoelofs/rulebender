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
    left = function() return makeDirectionBlock("bot.left", "go left") end,
    right = function() return makeDirectionBlock("bot.right", "go right") end,
    up = function() return makeDirectionBlock("bot.up", "go up") end,
    down = function() return makeDirectionBlock("bot.down", "go down") end
  }
end