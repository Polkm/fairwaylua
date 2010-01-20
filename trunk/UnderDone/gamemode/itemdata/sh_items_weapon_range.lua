local Item = DeriveTable(BaseWeapon)
Item.Name = "pistol"
Item.PrintName = "Pistol"
Item.Desc = "Pasively gives you a pistol"
Item.Icon = "icons/weapon_pistol"
Item.Model = {}
Item.Model[1] = {Model = "models/Weapons/W_pistol.mdl", Position = Vector(-3, 0, 3.5), Angle = Angle(0, 180, 0)}
Item.Model[2] = {Model = "models/props_junk/garbage_metalcan001a.mdl", Position = Vector(0, 0, -7.2), Angle = Angle(90, 0, 0)}
Item.Dropable = true
Item.Giveable = true
Item.SellPrice = 25
Item.Weight = 1
Item.HoldType = "pistol"
Item.AmmoType = "smg1"
Item.Power = 9
Item.Accuracy = 0.01
Item.FireRate = 1.5
Item.ClipSize = 9
Item.Sound = "weapons/pistol/pistol_fire2.wav"
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "shotgun"
Item.PrintName = "Shotgun"
Item.Desc = "Pasively gives you a shotgun"
Item.Icon = "icons/weapon_shotgun"
Item.Model = {}
Item.Model[1] = {Model = "models/Weapons/W_shotgun.mdl", Position = Vector(-15, 2, 0), Angle = Angle(15, 180, 0)}
Item.Dropable = true
Item.Giveable = true
Item.SellPrice = 50
Item.Weight = 3
Item.HoldType = "shotgun"
Item.AmmoType = "buckshot"
Item.NumOfBullets = 8
Item.Power = 1
Item.Accuracy = 0.1
Item.FireRate = 1
Item.ClipSize = 4
Item.Sound = "weapons/shotgun/shotgun_fire6.wav"
Register.Item(Item)
