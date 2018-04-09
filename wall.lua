return function()
  local wall = {
    state = "impassable"
  }
  
  wall.draw = function(self)
    love.graphics.print("wall", 0, 20)
  end
  
  return wall
end