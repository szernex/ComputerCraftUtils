-- ---------------------------
-- Free to copy and modify
-- ALWAYS INCLUDE THIS HEADER
-- (c) Szernex 2014
-- ---------------------------

local MoveForward = turtle.forward
local MoveBack = turtle.back
local MoveUp = turtle.up
local MoveDown = turtle.down
local DigForward = turtle.dig
local DigBack = turnAroundAndDig
local DigUp = turtle.digUp
local DigDown = turtle.digDown
local AttackForward = turtle.attack
local AttackBack = turnAroundAndAttack
local AttackUp = turtle.attackUp
local AttackDown = turtle.attackDown

local function turnAroundAndDig()
  turtle.turnLeft()
  turtle.turnLeft()
  result = turtle.dig()
  turtle.turnLeft()
  turtle.turnLeft()

  return result
end

local function turnAroundAndAttack()
  turtle.turnLeft()
  turtle.turnLeft()
  result = turtle.attack()
  turtle.turnLeft()
  turtle.turnLeft()

  return result
end

local function checkFuel(distance)
  while turtle.getFuelLevel() < distance do
    print("Not enough fuel, please place fuel in slot 16...")
    turtle.select(16)
    turtle.refuel()
    sleep(5)
  end

  turtle.select(1)
end

local function move(movefunc, digfunc, attackfunc, beforefunc, afterfunc, distance)
  if distance == nil then
    distance = 1
  end

  checkFuel(distance)

  for i = 1, distance do
    if beforefunc ~= nil then
      beforefunc()
    end

    while movefunc() == false do
      if digfunc() == false and attackfunc() == false then
        print("I am stuck...")
        sleep(5)
      end
    end

    if afterfunc ~= nil then
      afterfunc()
    end
  end
end

function forward(distance, beforefunc, afterfunc)
  move(MoveForward, DigForward, AttackForward, beforefunc, afterfunc, distance)
end

function back(distance, beforefunc, afterfunc)
  move(MoveBack, DigBack, AttackBack, beforefunc, afterfunc, distance)
end

function up(distance, beforefunc, afterfunc)
  move(MoveUp, DigUp, AttackUp, beforefunc, afterfunc, distance)
end

function down(distance, beforefunc, afterfunc)
  move(MoveDown, DigDown, AttackDown, beforefunc, afterfunc, distance)
end

function left(distance, beforefunc, afterfunc)
  turtle.turnLeft()
  forward(distance, beforefunc, afterfunc)
end

function right(distance, beforefunc, afterfunc)
  turtle.turnRight()
  forward(distance, beforefunc, afterfunc)
end