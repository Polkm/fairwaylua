local Item = DeriveTable(BaseWeapon)
Item.Name = "pistol"
Item.PrintName = "Pistol"
Item.Desc = "Pasively gives you a pistol"
Item.Icon = "icons/weapon_pistol"
Item.Model = "models/Weapons/W_pistol.mdl"
Item.Dropable = true
Item.Giveable = true
Item.Weight = 3
Item.Weapon = "weapon_pistol"
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "shotgun"
Item.PrintName = "Shotgun"
Item.Desc = "Pasively gives you a shotgun"
Item.Icon = "icons/weapon_shotgun"
Item.Model = "models/Weapons/W_shotgun.mdl"
Item.Dropable = true
Item.Giveable = true
Item.Weight = 5
Item.Weapon = "weapon_shotgun"
Register.Item(Item)