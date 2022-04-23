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
            return false
        end
    end
    return true
end

local function mineVein()

end

local function returnToStart()

end

local function refuel()
    local fuelLevel = turtle.getFuelLevel()
    if fuelLevel == "unlimited" or fuelLevel > 0 then
        return
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
    return false
end
