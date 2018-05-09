return function(objectFactory, dispatcher, triggerblockFactory)
  
  function makeDirectionBlock(id, eventName, text, directions)
    return triggerblockFactory(objectFactory, id, dispatcher, function(self) return function()
      local event = {
        name = eventName
      }
      dispatcher:dispatch(event)
    end end, function() 
      love.graphics.print(text, 3, 20)
    end,
    directions)
  end

  return {
    left = function(id, directions) return makeDirectionBlock(id, "bot.left", "go left", directions) end,
    right = function(id, directions) return makeDirectionBlock(id, "bot.right", "go right", directions) end,
    up = function(id, directions) return makeDirectionBlock(id, "bot.up", "go up", directions) end,
    down = function(id, directions) return makeDirectionBlock(id, "bot.down", "go down", directions) end
  }
end