function DeriveTable(tblWantedTable)
	local tblNewTable = {}
	for k, v in pairs(tblWantedTable) do tblNewTable[k] = v end
	return tblNewTable
end

BaseItem = {}
BaseItem.Name = "default"
BaseItem.PrintName = "No Name"
BaseItem.Desc = "No Description"
BaseItem.Icon = "icons/junk_metalcan1"
BaseItem.Model = "models/props_junk/garbage_metalcan001a.mdl"
BaseItem.Stackable = false
BaseItem.Dropable = false
BaseItem.Giveable = false
BaseItem.Weight = 0

BaseFood = DeriveTable(BaseItem)
BaseFood.AddedHealth = 25
BaseFood.AddTime = 10
function BaseFood:Use(usr, itemtable)
	if !usr or !usr:IsValid() or usr:Health() >= 100 or usr:Health() <= 0 then return end
	local intHealthToAdd = itemtable.AddedHealth
	local intHealthGiven = 0
	local function AddHealth()
		if !usr or !usr:IsValid() or usr:Health() >= 100 or usr:Health() <= 0 or intHealthGiven >= intHealthToAdd then return end
		usr:SetHealth(math.Clamp(usr:Health() + 1, 0, 100))
		intHealthGiven = intHealthGiven + 1
		timer.Simple(itemtable.AddTime / intHealthToAdd, AddHealth)
	end
	timer.Simple(itemtable.AddTime / intHealthToAdd, AddHealth)
	RemoveItemFromInv(usr, itemtable.Name)
end

BaseAmmo = DeriveTable(BaseItem)
BaseAmmo.AmmoType = "pistol"
BaseAmmo.AmmoAmount = 20
function BaseAmmo:Use(usr, itemtable)
	if usr:Health() <= 0 then return end
	usr:GiveAmmo(itemtable.AmmoAmount, itemtable.AmmoType)
	RemoveItemFromInv(usr, itemtable.Name)
end

BaseEquiptment = DeriveTable(BaseItem)
BaseEquiptment.Slot = "slot_primaryweapon"
BaseEquiptment.Buffs = {}
function BaseEquiptment:Use(usr, itemtable)
	if usr:Health() <= 0 && usr:IsPlayer() then return end
	if !usr.Data.Paperdoll then usr.Data.Paperdoll = {} end
	if !itemtable then return end
	if !usr.Data.Paperdoll then usr.Data.Paperdoll = {} end
	local strCurrentItem = usr.Data.Paperdoll[itemtable.Slot]
	if !strCurrentItem or (strCurrentItem && strCurrentItem != itemtable.Name) then
		usr.Data.Paperdoll[itemtable.Slot] = itemtable.Name
	else
		usr.Data.Paperdoll[itemtable.Slot] = nil
	end
	for name, amount in pairs(itemtable.Buffs or {}) do
		print(name, amount)
		if usr.Data.Paperdoll[itemtable.Slot] then
			usr:AddStat(name, amount)
		else
			usr:AddStat(name, -amount)	
		end
	end
	umsg.Start("UD_UpdatePapperDoll")
	umsg.Entity(usr)
	umsg.String(itemtable.Slot)
	if usr.Data.Paperdoll[itemtable.Slot] then
		umsg.String(itemtable.Name)
	end
	umsg.End()
	usr:SaveGame()
end

BaseWeapon = DeriveTable(BaseEquiptment)
BaseWeapon.HoldType = "pistol"
BaseWeapon.AmmoType = "none"
BaseWeapon.NumOfBullets = 1
BaseWeapon.Power = 1
BaseWeapon.Accuracy = 0.01
BaseWeapon.FireRate = 3
BaseWeapon.ClipSize = 5
BaseWeapon.Sound = "weapons/pistol/pistol_fire2.wav"
function BaseWeapon:Use(usr, itemtable)
	BaseEquiptment:Use(usr, itemtable)
	usr:StripWeapons()
	usr.Loadout = {}
	if usr.Data.Paperdoll[itemtable.Slot] == itemtable.Name then
		usr:Give("weapon_primaryweapon")
		usr:GetWeapon("weapon_primaryweapon"):SetWeapon(itemtable)
	end
end






