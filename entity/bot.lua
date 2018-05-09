return function(objectFactory, id)
  
  local bot = objectFactory(id)
    :thatIsSolid()
    :thatCanBeDrawn(function(self)
      if not self.dead then
        love.graphics.print("bot!", 0, 20)
        if self.moving then
          love.graphics.print("M", 0, 30)
        end
      else
        love.graphics.print("dead bot :(", 0, 20)
      end
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
  
  bot.dead = false
  local deregAll = {}
  
  table.insert( deregAll, bot.dispatcher:listen("bot.left", bot.makeMoveFunction("left")))
  table.insert( deregAll, bot.dispatcher:listen("bot.right", bot.makeMoveFunction("right")))
  table.insert( deregAll, bot.dispatcher:listen("bot.down", bot.makeMoveFunction("down")))
  table.insert( deregAll, bot.dispatcher:listen("bot.up", bot.makeMoveFunction("up")))
  
  table.insert( deregAll, bot.dispatcher:listen("bot.death", function(event)
    for _, f in ipairs(deregAll) do f() end
    bot.dead = true
  end))
  
  table.insert( deregAll, bot.dispatcher:listen("object.moving", function(event)
    if event.object == bot then
      bot.moving = true
    end
  end))
  
  table.insert( deregAll, bot.dispatcher:listen("object.arrived", function(event)
    if event.object == bot then
      bot.moving = false
    end
  end))

  bot:addType("bot")
  
  return bot
end