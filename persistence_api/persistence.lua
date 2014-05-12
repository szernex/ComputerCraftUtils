-- ---------------------------
-- Free to copy and modify
-- ALWAYS INCLUDE THIS HEADER
-- (c) Szernex 2014
-- ---------------------------

local FileName = nil
local FileHandle = nil
local Variables = {}


local function serializeTable(t)
  for k, v in pairs(t) do
    if type(v) == "table" then
      v = serializeTable(v)
    end
  end

  return textutils.serialize(t)
end

local function unserializeTable(tablestring)
  local t = textutils.unserialize(tablestring)

  if t == nil then
    return {}
  end

  for k, v in pairs(t) do
    if type(v) == "string" then
      local match = string.match(v, "^\{.*\}$")

      if match ~= nil then
        v = unserializeTable(v)
      end
    end
  end

  return t
end


function setFile(filename)
  assert(filename ~= nil)

  if not fs.exists(filename) then
    FileHandle = fs.open(filename, "w")
  else
    FileHandle = fs.open(filename, "r")
  end

  assert(FileHandle ~= nil)
  FileHandle.close()
  FileName = filename
end

function save()
  assert(FileName ~= nil)
  FileHandle = fs.open(FileName, "w")
  FileHandle.write(serializeTable(Variables))
  FileHandle.close()
end

function load()
  assert(FileName ~= nil)
  FileHandle = fs.open(FileName, "r")
  data = FileHandle.readAll()
  FileHandle.close()

  Variables = unserializeTable(data)
end


function set(variable, value)
  assert(type(value) ~= "function")
  Variables[variable] = value
  save()
end

function get(variable)
  return Variables[variable]
end