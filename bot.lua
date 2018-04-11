return function(dispatcher)
  local bot = {
    state = "solid",
    moving = false
  }
  
  bot.makeMoveEvent = function(direction)
    return {
      name = "move",
      object = bot,
      direction = direction,
      speed = 2
    }
  end
  
  bot.left = function()
    if bot.moving then return end
    dispatcher:dispatch(bot.makeMoveEvent("left"))
  end
  dispatcher:listen("bot.left", bot.left)
  
  bot.right = function()
    if bot.moving then return end
    dispatcher:dispatch(bot.makeMoveEvent("right"))
  end
  dispatcher:listen("bot.right", bot.right)

  bot.up = function()
    if bot.moving then return end
    dispatcher:dispatch(bot.makeMoveEvent("up"))
  end
  dispatcher:listen("bot.up", bot.up)

  bot.down = function()
    if bot.moving then return end
    dispatcher:dispatch(bot.makeMoveEvent("down"))
  end
  dispatcher:listen("bot.down", bot.down)

  bot.draw = function(self)
    love.graphics.print("bot!", 0, 20)
  end
  
  dispatcher:listen("object.moving", function(event)
    bot.moving = true
  end)
  
  dispatcher:listen("object.arrived", function(event)
    bot.moving = false
  end)
  
  return bot
end