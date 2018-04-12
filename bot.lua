return function(objectFactory)
  
  local bot = objectFactory()
    :thatIsSolid()
    :thatCanBeDrawn(function(self)
      love.graphics.print("bot!", 0, 20)
    end)
    :go()
  
  bot.moving = false
  bot.makeMoveFunction = function(direction)
    local event = {
      name = "move",
      object = bot,
      direction = direction,
      speed = 2
    }
    return function()
      if bot.moving then return end
      bot.dispatcher:dispatch(event)
    end
  end
  
  bot.dispatcher:listen("bot.left", bot.makeMoveFunction("left"))
  bot.dispatcher:listen("bot.right", bot.makeMoveFunction("right"))
  bot.dispatcher:listen("bot.down", bot.makeMoveFunction("down"))
  bot.dispatcher:listen("bot.up", bot.makeMoveFunction("up"))
  
  bot.dispatcher:listen("object.moving", function(event)
    bot.moving = true
  end)
  
  bot.dispatcher:listen("object.arrived", function(event)
    bot.moving = false
  end)

  bot:addType("bot")
  
  return bot
end