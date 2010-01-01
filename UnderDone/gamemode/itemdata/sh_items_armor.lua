local Item = DeriveTable(BaseEquiptment)
Item.Name = "helm"
Item.PrintName = "Helmet"
Item.Desc = "Protects"
Item.Icon = "icons/junk_pan1"
Item.Model = {}
Item.Model[1] = {Model = "models/props_interiors/pot02a.mdl", Position = Vector(-0.9, -9, -3.5), Angle = Angle(180, -100, -20)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.Slot = "slot_helm"
Register.Item(Item)

local Item = DeriveTable(BaseEquiptment)
Item.Name = "armor_junk_chest"
Item.PrintName = "Junky Armor"
Item.Desc = "Protects your heart and lungs from gettin pwnd"
Item.Icon = "icons/junk_box1"
Item.Model = {}
Item.Model[1] = {Model = "models/props_interiors/pot02a.mdl", Position = Vector(3.3, -8.1, -6.4), Angle = Angle(180, 6.6, -43.4)}
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.Slot = "slot_chest"
Register.Item(Item)