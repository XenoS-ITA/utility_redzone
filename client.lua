DevMode(false)

local options = {
    rgb = {255, 0, 0},
}

Citizen.CreateThread(function()
    for marker_id,v in pairs(Config.RedZone) do 
        options.scale = vector3(v.Size, v.Size, 150.0)

        CreateMarker(marker_id, v.Coords, v.Size + 50.0, 0.0, options)

        if v.Blip.Active then
            CreateBlip(marker_id, v.Coords, v.Blip.Sprite, v.Blip.Colour, v.Blip.Scale)
        end

        if v.Weapon ~= "" then
            v.Weapon = GetHashKey(v.Weapon)
        end
    end
end)

local ped = PlayerPedId()

CreateLoop(function()
    local founded = false

    for marker_id,v in pairs(Config.RedZone) do 
        if GetDistanceFrom("marker", marker_id) < v.Size/2 then
            LoopThread("playerped", 500, function()
                ped = PlayerPedId()
            end)

            if not v.CanUseVehicle then
                LoopThread("vehicle_check", 1000, function()
                    local veh = GetVehiclePedIsIn(ped)
    
                    if veh ~= 0 then
                        DeleteEntity(veh)
                        ShowNotification(Config.Notify["no_vehicle"])
                    end
                end)
            end
    
            if v.NoHs then
                SetPedSuffersCriticalHits(PlayerPedId(), false)
            else
                SetPedSuffersCriticalHits(PlayerPedId(), true)
            end

            if v.Weapon ~= "" then
                LoopThread("weapon", 500, function()
                    if v.UnlimitedAmmo then
                        SetPedInfiniteAmmoClip(ped, true)
                    else
                        SetPedInfiniteAmmoClip(ped, false)
                    end
    
                    if GetSelectedPedWeapon(ped) ~= v.Weapon then
                        if HasPedGotWeapon(ped, v.Weapon, false) then
                            ShowNotification(Config.Notify["on_weapon_change"])
                            SetCurrentPedWeapon(ped, v.Weapon, true)
                        else
                            ShowNotification(Config.Notify["no_weapon"])
                            GiveWeaponToPed(ped, v.Weapon, 250, false, true)
                        end
                    end
                end)
            end
    
            if v.OnlyHS then
                local _, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
    
                if entity ~= 0 then
                    if HasEntityBeenDamagedByWeapon(entity, GetSelectedPedWeapon(ped), 0) then
                        if GetEntityHealth(entity) ~= 0 then
                            if GetEntityHealth(entity) ~= 200 and GetEntityHealth(entity) ~= 150 then
                                TriggerSyncedEvent("utility_redzone:Heal", GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity)))
                            end
                        end
                    end
                end
            end

            founded = true
            break
        end
    end

    if not founded then
        Citizen.Wait(500)
    end
end)

RegisterNetEvent("utility_redzone:Heal", function()
    SetEntityHealth(PlayerPedId(), 200)
end)