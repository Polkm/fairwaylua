local function AddHealth(tblAddTable, intAmount, intTime)
	tblAddTable.AddedHealth = intAmount
	tblAddTable.AddTime = intTime
	return tblAddTable
end
local function AddAmmo(tblAddTable, intAmount, strType)
	tblAddTable.AmmoAmount = intAmount
	tblAddTable.AmmoType = strType
	return tblAddTable
end

local Item = QuickCreateItemTable(BaseFood, "item_canspoilingmeat", "Can of Spoiling Meat", "Restores your health by 10 over 12 Seconds", "icons/junk_metalcan1")
Item = AddHealth(Item, 10, 12)
Item.Model = "models/props_junk/garbage_metalcan001a.mdl"
Item.Message = "You ate a Spoiled piece of Meat"
Item.SellPrice = 10
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseFood, "item_orange", "Orange", "Restores your health by 25 over 8 Seconds", "icons/food_orange")
Item = AddHealth(Item, 25, 8)
Item.Model = "models/props/cs_italy/orange.mdl"
Item.Message = "You ate a Orange"
Item.SellPrice = 26
Item.Weight = 1
Register.Item(Item)
local Item = DeriveTable(BaseItem)

local Item = QuickCreateItemTable(BaseFood, "item_antivirus", "Anti Virus", "An antivirus that can heal wounds.", "icons/item_antivirus")
Item = AddHealth(Item, 40, 10)
Item.Model = "models/healthvial.mdl"
Item.QuestNeeded = "quest_zombieblood"
Item.Message = "You have taken an antivirus"
Item.SellPrice = 40
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseFood, "item_banannabunch", "Bananna Bunch", "Restores your health by 75 over 20 Seconds", "icons/food_bananna_bunch")
Item = AddHealth(Item, 75, 20)
Item.Model = "models/props/cs_italy/bananna_bunch.mdl"
Item.Message = "You ate a Bunch of Bananna's"
Item.SellPrice = 80
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseFood, "item_bananna", "Bananna", "Restores your health by 15 over 10 Seconds", "icons/food_bananna")
Item = AddHealth(Item, 15, 10)
Item.Model = "models/props/cs_italy/bananna.mdl"
Item.Message = "You ate a Banana"
Item.SellPrice = 15
Item.Weight = 1
Register.Item(Item)


local Item = QuickCreateItemTable(BaseFood, "item_healthkit", "Health Kit", "Restores health by 40", "icons/item_healthkit")
Item = AddHealth(Item, 40, 1)
Item.Model = "models/Items/HealthKit.mdl"
Item.Message = "You've used a Health Kit"
Item.SellPrice = 45
Item.Weight = 1
Register.Item(Item)


local Item = QuickCreateItemTable(BaseAmmo, "item_smallammo_small", "Small Rounds", "25 Small bullets", "icons/item_pistolammobox")
Item = AddAmmo(Item, 25, "smg1")
Item.Model = "models/Items/357ammobox.mdl"
Item.SellPrice = 5
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseAmmo, "item_rifleammo_small", "Rifle Rounds", "35 Rifle bullets", "icons/item_rifleammo")
Item = AddAmmo(Item, 35, "ar2")
Item.Model = "models/Items/BoxSRounds.mdl"
Item.SellPrice = 10
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseAmmo, "item_buckshotammo_small", "Buckshot", "20 Buckshot shells", "icons/item_buckshot")
Item = AddAmmo(Item, 20, "buckshot")
Item.Model = "models/Items/BoxBuckshot.mdl"
Item.SellPrice = 8
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseAmmo, "item_sniperammo_small", "SniperRound", "8 Sniper Round", "icons/item_buckshot")
Item = AddAmmo(Item, 8, "SniperRound")
Item.Model = "models/Items/BoxBuckshot.mdl"
Item.SellPrice = 8
Item.Weight = 1
Register.Item(Item)


--More ZCOM stuff I want these to have icons before we add them to game
local Item = QuickCreateItemTable(BaseFood, "item_pumpkin", "Pumpkin", "Restores your health by 35 over 12 Seconds", "icons/food_bananna")
Item = AddHealth(Item, 35, 12)
Item.Model = "models/props_outland/pumpkin01.mdl"
Item.Message = "You ate a Pumpkin"
Item.SellPrice = 45
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseFood, "item_coffee", "Coffee Mug", "Restores health by 12", "icons/food_bananna")
Item = AddHealth(Item, 12, 1)
Item.Model = "models/props_junk/garbage_coffeemug001a.mdl"
Item.Message = "You drank a cup of stale coffee."
Item.SellPrice = 2
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseFood, "item_milk", "Milk(1Gal)", "Restores your health by 50 over 15 Seconds", "icons/food_bananna")
Item = AddHealth(Item, 50, 15)
Item.Model = "models/props_junk/garbage_milkcarton001a.mdl"
Item.Message = "You drank a whole gallon of milk!"
Item.SellPrice = 10
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseFood, "item_milk_small", "Milk(1/2Gal)", "Restores your health by 25 over 8 Seconds", "icons/food_bananna")
Item = AddHealth(Item, 25, 8)
Item.Model = "models/props_junk/garbage_milkcarton002a.mdl"
Item.Message = "You drank half a gallon of milk."
Item.SellPrice = 6
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseFood, "item_beer", "Cheap Beer", "Restores your health by 30 over 30 Seconds", "icons/food_bananna")
Item = AddHealth(Item, 30, 30)
Item.Model = "models/props_junk/garbage_glassbottle001a.mdl"
Item.Message = "You drank a bottle of cheap beer."
Item.SellPrice = 8
Item.Weight = 1
Register.Item(Item)

local Item = QuickCreateItemTable(BaseFood, "item_vodka", "Vodka", "Restores your health by 60 over 30 Seconds", "icons/food_bananna")
Item = AddHealth(Item, 60, 30)
Item.Model = "models/props_junk/garbage_glassbottle003a.mdl"
Item.Message = "You drank a bottle of vodka."
Item.SellPrice = 18
Item.Weight = 2
Register.Item(Item)

local Item = QuickCreateItemTable(BaseFood, "item_leftovers", "Chinese Leftovers", "Restores your health by 10 over 2 Seconds", "icons/food_bananna")
Item = AddHealth(Item, 60, 30)
Item.Model = "models/props_junk/garbage_takeoutcarton001a.mdl"
Item.Message = "You ate some leftover chinese-food."
Item.SellPrice = 1
Item.Weight = 2
Register.Item(Item)

local Item = QuickCreateItemTable(BaseFood, "item_melon", "Watermelon", "Restores your health by 45 over 15 Seconds", "icons/food_bananna")
Item = AddHealth(Item, 45, 15)
Item.Model = "models/props_junk/watermelon01.mdl"
Item.Message = "You ate a juicy watermelon."
Item.SellPrice = 16
Item.Weight = 2
Register.Item(Item)




