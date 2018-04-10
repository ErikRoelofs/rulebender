return function(dispatcher)
  local bot = {
    state = "solid"
  }
  bot.left = function()
    local event = {
      name = "move",
      object = bot,
      direction = "left"
    }
    dispatcher:dispatch(event)
  end
  dispatcher:listen("bot.left", bot.left)
  
  bot.right = function()
    local event = {
      name = "move",
      object = bot,
      direction = "right"
    }
    dispatcher:dispatch(event)
  end
  dispatcher:listen("bot.right", bot.right)

  bot.up = function()
    local event = {
      name = "move",
      object = bot,
      direction = "up"
    }
    dispatcher:dispatch(event)

  end
  dispatcher:listen("bot.up", bot.up)

  bot.down = function()
    local event = {
      name = "move",
      object = bot,
      direction = "down"
    }
    dispatcher:dispatch(event)
  end
  dispatcher:listen("bot.down", bot.down)

  bot.draw = function(self)
    love.graphics.print("bot!", 0, 20)
  end
  
  return bot
end