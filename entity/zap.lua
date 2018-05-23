return function(objectFactory, id, direction, speed)
  impacterF = require ("entity/impacter")
  return impacterF(
    objectFactory,
    id,
    direction,
    speed,
    function(self)
      love.graphics.setColor(0,1,1,1)
      love.graphics.print("ZAP!", 25, 25)
      love.graphics.setColor(1,1,1,1)
    end,
    function(impacter, target, direction, speed)
      return {
        name = "signal",
        object = impacter,
        direction = direction,
        impactSignal = true
      }
    end
  )
end