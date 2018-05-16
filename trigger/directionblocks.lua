return function(objectFactory, dispatcher, triggerblockFactory)
  
  function makeDirectionBlock(id, botId, eventName, text, directions)
    return triggerblockFactory(objectFactory, id, dispatcher, function(self) return function()
      local event = {
        name = eventName,
        botId = botId, 
      }
      dispatcher:dispatch(event)
    end end, function() 
      love.graphics.print(text, 3, 20)
    end,
    directions)
  end

  return {
    left = function(id, botId, directions) return makeDirectionBlock(id, botId, "bot.left", "go left", directions) end,
    right = function(id, botId, directions) return makeDirectionBlock(id, botId, "bot.right", "go right", directions) end,
    up = function(id, botId, directions) return makeDirectionBlock(id, botId, "bot.up", "go up", directions) end,
    down = function(id, botId, directions) return makeDirectionBlock(id, botId, "bot.down", "go down", directions) end
  }
end