return function(objectFactory, dispatcher, triggerblockFactory)
  
  local left = triggerblockFactory(objectFactory, dispatcher, function()
    local event = {
      name = "bot.left"
    }
    dispatcher:dispatch(event)
  end)

  local right = triggerblockFactory(objectFactory, dispatcher, function()
    local event = {
      name = "bot.right"
    }
    dispatcher:dispatch(event)
  end)

  local up = triggerblockFactory(objectFactory, dispatcher, function()
    local event = {
      name = "bot.up"
    }
    dispatcher:dispatch(event)
  end)

  local down = triggerblockFactory(objectFactory, dispatcher, function()
    local event = {
      name = "bot.down"
    }
    dispatcher:dispatch(event)
  end)

  return {
    left = left,
    right = right,
    up = up,
    down = down
  }
end