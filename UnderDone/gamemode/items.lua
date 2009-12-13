GM.ItemCatagories = {}
GM.ItemCatagories["Consumables"] = {PrintName = "Consumables"}
GM.ItemCatagories["Weapons"] = {PrintName = "Weapons"}

local Item = {}
Item.Name = "money"
Item.PrintName = "Money"
Item.Color = Color(150, 200, 150, 200)
Item.Desc = "It will bring you happy"
Item.Icon = "gui/money_dollar"
Item.Model = "models/props_junk/wood_pallet001a_chunkb2.mdl"
Item.Stackable = true
Item.Dropable = true
Item.Giveable = true
Item.Takeable = true
Item.Weight = 0
Register.Item(Item)

local Item = {}
Item.Name = "can"
Item.PrintName = "Can"
Item.Catagory = "Consumables"
--Item.Color = Color(200, 200, 150, 200)
Item.Desc = "Restores your health by 25"
Item.Icon = "icons/junk_metalcan1"
Item.Model = "models/props_junk/garbage_metalcan001a.mdl"
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
function Item:Use(usr)
	if usr:Health() < 100 && usr:Health() > 0 then
		usr:SetHealth(math.Clamp(usr:Health() + 25, 0, 100))
		RemoveItemFromInv(usr, "can")
	end
end
Register.Item(Item)

local Item = {}
Item.Name = "pistolammo"
Item.PrintName = "Pistol Ammo"
Item.Catagory = "Consumables"
--Item.Color = Color(200, 200, 150, 200)
Item.Desc = "Gives you 20 pistol bullets"
Item.Icon = "gui/box"
Item.Model = "models/Items/357ammobox.mdl"
Item.Dropable = true
Item.Giveable = true
Item.Weight = 1
function Item:Use(usr)
	if usr:Health() > 0 then
		usr:GiveAmmo(20, "Pistol")
		RemoveItemFromInv(usr, "pistolammo")
	end
end
Register.Item(Item)

local Item = {}
Item.Name = "pistol"
Item.PrintName = "Pistol"
Item.Catagory = "Weapons"
--Item.Color = Color(200, 150, 150, 200)
Item.Desc = "Pasively gives you a pistol"
Item.Icon = "gui/silkicons/bomb"
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

local Item = {}
Item.Name = "shotgun"
Item.PrintName = "Shotgun"
Item.Catagory = "Weapons"
--Item.Color = Color(200, 150, 150, 200)
Item.Desc = "Pasively gives you a shotgun"
Item.Icon = "gui/silkicons/bomb"
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