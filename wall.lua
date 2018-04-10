return function()
  local wall = {
    state = "solid"
  }
  
  wall.draw = function(self)
    love.graphics.print("wall", 0, 20)
  end
  
  return wall
end