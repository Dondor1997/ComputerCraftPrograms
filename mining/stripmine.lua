local config = {}
config["torch"] = false
config["stripDepth"] = 10
config["stripDistance"] = 3

local function savePosition()
    local x, y, z = gps.locate()
    file = fs.open("./pos.txt", "w")
    file.write(string.format("%s\n%s\n%s", x, y, z))
    file.close()
end

local function readPosition()
    file = fs.open("./pos.txt", "w")
    x = file.readLine()
    if x == nil then return nil end
    y = file.readLine()
    z = file.readLine()
    return x, y, z
end

local function tryDig()
    while turtle.detect() do
        if turtle.dig() then
            sleep(0.5)
        else
            print("Cannot dig forward")
            return false
        end
    end
    return true
end

local function tryDigUp()
    while turtle.detectUp() do
        if turtle.digUp() then
            sleep(0.5)
        else
            print("Cannot dig up")
            return false
        end
    end
    return true
end

local function tryDigDown()
    while turtle.detectDown() do
        if turtle.digDown() then
            sleep(0.5)
        else
            print("Cannot dig down")
            return false
        end
    end
    return true
end

local function tryRefuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" or fuelLevel > 0 then
        return true
    end
    for n=1, 16 do
        if turtle.getItemCount(n) > 0 then
            turtle.select(n)
            if turtle.refuel(1) then
                turtle.select(1)
                return true
            end
        end
    end
    turtle.select(1)
    print("No more fuel")
    return false
end

local function tryMove()
    tryRefuel()
    if turtle.detect() then 
        print("Something is blocking the way")
        return false 
    else
        turtle.forward()
        return true
    end
end

local function mineVein()

end

local function returnToStart()

end

local function checkFull()
    for n=1, 16 do
        if turtle.getItemCount(n) == 0 then return false end
    end
    return true
end

local function tryPlaceTorch()
    if not turtle.detectUp() then
        turtle.select(2)
        turtle.placeUp()
    end
end

local function digStrip()
    local stripDepth = 1
    turtle.turnLeft()
    while stripDepth < config["stripDepth"] do
        tryDig()
        if tryMove() then
            tryDigUp()
            tryDigDown()
        else 
            break
        end
        stripDepth = stripDepth + 1
    end
    if config["torch"] then
        tryPlaceTorch()
    end
    turtle.turnLeft()
    turtle.turnLeft()
    for n=2,stripDepth do
        tryMove()
    end
    stripDepth = 1
    while stripDepth < config["stripDepth"] do
        tryDig()
        if tryMove() then
            tryDigUp()
            tryDigDown()
        else 
            break
        end
        stripDepth = stripDepth + 1
    end
    if config["torch"] then
        tryPlaceTorch()
    end
    turtle.turnLeft()
    turtle.turnLeft()
    for n=2,stripDepth do
        tryMove()
    end
    turtle.turnRight()
end

local function emptyInventory(depth)
    turtle.turnLeft()
    turtle.turnLeft()
    for i = 1, depth do
        tryMove()
    end
    for n = 1, 16 do
        turtle.select(n)
        if not turtle.dropDown() then
            print("Target inventory is full")
            break
        end
    end
    turtle.select(1)
    turtle.suckDown()
    turtle.turnLeft()
    turtle.turnLeft()
    for i = 1, depth do
        tryMove()
    end
end

local function processArgs()
    local length
    if arg[1] then
        length = tonumber(arg[1])
    else
        length = 1000
    end
    return length
end

local function stripmine(length)
    depth = 1
    tryDigUp()
    turtle.up()
    while depth < length do
        tryDig()
        tryMove()
        tryDigUp()
        tryDigDown()
        if depth % config["stripDistance"] == 0 then
            digStrip()
        end
        depth = depth + 1
        if checkFull() then
            emptyInventory(depth)
        end
    end
end

stripmine(processArgs())
