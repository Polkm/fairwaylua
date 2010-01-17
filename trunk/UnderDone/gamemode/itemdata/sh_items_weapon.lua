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
Item.Model[1] = {Model = "models/props_forest/axe.mdl", Position = Vector(-0.3, -5.2, -1), Angle = Angle(-0.7, 78.3, -82.3)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.HoldType = "melee"
Item.CanCutWood = true
Item.Power = 8
Item.FireRate = 3
Item.Sound = "weapons/iceaxe/iceaxe_swing1.wav"
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "weapon_melee_leadpipe"
Item.PrintName = "Lead Pipe"
Item.Desc = "And now you even get lead poisoning!"
Item.Icon = "icons/weapon_pipe"
Item.Model = {}
Item.Model[1] = {Model = "models/props_canal/mattpipe.mdl", Position = Vector(-0.6, 0.8, -5.9), Angle = Angle(4.7, 56.9, -176)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.HoldType = "melee"
Item.CanCutWood = true
Item.Power = 8
Item.FireRate = 3
Item.Sound = "weapons/iceaxe/iceaxe_swing1.wav"
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "tool_wrench"
Item.PrintName = "Tool Wrench"
Item.Desc = "Fixing things? I don't think so! More like smashing things!"
Item.Icon = "icons/weapon_pipe"
Item.Model = {}
Item.Model[1] = {Model = "models/props_c17/tools_wrench01a.mdl", Position = Vector(0.3, 2.8, 0.3), Angle = Angle(14.1, -14.1, 78.3)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.HoldType = "melee"
Item.Power = 8
Item.FireRate = 3
Item.Sound = "weapons/iceaxe/iceaxe_swing1.wav"
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "knife"
Item.PrintName = "Knife"
Item.Desc = "Cutting KnifeS"
Item.Icon = "icons/weapon_cleaver"
Item.Model = {}
Item.Model[1] = {Model = "models/weapons/w_knife_ct.mdl", Position = Vector(-3.7, -0.3, 1.7), Angle = Angle(-8.7, 75.6, 31.4)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.HoldType = "melee"
Item.Power = 8
Item.FireRate = 3
Item.Sound = "weapons/iceaxe/iceaxe_swing1.wav"
Register.Item(Item)

local Item = DeriveTable(BaseWeapon)
Item.Name = "weapon_melee_circularsaw"
Item.PrintName = "Circular Saw"
Item.Desc = "Zing Zing Ziiiingng!"
Item.Icon = "icons/junk_saw"
Item.Model = {}
Item.Model[1] = {Model = "models/props_forest/circularsaw01.mdl", Position = Vector(3.2, -7.7, -8.1), Angle = Angle(27.4, 123.8, -11.4)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.HoldType = "melee"
Item.CanCutWood = true
Item.Power = 8
Item.FireRate = 3
Item.Sound = "weapons/iceaxe/iceaxe_swing1.wav"
Register.Item(Item)

