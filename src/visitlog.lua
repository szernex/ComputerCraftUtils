-- ---------------------------
-- Licensed under the MIT License (MIT)
-- Copyright (c) 2014 Szernex
-- ---------------------------

os.loadAPI("sensor")

-- ARGUMENT HANDLING
local Args = {...}

if #Args ~= 2 then
  print("Usage: VisitLog <sensor_name> <logfile>")
  return
end

local SensorName = Args[1]
local LogFile = Args[2]


-- FUNCTIONS
local function onEnter(data)
  writeLog(string.format("%s entered", data.username))
end

local function onLeave(data)
  writeLog(string.format("%s left", data.username))
end

function getTimestamp()
  return textutils.formatTime(os.time(), true)
end

function writeLog(text)
  local f = fs.open(LogFile, "a")
  local output = string.format("%s | %s", getTimestamp(), text)

  f.writeLine(output)
  f.close()
  print(output)
end


-- INITIALIZATION
sensor.setSensor(SensorName)

if not fs.exists(LogFile) then
  local f = fs.open(LogFile, "w")

  f.close()
end


while true do
  sensor.scan(onEnter, onLeave)
  sleep(3)
end