return function(dispatcher, room)
  local bot = {
    state = "solid"
  }
  bot.left = function()
    room:moveObject(bot, "left")
  end
  dispatcher:listen("bot.left", bot.left)
  
  bot.draw = function(self)
    love.graphics.print("bot!", 0, 20)
  end
  
  return bot
end