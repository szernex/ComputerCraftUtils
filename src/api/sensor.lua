-- ---------------------------
-- Licensed under the MIT License (MIT)
-- Copyright (c) 2014 Szernex
-- ---------------------------

-- VARIABLES
local Sensor = nil
local ScannedPlayers = {}


-- LOCAL FUNCTIONS

-- PUBLIC FUNCTIONS
function setSensor(sensorname)
  assert(peripheral.getType(sensorname) == "openperipheral_sensor", "Peripheral " .. sensorname .. " is not a Sensor")
  Sensor = peripheral.wrap(sensorname)
end

function getSensor()
  return Sensor
end

function scan(enter_callback, leave_callback)
  local inrange = Sensor.getPlayerNames()
  local temp = {}

  -- look if a player entered the scan range
  for i = 1, #inrange do
    local player = inrange[i]

    temp[player] = 0

    if ScannedPlayers[player] == nil then
      local data = Sensor.getPlayerData(player)

      ScannedPlayers[player] = data

      assert(type(enter_callback) == "function" or enter_callback == nil, "enter_callback is not a function")
      if enter_callback ~= nil then
        enter_callback(data)
      end
    end
  end

  -- look if a player left the scan range and remove them
  local toremove = {}

  for player, data in pairs(ScannedPlayers) do
    local remove = false

    if temp[player] == nil then
      assert(type(leave_callback) == "function" or leave_callback == nil, "leave_callback is not a function")
      if leave_callback ~= nil then
        leave_callback(data)
      end

      ScannedPlayers[player] = false
      remove = true
    end

    if remove then
      table.insert(toremove, player)
    end
  end

  for i = 1, #toremove do
    ScannedPlayers[toremove[i]] = nil
  end

  return inrange
end