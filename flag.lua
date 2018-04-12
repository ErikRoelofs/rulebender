return function(objectFactory)
  
  local flag = objectFactory()
    :thatIsSolid()
    :thatCanBeDrawn(function(self)
      love.graphics.print("flag!", 0, 20)
    end)
    :go()
  

  flag:addType("flag")
  
  return flag
end