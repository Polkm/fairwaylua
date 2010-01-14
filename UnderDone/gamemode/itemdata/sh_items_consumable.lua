local Item = DeriveTable(BaseFood)
Item.Name = "can"
Item.PrintName = "Can of Spoiling Meat"
Item.Desc = "Restores your health by 10"
Item.Icon = "icons/junk_metalcan1"
Item.Model = "models/props_junk/garbage_metalcan001a.mdl"
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.AddedHealth = 10
Item.AddTime = 12
Register.Item(Item)

local Item = DeriveTable(BaseAmmo)
Item.Name = "small_ammo"
Item.PrintName = "9mm Rounds"
Item.Desc = "Gives you 20 9mm bullets"
Item.Icon = "icons/item_pistolammobox"
Item.Model = "models/Items/357ammobox.mdl"
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.AmmoType = "Pistol"
Item.AmmoAmount = 20
Register.Item(Item)
