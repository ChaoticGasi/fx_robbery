ESX = exports["es_extended"]:getSharedObject()

local robberyInProgress = false
local currentRobbery = nil
local lastMarkerUpdate = 0


Citizen.CreateThread(function()
    local sleepTime = 1000

    while true do
        Citizen.Wait(sleepTime)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local isNearShop = false
        
        for _, shop in ipairs(Config.Shops) do
            local distance = GetDistanceBetweenCoords(playerCoords, shop.coords.x, shop.coords.y, shop.coords.z, true)

            
            if distance < 50.0 then
                DrawMarker(1, shop.coords.x, shop.coords.y, shop.coords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 0, 0, 100, false, true, 2, nil, nil, false)
                
                
                if distance < Config.DistanceToMarker then
                    isNearShop = true
                    sleepTime = 0 -- 
                    ESX.ShowHelpNotification(Config.HelpNotification)
                    
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback('fx_robbery:canRob', function(canRob, cooldownTime)
                            if canRob then
                                StartRobbery(shop)
                            else
                                local remainingTime = math.ceil(cooldownTime)
                                ESX.ShowNotification(string.format(Config.Cooldown, remainingTime))
                            end
                        end, shop.coords)
                    end
                end
            end
        end
        
        if not isNearShop then
            sleepTime = 1000 
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000) 

        if robberyInProgress and currentRobbery then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = GetDistanceBetweenCoords(playerCoords, currentRobbery.coords.x, currentRobbery.coords.y, currentRobbery.coords.z, true)

            if distance > currentRobbery.distance then
                EndRobbery(false)
            end
        end
    end
end)


function StartRobbery(shop)
    local playerPed = PlayerPedId()
    local weaponHash = GetSelectedPedWeapon(playerPed)


    if not IsWeaponAllowed(weaponHash) then
        ESX.ShowNotification(Config.Weapon)
        return
    end

    if CanStartRobbery() then

    robberyInProgress = true
    currentRobbery = shop

    ESX.ShowNotification(Config.RobberyStarterd .. shop.robberyTime .. Config.Seconds)
    TriggerEvent('startCountdown', shop.robberyTime)
    TriggerServerEvent('fx_robbery:startRobbery', shop.coords)

    
    Citizen.CreateThread(function()
        local startTime = GetGameTimer() 
        local endTime = startTime + (shop.robberyTime * 1000)

        while robberyInProgress and GetGameTimer() < endTime do
            Citizen.Wait(1000) 

            if not currentRobbery then

                return
            end

            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = GetDistanceBetweenCoords(playerCoords, currentRobbery.coords.x, currentRobbery.coords.y, currentRobbery.coords.z, true)

            if distance > currentRobbery.distance then

                EndRobbery(false)
                return
            end


        end


        if robberyInProgress then
            ESX.ShowNotification(Config.Sucess .. (currentRobbery.reward))
            TriggerServerEvent('fx_robbery:reward', currentRobbery.reward)
            EndRobbery(true)
        end
    end)
else 
    ESX.ShowNotification(Config.NoCops)
end
end


function EndRobbery(success)
    robberyInProgress = false
    currentRobbery = nil 

    if success then
        return
    else
        ESX.ShowNotification(Config.Failed)
    end


end


function CanStartRobbery()
    local copsOnline = 0
    ESX.TriggerServerCallback('fx_robbery:getCopsOnline', function(amount)
        copsOnline = amount
    end)

    Citizen.Wait(500)
    return copsOnline >= Config.RequiredCops and not robberyInProgress
end


function IsWeaponAllowed(weapon)
    for _, allowedWeapon in ipairs(Config.AllowedWeapons) do
        if weapon == GetHashKey(allowedWeapon) then
            return true
        end
    end
    return false
end



RegisterNetEvent('fx_robbery:NotifyPolice')
AddEventHandler('fx_robbery:NotifyPolice', function(coords)
    Citizen.CreateThread(function()
        local x, y, z = coords.x, coords.y, coords.z
        local streetHash  = GetStreetNameAtCoord(x, y, z)
        local streetName = GetStreetNameFromHashKey(streetHash)


        ESX.ShowNotification(Config.PoliceSignal .. (streetName))
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 161)          
        SetBlipScale(blip, 1.5)           
        SetBlipColour(blip, 1)            
        SetBlipAsShortRange(blip, false)  
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Police Alert")
        EndTextCommandSetBlipName(blip)

 
        local radiusBlip = AddBlipForRadius(coords.x, coords.y, coords.z, 100.0) 
        SetBlipColour(radiusBlip, 1)       
        SetBlipAlpha(radiusBlip, 128)      

      
        local timeToShow = Config.PoliceSignalTime * 1000 
        Citizen.Wait(timeToShow)


        RemoveBlip(blip)
        RemoveBlip(radiusBlip)
    end)
end)