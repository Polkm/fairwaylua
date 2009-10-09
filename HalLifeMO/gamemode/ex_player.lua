local Player = FindMetaTable("Player")

function GM:PlayerInitialSpawn(ply)
	if !file.Exists("HalfLifeRPG/" .. ply:UniqueID() .. ".txt") then
		ply.LoadOut = {}
		ply:AddWeaponToLoadOut("weapon_crowbar")
		ply:AddWeaponToLoadOut("weapon_pistol")
		ply:SetNWInt("exp", 0)
		ply:SetNWInt("cash", 0)
	else
		local LoadString = file.Read("HalfLifeRPG/" .. ply:UniqueID() .. ".txt")
		ply.LoadOut = {}
		for _, weapon in pairs(util.KeyValuesToTable(LoadString)["loadout"]) do
			table.insert(ply.LoadOut, weapon) 
		end
		ply:SetNWInt("exp", util.KeyValuesToTable(LoadString)["exp"])
		ply:SetNWInt("cash", util.KeyValuesToTable(LoadString)["cash"])
	end
end

function GM:PlayerLoadout(ply)
	for _, weapon in pairs(ply.LoadOut) do
		ply:Give(weapon)
	end
	for weapon, amount in pairs(AmmoTypes) do
		ply:GiveAmmo(amount["full"], weapon)
	end
end

function Player:AddWeaponToLoadOut(strWeaponClass)
	if GAMEMODE.MaximumSlots - table.Count(self:GetWeapons()) >= 1 then
		table.insert(self.LoadOut, strWeaponClass)
		self:Save()
		return true
	end
	return false
end
function Player:RemoveWeaponFromLoadOut(strWeaponClass)
	if !self:HasWeapon(strWeaponClass) then return false end
	for k, weapon in pairs(self.LoadOut) do
		if weapon == strWeaponClass then
			self.LoadOut[k] = nil
			self:Save()
			return true
		end
	end
	return false
end

function Player:GiveCash(intAmount, boolSave)
	local save = boolSave or true
	if self:GetNWInt("cash") + intAmount >= 0 then 
		self:SetNWInt("cash", self:GetNWInt("cash") + intAmount)
		if save then self:Save() end
		return true
	else
		return false
	end
end

function Player:Save()
	local SaveString = {}
	SaveString["loadout"] = self.LoadOut
	SaveString["exp"] = self:GetNWInt("exp")
	SaveString["cash"] = self:GetNWInt("cash")
	file.Write("HalfLifeRPG/" .. self:UniqueID() .. ".txt", util.TableToKeyValues(SaveString))
	return false
end
