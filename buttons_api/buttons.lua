-- ---------------------------
-- Licensed under the MIT License (MIT)
-- Copyright (c) 2014 Szernex
-- ---------------------------

local Buttons = {} -- {id, x, y, width, height, label, inactivecolor, activecolor, color, callback}
local Display = term


local function checkForButton(x, y)
  for k, button in pairs(Buttons) do
    if x >= button.x and y >= button.y and x <= (button.x + button.width - 1) and y <= (button.y + button.height - 1) then
      return button
    end
  end

  return nil
end

local function drawButtons()
  for k, button in pairs(Buttons) do

    -- draw background
    for x = button.x, button.x + button.width - 1 do
      for y = button.y, button.y + button.height - 1 do
        Display.setCursorPos(x, y)
        Display.setBackgroundColor(button.color)
        Display.write(" ")
      end
    end

    -- print centered label
    lines = {}
    label = button.label
    maxwidth = button.width - 2

    if string.len(label) > maxwidth then
      while string.len(label) > 0 do
        table.insert(lines, string.sub(label, 1, maxwidth))
        label = string.sub(label, maxwidth + 1)
      end
    else
      lines = {label}
    end

    while #lines > button.height do
      table.remove(lines, #lines)
    end

    centerx = button.x + (math.floor(button.width / 2) - math.floor(string.len(lines[1]) / 2))
    centery = button.y + (math.floor(button.height / 2) - math.floor(#lines / 2))

    for i = 1, #lines do
      Display.setCursorPos(centerx, centery + (i - 1))
      Display.write(lines[i])
    end
  end
end


function setDisplay(display)
  Display = display
end

function addButton(id, x, y, width, height, label, inactivecolor, activecolor, callback)
  for i = x, x + width - 1 do
    for j = y, y + height - 1 do
      if checkForButton(i, j) ~= nil then
        return false
      end
    end
  end

  Buttons[id] = {
    id = id,
    x = x,
    y = y,
    width = width,
    height = height,
    label = label,
    inactivecolor = inactivecolor,
    activecolor = activecolor,
    color = inactivecolor,
    callback = callback
  }

  return true
end

function removeButton(id)
  Buttons[id] = nil
end

function removeAllButtons()
  Buttons = {}
end

-- toggles the status of a button
function toggleButton(id, status)
  button = Buttons[id]

  if button == nil then
    return false
  end

  if status then
    button.color = button.activecolor
  else
    button.color = button.inactivecolor
  end

  drawButtons()

  return true
end

-- clears the screen and draws all buttons
-- optionally a callback method can be specified to be called afterwards
function refresh(callback)
  Display.setBackgroundColor(colors.black)
  Display.setCursorPos(1, 1)
  Display.clear()
  drawButtons()

  if callback ~= nil then
    callback()
  end
end

function mainLoop()
  while true do
    event, side, x, y = os.pullEvent("monitor_touch")

    button = checkForButton(x, y)

    if button ~= nil and button.callback ~= nil then
      button.callback(button)
    end
  end
end