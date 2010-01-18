local Item = DeriveTable(BaseFood)
Item.Name = "can"
Item.PrintName = "Can of Spoiling Meat"
Item.Desc = "Restores your health by 10"
Item.Icon = "icons/junk_metalcan1"
Item.Model = "models/props_junk/garbage_metalcan001a.mdl"
Item.Dropable = true
Item.Giveable = true
Item.SellPrice = 10
Item.Weight = 1
Item.AddedHealth = 10
Item.AddTime = 12
Register.Item(Item)

local Item = DeriveTable(BaseFood)
Item.Name = "health_kit"
Item.PrintName = "Health Kit"
Item.Desc = "Restores health by 40"
Item.Icon = "icons/item_healthkit"
Item.Model = "models/Items/Health_Kit.mdl"
Item.Dropable = true
Item.Giveable = true
Item.SellPrice = 40
Item.Weight = 1
Item.AddedHealth = 40
Item.AddTime = 6
Register.Item(Item)

local Item = DeriveTable(BaseAmmo)
Item.Name = "small_ammo"
Item.PrintName = "9mm Rounds"
Item.Desc = "Gives you 20 9mm bullets"
Item.Icon = "icons/item_pistolammobox"
Item.Model = "models/Items/357ammobox.mdl"
Item.Dropable = true
Item.Giveable = true
Item.SellPrice = 6
Item.Weight = 1
Item.AmmoType = "smg1"
Item.AmmoAmount = 20
Register.Item(Item)
