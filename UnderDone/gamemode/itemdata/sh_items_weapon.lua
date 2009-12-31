local Item = DeriveTable(BaseEquiptment)
Item.Name = "helm"
Item.PrintName = "Helmet"
Item.Desc = "Protects"
Item.Icon = "icons/junk_pan1"
Item.Slot = "slot_helm"
Item.Model = {}
Item.Model[1] = {Model = "models/props_interiors/pot02a.mdl", Position = Vector(-1, -8, -3.5), Angle = Angle(180, -100, -20)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Register.Item(Item)


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
Item.Name = "frying_pan"
Item.PrintName = "Frying Pan"
Item.Desc = "Frying Pan :D"
Item.Icon = "icons/junk_pan2"
Item.Model = {}
Item.Model[1] = {Model = "models/props_interiors/pot02a.mdl", Position = Vector(1, 8, -0.5), Angle = Angle(0, 0, 90)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.HoldType = "melee"
Item.Power = 8
Item.FireRate = 3
Item.Sound = "weapons/iceaxe/iceaxe_swing1.wav"
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