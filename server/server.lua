ESX = exports['es_extended']:getSharedObject()


local robberyCooldowns = {}


ESX.RegisterServerCallback('fx_robbery:getCopsOnline', function(source, cb)
    local xPlayers = ESX.GetPlayers()
    local copsOnline = 0

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if Config.PoliceJobs[xPlayer.getJob().name] then
            copsOnline = copsOnline + 1
        end
    end

    cb(copsOnline)

end)


ESX.RegisterServerCallback('fx_robbery:canRob', function(source, cb, coords)

    if robberyCooldowns[coords] then
        local remainingTime = robberyCooldowns[coords] - os.time()

        cb(false, remainingTime) 
    else
        cb(true, 0) 
    end
end)


RegisterNetEvent('fx_robbery:startRobbery')
AddEventHandler('fx_robbery:startRobbery', function(coords)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    

    StartRobberyCooldown(coords)
    TriggerEvent("fx_robbery:AlertPolice", coords)


end)


function StartRobberyCooldown(coords)

    robberyCooldowns[coords] = os.time() + Config.RobberyCooldown

 
    Citizen.CreateThread(function()
        Citizen.Wait(Config.RobberyCooldown * 1000)

        robberyCooldowns[coords] = nil
    end)
end


RegisterNetEvent('fx_robbery:AlertPolice')
AddEventHandler('fx_robbery:AlertPolice', function(coords)
    local xPlayers = ESX.GetPlayers()

    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer and Config.PoliceJobs[xPlayer.getJob().name] then
            TriggerClientEvent('fx_robbery:NotifyPolice', xPlayer.source, coords)
        end
    end
end)


RegisterServerEvent('fx_robbery:reward')
AddEventHandler('fx_robbery:reward', function(reward)
    local xPlayer = ESX.GetPlayerFromId(source)

        xPlayer.addMoney(reward)

end)
