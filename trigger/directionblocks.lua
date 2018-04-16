return function(objectFactory, dispatcher, triggerblockFactory)
  
  function makeDirectionBlock(eventName, text, directions)
    return triggerblockFactory(objectFactory, dispatcher, function()
      local event = {
        name = eventName
      }
      dispatcher:dispatch(event)
    end, function() 
      love.graphics.print(text, 3, 20)
    end,
    directions)
  end

  return {
    left = function(directions) return makeDirectionBlock("bot.left", "go left", directions) end,
    right = function(directions) return makeDirectionBlock("bot.right", "go right", directions) end,
    up = function(directions) return makeDirectionBlock("bot.up", "go up", directions) end,
    down = function(directions) return makeDirectionBlock("bot.down", "go down", directions) end
  }
end