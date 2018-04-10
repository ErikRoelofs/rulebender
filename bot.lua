return function(dispatcher, room)
  local bot = {
    state = "solid"
  }
  bot.left = function()
    room:moveObject(bot, "left")
  end
  dispatcher:listen("bot.left", bot.left)
  
  bot.right = function()
    room:moveObject(bot, "right")
  end
  dispatcher:listen("bot.right", bot.right)

  bot.up = function()
    room:moveObject(bot, "up")
  end
  dispatcher:listen("bot.up", bot.up)

  bot.down = function()
    room:moveObject(bot, "down")
  end
  dispatcher:listen("bot.down", bot.down)

  bot.draw = function(self)
    love.graphics.print("bot!", 0, 20)
  end
  
  return bot
end