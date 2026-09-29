Config = {}

-- 'auto' detects qb-core or es_extended. You can force 'qb' or 'esx'.
Config.Framework = 'auto'

-- 'ox' if you use ox_inventory, otherwise 'default'
Config.Inventory = 'default'

-- QBCore only: player must also be on duty to use the weapon
Config.RequireOnDuty = false

-- How often (ms) to check the weapon in hand. Lower = faster block.
Config.CheckInterval = 100

-- Message shown to players who are not allowed
Config.Message = 'You cannot use this weapon.'

--[[
    RESTRICTED WEAPONS
    Key   = weapon hash (use backticks `WEAPON_NAME` or a number like 0x83BF0278)
    Value = list of jobs allowed to use it

    Any weapon NOT in this list can be used by everyone.
]]
Config.RestrictedWeapons = {
    [`WEAPON_CARBINERIFLE`]  = { 'police', 'sheriff' },
    [`WEAPON_PUMPSHOTGUN`]   = { 'police', 'sheriff' },
    [`WEAPON_STUNGUN`]       = { 'police', 'sheriff', 'ambulance' },
    [`WEAPON_NIGHTSTICK`]    = { 'police' },
    [`WEAPON_COMBATPISTOL`]  = { 'police' },

    -- Example using a raw hash number:
    -- [0x83BF0278] = { 'police' },
}
