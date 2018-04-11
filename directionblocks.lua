return function(objectFactory, dispatcher, triggerblockFactory)
  
  local left = triggerblockFactory(objectFactory, dispatcher, function()
    local event = {
      name = "bot.left"
    }
    dispatcher:dispatch(event)
  end, function() 
    love.graphics.print("go left", 0, 20)
  end)

  local right = triggerblockFactory(objectFactory, dispatcher, function()
    local event = {
      name = "bot.right"
    }
    dispatcher:dispatch(event)
  end, function() 
    love.graphics.print("go right", 0, 20)
  end)

  local up = triggerblockFactory(objectFactory, dispatcher, function()
    local event = {
      name = "bot.up"
    }
    dispatcher:dispatch(event)
  end, function() 
    love.graphics.print("go up", 0, 20)
  end)

  local down = triggerblockFactory(objectFactory, dispatcher, function()
    local event = {
      name = "bot.down"
    }
    dispatcher:dispatch(event)
  end, function() 
    love.graphics.print("go down", 0, 20)
  end)

  return {
    left = left,
    right = right,
    up = up,
    down = down
  }
end