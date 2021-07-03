Config = {}

-- https://wiki.gtanet.work/index.php?title=Blips
Config.RedZone = {
    ["Only Carbine"] = {
        Blip = {
            Sprite = 84,
            Colour = 1,
            Scale  = 1.0,
            Active = true
        },
        Coords        = vector3(-257.8, -978.74, 30.22),
        Size          = 60.0,

        Weapon        = "WEAPON_CARBINERIFLE", -- Set it to "" to disable it
        CanUseVehicle = false,
        OnlyHS        = false,
        NoHs          = false,
        UnlimitedAmmo = false,
    }
}

Config.Notify = {
    ["no_vehicle"]       = "~r~You cannot use vehicles in this RedZone!",
    ["on_weapon_change"] = "~r~You can't use other weapons!",
    ["no_weapon"]        = "~r~You don't have the weapon to be able to play in this RedZone, so you won't be able to shoot!",
}
