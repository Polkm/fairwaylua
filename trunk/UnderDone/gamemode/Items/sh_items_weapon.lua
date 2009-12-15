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