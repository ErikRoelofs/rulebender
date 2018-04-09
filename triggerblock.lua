return function(dispatcher, effect)
  local block = {
    effect = effect,
    respondsTo = {}
  }
  dispatcher:listen("inputblock.pulse", function(event)
    for _, innerBlock in ipairs(block.respondsTo) do
      print(innerBlock)
      if innerBlock == event.value then
        block.effect()
      end
    end
  end)
  block.respondTo = function(self, inputblock)
    print(inputblock)
    table.insert(block.respondsTo, inputblock)
  end
  return block
end