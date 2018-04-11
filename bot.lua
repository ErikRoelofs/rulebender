return function(dispatcher)
  local bot = {
    state = "solid"
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
    dispatcher:dispatch(bot.makeMoveEvent("left"))
  end
  dispatcher:listen("bot.left", bot.left)
  
  bot.right = function()
    dispatcher:dispatch(bot.makeMoveEvent("right"))
  end
  dispatcher:listen("bot.right", bot.right)

  bot.up = function()
    dispatcher:dispatch(bot.makeMoveEvent("up"))
  end
  dispatcher:listen("bot.up", bot.up)

  bot.down = function()
    dispatcher:dispatch(bot.makeMoveEvent("down"))
  end
  dispatcher:listen("bot.down", bot.down)

  bot.draw = function(self)
    love.graphics.print("bot!", 0, 20)
  end
  
  return bot
end