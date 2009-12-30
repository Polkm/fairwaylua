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
Item.Power = 8
Item.Accuracy = 0.01
Item.FireRate = 2
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "Frying Pan"
Item.PrintName = "Frying Pan"
Item.Desc = "Frying Pan :D"
Item.Icon = "icons/weapon_pistol"
Item.Model = {}
Item.Model[1] = {Model = "models/props_interiors/pot02a.mdl", Position = Vector(1.5, 6, 6.5), Angle = Angle(150, 180, 270)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 3
Item.HoldType = "melee"
Item.Power = 8
Item.FireRate = 3
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
Item.NumOfBullets = 8
Item.Power = 1
Item.Accuracy = 0.1
Item.FireRate = 1
Register.Item(Item)