-- Configurations
local useMPH = true -- Set to true for MPH, false for KPH
local speedLimit = nil
local inSpeedZone = nil
local currentZone = nil


local speedZones = {
    {name = "Paleto", coords = vector3(-150.0, 6200.0, 30.0), radius = 1000.0, maxSpeedKPH = 150, maxSpeedMPH = 150},
    {name = "Sandy Shores", coords = vector3(1700.0, 3600.0, 35.0), radius = 800.0, maxSpeedKPH = 120, maxSpeedMPH = 150}
}

local function convertSpeed(speed)
    return useMPH and speed / 2.23694 or speed / 3.6
end


RegisterCommand("limitspeed", function(source, args)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local playerCoords = GetEntityCoords(playerPed)
    local inZone = false
    

    for _, zone in ipairs(speedZones) do
        local distance = #(playerCoords - zone.coords)
        if distance < zone.radius then
            inZone = true
            break 
        end
    end

 
    if inZone and speedLimit then
        lib.notify({title = "Speed Limit Active", description = "You cannot remove the speed limit while in a speed zone.", type = "error"})
        return
    end

    if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == playerPed then
        if args[1] then
            local limit = tonumber(args[1])
            if limit and limit > 0 then
                speedLimit = convertSpeed(limit)
                lib.notify({title = "Speed Limit Set", description = "Your vehicle speed is limited to " .. args[1] .. (useMPH and " MPH" or " KPH"), type = "success"})
            else
                lib.notify({title = "Invalid Speed", description = "Please enter a valid speed.", type = "error"})
            end
        else

            if not inZone then
                speedLimit = nil
                lib.notify({title = "Speed Limit Removed", description = "Your speed limit has been removed.", type = "info"})
            else
                lib.notify({title = "Cannot Remove Speed Limit", description = "You cannot remove the speed limit while in a speed zone.", type = "error"})
            end
        end
    else
        lib.notify({title = "No Vehicle", description = "You must be driving a vehicle to set a speed limit.", type = "error"})
    end
end, false)


CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local playerCoords = GetEntityCoords(playerPed)
        local inZone = false
        local newZone = nil


        for _, zone in ipairs(speedZones) do
            local distance = #(playerCoords - zone.coords)
            if distance < zone.radius then
                inZone = true
                newZone = zone
                break 
            end
        end


        if inZone and newZone ~= currentZone then
            currentZone = newZone
            speedLimit = convertSpeed(useMPH and newZone.maxSpeedMPH or newZone.maxSpeedKPH)
            lib.notify({title = "Speed Zone Entered", description = "Speed limited to " .. (useMPH and newZone.maxSpeedMPH .. " MPH" or newZone.maxSpeedKPH .. " KPH") .. " in " .. newZone.name, type = "warning"})
        end


        if not inZone and currentZone then
            currentZone = nil
            speedLimit = nil
            lib.notify({title = "Speed Zone Left", description = "Speed limit removed.", type = "info"})
        end
        
        if vehicle and vehicle ~= 0 and speedLimit then
            local currentSpeed = GetEntitySpeed(vehicle)
            if currentSpeed > speedLimit then
                local velocity = GetEntityVelocity(vehicle)
                local speedFactor = speedLimit / currentSpeed
                SetEntityVelocity(vehicle, velocity.x * speedFactor, velocity.y * speedFactor, velocity.z)
            end
        end
        
        Wait(100)
    end
end)
