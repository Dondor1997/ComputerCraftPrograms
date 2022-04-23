local function savePosition()
    local x, y, z = gps.locate()
    file = fs.open("./pos.txt", "w")
    file.write(string.format("%s\n%s\n%s", x, y, z))
    file.close()
end

local function readPosition()
    file = fs.open("./pos.txt", "w")
    x = file.readLine()
    y = file.readLine()
    z = file.readLine()
    return x, y, z
end

savePosition()
print(readPosition())
