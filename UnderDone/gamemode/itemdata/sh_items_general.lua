local Item = DeriveTable(BaseItem)
Item.Name = "money"
Item.PrintName = "Money"
Item.Desc = "It will bring you happy"
Item.Icon = "icons/item_cash"
Item.Model = "models/props_junk/wood_pallet001a_chunkb2.mdl"
Item.Stackable = true
Item.Dropable = true
Item.Giveable = true
Register.Item(Item)

local Item = DeriveTable(BaseItem)
Item.Name = "wood"
Item.PrintName = "Wood"
Item.Desc = "Its wood?"
Item.Icon = "icons/item_wood"
Item.Model = "models/Gibs/wood_gib01d.mdl"
Item.Dropable = true
Item.Giveable = true
Item.SellPrice = 2
Item.Weight = 1
Register.Item(Item)