return function (dispatcher, eventLog, objectFactory)
  return function(levelNum)
    dispatcher:flush()
    eventLog:flush()
    eventLog:register()
    return require ("levels/" .. levelNum)(dispatcher, objectFactory)
  end
end