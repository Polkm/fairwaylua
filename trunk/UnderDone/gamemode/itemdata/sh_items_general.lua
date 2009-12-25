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