return function (dispatcher, eventLog, library)
  return function(levelNum)
    dispatcher:flush()
    eventLog:flush()
    eventLog:register()
    return require ("levels/" .. levelNum)(dispatcher, library)
  end
end