local function DeriveTable(tblWantedTable)
	local tblNewTable = {}
	for k, v in pairs(tblWantedTable) do tblNewTable[k] = v end
	return tblNewTable
end

local BaseItem = {}
BaseItem.Name = "default"
BaseItem.PrintName = "No Name"
BaseItem.Desc = "No Description"
BaseItem.Icon = "icons/junk_metalcan1"
BaseItem.Model = "models/props_junk/garbage_metalcan001a.mdl"
BaseItem.Stackable = false
BaseItem.Dropable = false
BaseItem.Giveable = false
BaseItem.Weight = 0

local BaseFood = DeriveTable(BaseItem)
BaseFood.AddedHealth = 25
function BaseFood:Use(usr, itemtable)
	if usr:Health() >= 100 or usr:Health() <= 0 then return end
	usr:SetHealth(math.Clamp(usr:Health() + itemtable.AddedHealth, 0, 100))
	RemoveItemFromInv(usr, itemtable.Name)
end

local BaseAmmo = DeriveTable(BaseItem)
BaseAmmo.AmmoType = "pistol"
BaseAmmo.AmmoAmount = 20
function BaseAmmo:Use(usr, itemtable)
	if usr:Health() <= 0 then return end
	usr:GiveAmmo(itemtable.AmmoAmount, itemtable.AmmoType)
	RemoveItemFromInv(usr, itemtable.Name)
end


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
Register.Item(Item)

local Item = DeriveTable(BaseAmmo)
Item.Name = "pistolammo"
Item.PrintName = "Pistol Ammo"
Item.Desc = "Gives you 20 pistol bullets"
Item.Icon = "gui/box"
Item.Model = "models/Items/357ammobox.mdl"
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
Item.AmmoType = "pistol"
Item.AmmoAmount = 20
Register.Item(Item)

local Item = DeriveTable(BaseItem)
Item.Name = "pistol"
Item.PrintName = "Pistol"
Item.Catagory = "Weapons"
--Item.Color = Color(200, 150, 150, 200)
Item.Desc = "Pasively gives you a pistol"
Item.Icon = "icons/weapon_pistol"
Item.Model = "models/Weapons/W_pistol.mdl"
Item.Dropable = true
Item.Giveable = true
Item.Weight = 3
function Item:AddedToInv(usr)
	if usr:IsPlayer() then
		if !usr:HasWeapon("weapon_pistol") then
			usr:Give("weapon_pistol")
			usr.Loadout["weapon_pistol"] = true
		end
	end
end
function Item:RemovedFromInv(usr)
	if usr:IsPlayer() then
		if usr:HasWeapon("weapon_pistol") && usr.Data.Inventory["pistol"] == 0 then
			usr:StripWeapon("weapon_pistol")
			usr.Loadout["weapon_pistol"] = false
		end
	end
end
Register.Item(Item)

local Item = DeriveTable(BaseItem)
Item.Name = "shotgun"
Item.PrintName = "Shotgun"
Item.Catagory = "Weapons"
--Item.Color = Color(200, 150, 150, 200)
Item.Desc = "Pasively gives you a shotgun"
Item.Icon = "icons/weapon_shotgun"
Item.Model = "models/Weapons/W_shotgun.mdl"
Item.Dropable = true
Item.Giveable = true
Item.Weight = 5
function Item:AddedToInv(usr)
	if usr:IsPlayer() then
		if !usr:HasWeapon("weapon_shotgun") then
			usr:Give("weapon_shotgun")
			usr.Loadout["weapon_shotgun"] = true
		end
	end
end
function Item:RemovedFromInv(usr)
	if usr:IsPlayer() then
		if usr:HasWeapon("weapon_shotgun") && usr.Data.Inventory["shotgun"] == 0 then
			usr:StripWeapon("weapon_shotgun")
			usr.Loadout["weapon_shotgun"] = false
		end
	end
end
Register.Item(Item)