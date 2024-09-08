Config = {}

Config.DistanceToMarker = 2.0 -- Distance within the player can start the robbery
Config.RequiredCops = 0 -- Minimum number of cops online required to start a robbery (set this to 0 to disable)
Config.RobberyCooldown = 2000 -- Cooldown time after a robbery in seconds (set this to 0 to disable)
Config.PoliceSignalTime = 60 -- Show the Robbery Alert for the police for 60 seconds (In seconds)
Config.PoliceJobs = { 
    ["police"] = true,
    ["sheriff"] = true,
    ["goverment"] = true
} -- Add as many Jobs as you like



Config.Shops = {
    {
        name = "24/7 Supermarket",
        coords = vector3(30.504777908325, -1339.9705810547, 29.497018814087), -- Example coordinates
        robberyTime = 50, -- Time in seconds to complete the robbery
        reward = 5000, -- Amount of cash the player receives
        distance = 10.0 -- Maximum distance player can be from the marker during the robbery
    },
    {
        name = "Groove Gas Station",
        coords = vector3(-44.302639007568, -1750.2902832031, 29.421020507812), -- Example coordinates
        robberyTime = 40, -- Time in seconds to complete the robbery
        reward = 2500, -- Amount of cash the player receives
        distance = 10.0 -- Maximum distance player can be from the marker during the robbery
    },
}


-- Robbery can only be started if the player has one of theese weapons in their hand
Config.AllowedWeapons = {
    "WEAPON_PISTOL",
    "WEAPON_COMBATPISTOL",
    "WEAPON_ASSAULTRIFLE"
}



-- Translations

Config.HelpNotification = "Press ~INPUT_CONTEXT~ to start the robbery"
Config.Cooldown = "This shop is under cooldown. Try again in %d seconds."
Config.Weapon = "You need to have a weapon in hand to start the robbery!"
Config.RobberyStarterd = "Robbery started! Stay near the marker for "
Config.Seconds = " seconds."
Config.Sucess = "Robbery successful! You got $"
Config.NoCops = "Not enough Cops online."
Config.Failed = "Robbery failed."
Config.PoliceSignal = "A Robbery has been started at "

