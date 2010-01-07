local Item = DeriveTable(BaseEquiptment)
Item.Name = "helm"
Item.PrintName = "Helmet"
Item.Desc = "Protects"
Item.Icon = "icons/junk_pan1"
Item.Model = {}
Item.Model[1] = {Model = "models/props_interiors/pot02a.mdl", Position = Vector(-0.7, -8.1, -3.5), Angle = Angle(180, -100, -20)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.Slot = "slot_helm"
Item.Buffs = {}
Register.Item(Item)

local Item = DeriveTable(BaseEquiptment)
Item.Name = "goggles_scanner"
Item.PrintName = "Scanner Goggles"
Item.Desc = "Scan like a scanner"
Item.Icon = "icons/junk_box1"
Item.Model = {}
Item.Model[1] = {Model = "models/Gibs/Shield_Scanner_Gib1.mdl", Position = Vector(-0.3, -0.3, 0.1), Angle = Angle(121.1, -83.6, -95.7)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.Slot = "slot_helm"
Item.Buffs = {}
Item.Buffs["stat_strength"] = 5
Register.Item(Item)

local Item = DeriveTable(BaseEquiptment)
Item.Name = "armor_junk_chest"
Item.PrintName = "Junky Armor"
Item.Desc = "Protects your heart and lungs from gettin pwnd"
Item.Icon = "icons/junk_box1"
Item.Model = {}
Item.Model[1] = {Model = "models/Gibs/Shield_Scanner_Gib2.mdl", Position = Vector(-0.2, 0.2, -3.3), Angle = Angle(-95.9, -10.5, 0)}
Item.Model[2] = {Model = "models/Gibs/Scanner_gib02.mdl", Position = Vector(-4.4, 3.1, 3.9), Angle = Angle(46, 9.2, -116.9)}
Item.Model[3] = {Model = "models/Gibs/Scanner_gib02.mdl", Position = Vector(7, 5, 4.6), Angle = Angle(-23.4, -4.7, 56.9)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.Slot = "slot_chest"
Item.Buffs = {}
Item.Buffs["stat_maxhealth"] = 5
Register.Item(Item)

local Item = DeriveTable(BaseEquiptment)
Item.Name = "sheild"
Item.PrintName = "Sheild"
Item.Desc = "Protects"
Item.Icon = "icons/junk_metalcan2"
Item.Model = {}
Item.Model[1] = {Model = "models/props_mining/elevator_winch_cog.mdl", Position = Vector(0, 5.7, 5), Angle = Angle(-83.6, -7.4, 0)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.Slot = "slot_offhand"
Item.Buffs = {}
Register.Item(Item)