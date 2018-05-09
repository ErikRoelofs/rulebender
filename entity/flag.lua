return function(objectFactory, id)
  
  local flag = objectFactory(id)
    :thatIsSolid()
    :thatCanBeDrawn(function(self)
      love.graphics.print("flag!", 0, 20)
    end)
    :go()
  

  flag:addType("flag")
  
  return flag
end