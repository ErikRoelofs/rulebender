return function(objectFactory, id, direction, speed)
  impacterF = require ("entity/impacter")
  return impacterF(
    objectFactory,
    id,
    direction,
    speed,
    function(self)
      love.graphics.setColor(0,1,1,1)
      love.graphics.print("pull!", 25, 25)
      love.graphics.setColor(1,1,1,1)
    end,
    function(impacter, other, direction, speed)
      return {
        name = "object.pushed",
        object = other,
        direction = inverseDirection(direction),
        speed = 1
      }
    end
  )
end