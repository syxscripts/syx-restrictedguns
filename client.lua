local Framework, Core
local lastNotify = 0

-- Detect framework
CreateThread(function()
    local fw = Config.Framework
    if fw == 'auto' then
        if GetResourceState('qb-core') == 'started' then
            fw = 'qb'
        elseif GetResourceState('es_extended') == 'started' then
            fw = 'esx'
        end
    end

    if fw == 'qb' then
        Core = exports['qb-core']:GetCoreObject()
    elseif fw == 'esx' then
        Core = exports['es_extended']:getSharedObject()
    else
        print('^1[job_weapons] No supported framework found (qb-core / es_extended).^0')
        return
    end
    Framework = fw
end)

-- Get the player's current job (name + duty)
local function GetJob()
    if Framework == 'qb' then
        local data = Core.Functions.GetPlayerData()
        if data and data.job then
            return data.job.name, data.job.onduty
        end
    elseif Framework == 'esx' then
        local data = Core.GetPlayerData()
        if data and data.job then
            return data.job.name, true
        end
    end
    return nil, false
end

local function Notify(msg)
    if GetGameTimer() - lastNotify < 3000 then return end -- anti-spam
    lastNotify = GetGameTimer()

    if Framework == 'qb' then
        Core.Functions.Notify(msg, 'error')
    elseif Framework == 'esx' then
        Core.ShowNotification(msg)
    end
end

local function CanUse(weaponHash)
    local allowed = Config.RestrictedWeapons[weaponHash]
    if not allowed then return true end -- not restricted

    local job, onDuty = GetJob()
    if not job then return false end

    for _, allowedJob in ipairs(allowed) do
        if job == allowedJob then
            if Config.RequireOnDuty and Framework == 'qb' and not onDuty then
                return false
            end
            return true
        end
    end
    return false
end

-- Put the weapon away (it stays in the inventory)
local function Holster(ped, weaponHash)
    if Config.Inventory == 'ox' then
        TriggerEvent('ox_inventory:disarm', true)
    else
        SetCurrentPedWeapon(ped, `WEAPON_UNARMED`, true)
        if Framework == 'qb' then
            -- qb-inventory gives the weapon on use, so removing it from the ped
            -- does NOT remove the item from the inventory
            RemoveWeaponFromPed(ped, weaponHash)
        end
    end
end

-- Main check loop
CreateThread(function()
    while true do
        local sleep = 500
        if Framework then
            local ped = PlayerPedId()
            local weapon = GetSelectedPedWeapon(ped)

            if weapon ~= `WEAPON_UNARMED` and Config.RestrictedWeapons[weapon] then
                sleep = Config.CheckInterval
                if not CanUse(weapon) then
                    DisablePlayerFiring(PlayerId(), true)
                    Holster(ped, weapon)
                    Notify(Config.Message)
                end
            end
        end
        Wait(sleep)
    end
end)
