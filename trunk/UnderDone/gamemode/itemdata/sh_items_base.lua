function DeriveTable(tblWantedTable)
	local tblNewTable = {}
	for k, v in pairs(tblWantedTable) do
		if type(v) != "table" then
			tblNewTable[k] = v
		else
			tblNewTable[k] = table.Copy(v)
		end
	end
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
BaseItem.SellPrice = 0
BaseItem.Weight = 0

BaseFood = DeriveTable(BaseItem)
BaseFood.AddedHealth = 25
BaseFood.AddTime = 10
function BaseFood:Use(usr, itemtable)
	if !usr or !usr:IsValid() or usr:Health() >= usr:GetStat("stat_maxhealth") or usr:Health() <= 0 then return end
	local intHealthToAdd = itemtable.AddedHealth
	local intHealthGiven = 0
	local function AddHealth()
		if !usr or !usr:IsValid() or usr:Health() >= usr:GetStat("stat_maxhealth") or usr:Health() <= 0 or intHealthGiven >= intHealthToAdd then return end
		usr:SetHealth(math.Clamp(usr:Health() + 1, 0, usr:GetStat("stat_maxhealth")))
		intHealthGiven = intHealthGiven + 1
		timer.Simple(itemtable.AddTime / intHealthToAdd, AddHealth)
	end
	timer.Simple(itemtable.AddTime / intHealthToAdd, AddHealth)
	usr:AddItem(itemtable.Name, -1)
end

BaseAmmo = DeriveTable(BaseItem)
BaseAmmo.AmmoType = "pistol"
BaseAmmo.AmmoAmount = 20
function BaseAmmo:Use(usr, itemtable)
	if !usr or !usr:IsValid() or usr:Health() <= 0 then return false end
	usr:GiveAmmo(itemtable.AmmoAmount, itemtable.AmmoType)
	usr:AddItem(itemtable.Name, -1)
end

BaseEquiptment = DeriveTable(BaseItem)
BaseEquiptment.Slot = "slot_primaryweapon"
BaseEquiptment.Buffs = {}
function BaseEquiptment:Use(usr, tblItemTable)
	if usr:Health() <= 0 then return false end
	usr:SetPaperDoll(tblItemTable.Slot, tblItemTable.Name)
	return true
end

BaseArmor = DeriveTable(BaseEquiptment)
BaseArmor.Armor = 0

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
	if !BaseEquiptment:Use(usr, itemtable) then return end
	usr:StripWeapons()
	if usr.Data.Paperdoll[itemtable.Slot] == itemtable.Name then
		usr:Give("weapon_primaryweapon")
		usr:GetWeapon("weapon_primaryweapon"):SetWeapon(itemtable)
	end
end






