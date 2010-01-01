local Item = DeriveTable(BaseWeapon)
Item.Name = "pistol"
Item.PrintName = "Pistol"
Item.Desc = "Pasively gives you a pistol"
Item.Icon = "icons/weapon_pistol"
Item.Model = {}
Item.Model[1] = {Model = "models/Weapons/W_pistol.mdl", Position = Vector(-3, 0, 3.5), Angle = Angle(0, 180, 0)}
Item.Model[2] = {Model = "models/props_junk/garbage_metalcan001a.mdl", Position = Vector(6, 0, 0), Angle = Angle(90, 0, 0)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.HoldType = "pistol"
Item.Power = 8
Item.Accuracy = 0.01
Item.FireRate = 2
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
Item.Weight = 3
Item.HoldType = "shotgun"
Item.NumOfBullets = 8
Item.Power = 1
Item.Accuracy = 0.1
Item.FireRate = 1
Item.Sound = "weapons/shotgun/shotgun_fire6.wav"
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "frying_pan"
Item.PrintName = "Frying Pan"
Item.Desc = "Frying Pan :D"
Item.Icon = "icons/junk_pan2"
Item.Model = {}
Item.Model[1] = {Model = "models/props_interiors/pot02a.mdl", Position = Vector(0.8, 8, -0.5), Angle = Angle(0, 0, 90)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.HoldType = "melee"
Item.Power = 8
Item.FireRate = 3
Item.Sound = "weapons/iceaxe/iceaxe_swing1.wav"
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "meat_cleaver"
Item.PrintName = "Cleaver"
Item.Desc = "For chopping meat"
Item.Icon = "icons/weapon_cleaver"
Item.Model = {}
Item.Model[1] = {Model = "models/props_lab/Cleaver.mdl", Position = Vector(-1.3, 0.7, 0.2), Angle = Angle(98.5, 0, 98.5)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.HoldType = "melee"
Item.Power = 8
Item.FireRate = 3
Item.Sound = "weapons/iceaxe/iceaxe_swing1.wav"
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "axe"
Item.PrintName = "Axe"
Item.Desc = "For chopping wood"
Item.Icon = "icons/weapon_axe"
Item.Model = {}
Item.Model[1] = {Model = "models/props_forest/axe.mdl", Position = Vector(0.4, -7.9, -0.4), Angle = Angle(14.5, 94.6, -80.1)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.HoldType = "melee"
Item.Power = 8
Item.FireRate = 3
Item.Sound = "weapons/iceaxe/iceaxe_swing1.wav"
Register.Item(Item)