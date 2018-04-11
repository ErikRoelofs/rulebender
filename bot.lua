return function(dispatcher)
  local bot = {
    state = "solid",
    moving = false
  }
  
  bot.makeMoveFunction = function(direction)
    local event = {
      name = "move",
      object = bot,
      direction = direction,
      speed = 2
    }
    return function()
      if bot.moving then return end
      dispatcher:dispatch(event)
    end
  end
  
  dispatcher:listen("bot.left", bot.makeMoveFunction("left"))
  dispatcher:listen("bot.right", bot.makeMoveFunction("right"))
  dispatcher:listen("bot.down", bot.makeMoveFunction("down"))
  dispatcher:listen("bot.up", bot.makeMoveFunction("up"))
  
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