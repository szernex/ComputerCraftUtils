-- ---------------------------
-- Free to copy and modify
-- ALWAYS INCLUDE THIS HEADER
-- (c) Szernex 2014
-- ---------------------------

function split(text, delimiter)
  local output = {}
  local pattern = "(.-)" .. delimiter .. "()"
  local start, stop, content, newstart = 1, 1, nil, 1

  if string.find(text, delimiter) == nil then
    return {text}
  end

  text = text .. delimiter

  while newstart ~= nil and newstart < #text do
    start, stop, content, newstart = string.find(text, pattern, newstart)
    table.insert(output, content)
  end

  return output
end

function comparePeripheralNames(s1, s2)
  _, _, name1, id1 = string.find(s1, "^(.+)_(%d+)$")
  _, _, name2, id2 = string.find(s2, "^(.+)_(%d+)$")

  assert(name1 ~= nil)
  assert(name2 ~= nil)
  assert(id1 ~= nil)
  assert(id2 ~= nil)

  id1 = tonumber(id1)
  id2 = tonumber(id2)

  if string.lower(name1) == string.lower(name2) then
    return id1 < id2
  else
    return name1 < name2
  end
end