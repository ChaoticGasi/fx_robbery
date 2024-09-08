ESX = exports['es_extended']:getSharedObject()


local robberyCooldowns = {}
local onlineCops = {
    count = 0,
    players = {},
}

local robberyPlayerList = {}

local function removeFromTable(t, value)
    for i, v in ipairs(t) do
        if v == value then
            table.remove(t, i)
            break
        end
    end
    return t
end


RegisterNetEvent('esx:playerLoaded', function(player, xPlayer)
    local xJob = xPlayer.getJob().name

    if Config.PoliceJobs[xJob] then
        onlineCops.count = onlineCops.count + 1
        table.insert(onlineCops.players, xPlayer.source)
    end
end)

RegisterNetEvent('esx:playerDropped', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)

    if Config.PoliceJobs[xPlayer.getJob().name] then
        onlineCops.count = math.max(0, onlineCops.count - 1)
        onlineCops.players = removeFromTable(onlineCops.players, xPlayer.source)
    end
end)

RegisterNetEvent('esx:setJob', function(player, job, lastJob)
    local xPlayer = ESX.GetPlayerFromId(player)
    local newJobPolice = Config.PoliceJobs[job.name]
    local lastJobPolice = Config.PoliceJobs[lastJob.name]

    if lastJobPolice and newJobPolice then return end

    if newJobPolice then
        onlineCops.count = onlineCops.count + 1
        table.insert(onlineCops.players, xPlayer.source)
    elseif lastJobPolice then
        onlineCops.count = math.max(0, onlineCops.count - 1)
        onlineCops.players = removeFromTable(onlineCops.players, xPlayer.source)
    end
end)



ESX.RegisterServerCallback('fx_robbery:getCopsOnline', function(source, cb)
    cb(onlineCops.count)
end)


ESX.RegisterServerCallback('fx_robbery:canRob', function(source, cb, coords)
    local xPlayer = ESX.GetPlayerFromId(source)

    if not robberyPlayerList[xPlayer.source] then
        if not robberyCooldowns[coords] then
            cb(true, 0)
            return
        end

        local remainingTime = robberyCooldowns[coords] - os.time()
        cb(false, remainingTime)
        return
    end

    cb(false, 9999)
end)


local function getDataFromCoords(coords)
    for i=1, #Config.Shops, 1 do
        if Config.Shops[i].coords == coords then
            return Config.Shops[i]
        end
    end
end

RegisterNetEvent('fx_robbery:startRobbery')
AddEventHandler('fx_robbery:startRobbery', function(coords)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    if robberyPlayerList[xPlayer.source] then return end
    local cfg = getDataFromCoords(coords)

    robberyPlayerList[xPlayer.source] = {coords = coords, inRobbery = true, startTime = os.time(), endTime = os.time() + cfg.robberyTime}
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
    for i=1, #onlineCops.players, 1 do
        local xPlayer = ESX.GetPlayerFromId(onlineCops.players[i])
        TriggerClientEvent('fx_robbery:NotifyPolice', xPlayer.source, coords)
    end
end)


RegisterServerEvent('fx_robbery:reward')
AddEventHandler('fx_robbery:reward', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end
    
    local playerData = robberyPlayerList[xPlayer.source]
    if not playerData or playerData.inRobbery ~= true then return end

    if os.time() < playerData.endTime then
        print("Cheating attempt detected: Player tried to claim reward before robbery end time.")
        return
    end

    xPlayer.addMoney(Config.Shops[playerData.coords].reward)
    robberyPlayerList[xPlayer.source] = nil
end)

-- new:

RegisterNetEvent('fx_robbery:robberyStatus')
AddEventHandler('fx_robbery:robberyStatus', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if robberyPlayerList[xPlayer.source] then
        robberyPlayerList[xPlayer.source] = nil
    end
end)
