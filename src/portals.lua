-- ---------------------------
-- Licensed under the MIT License (MIT)
-- Copyright (c) 2014 Szernex
-- ---------------------------

os.loadAPI("buttons")


-- MODIFY AS NEEDED
-- gets called before a portal is opened
function onPortalOpen()

end

-- gets called after a portal is closed
function onPortalClosed()

end


-- ARGUMENT HANDLING
Args = {...}

if #Args ~= 5 then
  print("Usage: Portals <modem_side> <chest_name> <monitor_name> <receptacle_position (relative to chest)> <buttons_per_line>")
  return
end

ModemSide = Args[1]
ChestName = Args[2]
MonitorName = Args[3]
ReceptaclePos = Args[4]
ButtonsPerLine = tonumber(Args[5])

ButtonActiveColor = colors.gray
ButtonInactiveColor = colors.blue
ButtonHeight = 3
Books = {}


assert(peripheral.getType(ModemSide) == "modem", "No modem detected on " .. ModemSide)
Modem = peripheral.wrap(ModemSide)
assert(Modem.isPresentRemote(ChestName), "No chest named " .. ChestName .. " found")
Chest = peripheral.wrap(ChestName)
assert(Modem.isPresentRemote(MonitorName), "No monitor named " .. MonitorName .. " found")
Monitor = peripheral.wrap(MonitorName)
assert(Monitor.isColor(), "Monitor is not a touch screen")
assert(ButtonsPerLine > 0, "Invalid buttons per line count " .. tostring(ButtonsPerLine))


-- FUNCTIONS
-- returns a table of all books in format 'books[destination] = slot'
function getBooks()
  books = {}

  Chest.condenseItems()
  sleep(0.5)

  for i = 1, Chest.getInventorySize() do
    item = Chest.getStackInSlot(i)

    -- since we called condenseItems() it means we reached the end
    -- with the first empty slot
    if item == nil then
      break
    end

    if item.rawName == "item.myst.linkbook" then
      books[item.destination] = i
    end
  end

  return books
end

-- opens the portal for the book bookid
function openPortal(bookid)
  slot = Books[bookid]

  if slot == nil then
    return false
  end

  onPortalOpen()
  Chest.pushItem(ReceptaclePos, slot, 1, 1)

  return true
end

-- closes the portal
function closePortal()
  slot = 1

  Chest.condenseItems()

  for i = 1, Chest.getInventorySize() do
    if Chest.getStackInSlot(i) == nil then
      slot = i
      break
    end
  end

  Chest.pullItem(ReceptaclePos, 1, 1, slot)
  onPortalClosed()
  Books = getBooks()
end

-- callback for when refresh button is pressed
function refreshCallback(button)
  Monitor.setBackgroundColor(colors.black)
  Monitor.setCursorPos(1, 1)
  Monitor.clear()

  monitorwidth, monitorheight = Monitor.getSize()

  buttons.removeAllButtons()
  buttons.addButton("refresh", 2, 2, monitorwidth - 2, ButtonHeight, "Refresh portal list", ButtonInactiveColor, ButtonActiveColor, refreshCallback)


  Books = getBooks()
  sorted = {}
  buttonwidth = math.floor(((monitorwidth - ButtonsPerLine) - 1) / ButtonsPerLine)
  x = 2
  y = 10

  for k, v in pairs(Books) do
    table.insert(sorted, k)
  end

  table.sort(sorted)

  for i = 1, #sorted do
    buttons.addButton(sorted[i], x, y, buttonwidth, ButtonHeight, sorted[i], ButtonInactiveColor, ButtonActiveColor, linkCallback)
    x = x + buttonwidth + 1

    if x >= (ButtonsPerLine * buttonwidth) then
      x = 2
      y = y + ButtonHeight + 1
    end
  end

  buttons.refresh()
end

-- callback for when a link button is pressed
function linkCallback(button)
  buttons.toggleButton(button.id, true)
  openPortal(button.id)
  sleep(5)
  closePortal()
  buttons.toggleButton(button.id, false)
end


-- INITIALIZATION
Monitor.setTextScale(0.5)
closePortal()
buttons.setDisplay(Monitor)
refreshCallback(nil)
buttons.mainLoop()