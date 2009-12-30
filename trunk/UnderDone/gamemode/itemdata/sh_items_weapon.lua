local Item = DeriveTable(BaseWeapon)
Item.Name = "pistol"
Item.PrintName = "Pistol"
Item.Desc = "Pasively gives you a pistol"
Item.Icon = "icons/weapon_pistol"
Item.Model = {}
Item.Model[1] = {Model = "models/Weapons/W_pistol.mdl", Position = Vector(1.5, 5, 3.5), Angle = Angle(0, 180, 0)}
Item.Model[2] = {Model = "models/props_junk/garbage_metalcan001a.mdl", Position = Vector(6, 0, 0), Angle = Angle(90, 0, 0)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 3
Item.HoldType = "pistol"
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "shotgun"
Item.PrintName = "Shotgun"
Item.Desc = "Pasively gives you a shotgun"
Item.Icon = "icons/weapon_shotgun"
Item.Model = {}
Item.Model[1] = {Model = "models/Weapons/W_shotgun.mdl", Position = Vector(0, 17, 4), Angle = Angle(15, 180, 0)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 5
Item.HoldType = "shotgun"
Register.Item(Item)