# fx_robbery
 
I decided to release this since I couldnt find a similar resource for free.


#### **Features:**
**Configurable Robbery Mechanics:**

* **Distance to Marker:** Players can start a robbery when they are within a defined distance from the robbery marker (default: 2.0 meters).
* **Required Cops:** Set the minimum number of cops required online to initiate a robbery (default: 0 cops). This feature can be disabled by setting the value to 0.
* **Robbery Cooldown:** After a successful robbery, a cooldown period of 2000 seconds is applied before another robbery can be attempted. Set to 0 to disable the cooldown entirely.
* **Police Signal Time:** When a robbery starts, an alert will be shown to the police for a configurable duration (default: 60 seconds).
* **Police Jobs:** Robbery notifications and participation are limited to specific job roles. 
**Customizable Locations:**

* **Shops Configuration:** Add and configure different shops and gas stations where robberies can occur. Each location has customizable attributes:
  * **Name:** The display name of the shop or gas station.
  * **Coordinates:** Coordinates where the robbery marker will be placed.
  * **Robbery Time:** Time (in seconds) required to complete the robbery.
  * **Reward:** Cash reward given to the player upon successful robbery.
  * **Distance:** Maximum distance (in meters) the player can be from the marker while the robbery is in progress.

**Weapon Restrictions:**

* **Allowed Weapons:** Players must have one of the allowed weapons in hand to start a robbery. 

**Translations:**

* Notifications and messages used during gameplay:
  


#### **Preview:**

https://www.youtube.com/watch?v=ObeHOtFyS6E
[OUTDATED]



#### **Download:**






#### **Example Configuration:**

```
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


```

#### **Changelog:**


```
Version: 1.0.0 
Initial Release

Version 1.0.1
Added AlertPolice function in Server.lua
Changed Name of ServerCallback

Version 1.0.2
Added Police Signal System
Added Config for mutliple police jobs
Added Config for Duration of Police Signal
Added Possibilty to change Notification translations in Config

```

#### **Installation:**

1. Download the script files from the repository.
2. Place the script in your FiveM server's resources directory.
3. Add `start [script_name]` to your server's `server.cfg` file.
4. Restart your server and configure the script settings as desired.

Enhance your server's roleplay with this robust robbery script and bring thrilling heists to your gameplay! Download now and start robbing!
