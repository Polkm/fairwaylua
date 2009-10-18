local Player = FindMetaTable("Player")

function Player:GiveCash(intAmount)
	local intAmountToGive = tonumber(intAmount) or 0
	if self.Perks["perk_ammoup"] then
		intAmountToGive = intAmountToGive / 2
	elseif self.Perks["perk_gamble"] then
		local chance = math.random(1, 2)
		if chance == 1 then
			intAmountToGive = intAmountToGive * -1
		else
			intAmountToGive = intAmountToGive * 2
		end
	end
	intAmountToGive = math.Round(intAmountToGive)
	if self:GetNWInt("cash") + intAmountToGive >= 0 then 
		self:SetNWInt("cash", self:GetNWInt("cash") + intAmountToGive)
		return true
	else
		return false
	end
end

function Player:GiveAmmoAmount(strAmount)
	local strAmmoAmount = tostring(strAmount) or "small"
	for _, weapon in pairs(self:GetWeapons()) do
		if AmmoTypes[weapon:GetPrimaryAmmoType()] then
			local intAmmoToGive = AmmoTypes[weapon:GetPrimaryAmmoType()][strAmmoAmount]
			if self.Perks["perk_ammoup"] then
				intAmmoToGive = math.Round(intAmmoToGive * 1.5)
			end
			local intMaxToAdd = AmmoTypes[weapon:GetPrimaryAmmoType()]["full"] - self:GetAmmoCount(weapon:GetPrimaryAmmoType())
			self:GiveAmmo(math.Clamp(intAmmoToGive, 0, intMaxToAdd), weapon:GetPrimaryAmmoType())
		end
	end
end

function Player:AddWeaponToLocker(strWeapon, intMaxPoints, intPwrLvl, intAccLvl, intClpLvl, intSpdLvl, intResLvl)
	local strWeaponClass = tostring(strWeapon) or "weapon_crowbar"
	local intMaximumPoints = tonumber(intMaxPoints) or 15
	local tblNewWeaponTable = {
		Weapon = strWeaponClass,
		Maxpoints = tonumber(intMaximumPoints),
		pwrlvl = tonumber(intPwrLvl) or 1,
		acclvl = tonumber(intAccLvl) or 1,
		clplvl = tonumber(intClpLvl) or 1,
		spdlvl = tonumber(intSpdLvl) or 1,
		reslvl = tonumber(intResLvl) or 1,
	}
	table.insert(self.Locker, tblNewWeaponTable)
end

function Player:SwitchWeapon()
	if !self or !self:IsValid() or !self:Alive() then return false end
	if !self:GetActiveWeapon() then return false end
	if self:GetActiveWeapon():GetNWBool("reloading") then return false end
	if self:GetNWInt("ActiveWeapon") == self:GetNWInt("Weapon1") then
		local strWeaponClass = "weapon_crowbar"
		if self.Locker[self:GetNWInt("Weapon2")] then
			strWeaponClass = self.Locker[self:GetNWInt("Weapon2")].Weapon
		end
		self:SelectWeapon(strWeaponClass)
		if self:GetActiveWeapon() && self:GetActiveWeapon():GetClass() == strWeaponClass then
			self:SetNWInt("ActiveWeapon", self:GetNWInt("Weapon2"))
		end
	elseif self:GetNWInt("ActiveWeapon") == self:GetNWInt("Weapon2") then
		local strWeaponClass = "weapon_crowbar"
		if self.Locker[self:GetNWInt("Weapon1")] then
			strWeaponClass = self.Locker[self:GetNWInt("Weapon1")].Weapon
		end
		self:SelectWeapon(strWeaponClass)
		if self:GetActiveWeapon() && self:GetActiveWeapon():GetClass() == strWeaponClass then
			self:SetNWInt("ActiveWeapon", self:GetNWInt("Weapon1"))
		end
	end
end
concommand.Add("tx_switchWeapon", function(ply, command, args) ply:SwitchWeapon() end)

function Player:DepositWeapon(intWeapon)
	local tblLocker = self.Locker
	local intWeaponID = intWeapon or 0
	local strNWInt = nil
	local strNWIntOp = nil
	if self:GetNWInt("Weapon1") == intWeaponID then strNWInt = "Weapon1" strNWIntOp = "Weapon2"
	elseif self:GetNWInt("Weapon2") == intWeaponID then strNWInt = "Weapon2" strNWIntOp = "Weapon1"
	else return	end
	if strNWInt then
		self:StripWeapon(tblLocker[intWeaponID].Weapon)
		self:SetNWInt(strNWInt, 0)
		self:SetNWInt("ActiveWeapon", self:GetNWInt(strNWInt))
		if self:GetNWInt(strNWIntOp) != 0 then
			self:ConCommand("tx_switchWeapon")
		else
			self:Give("weapon_crowbar")
			self:SelectWeapon("weapon_crowbar")
		end
		SendDataToAClient(self)
	end
end
concommand.Add("tx_depositWeapon", function(ply, command, args) ply:DepositWeapon(tonumber(args[1]))  end)

function Player:WithdrawWeapon(intWeapon)
	local tblLocker = self.Locker
	local intWeaponID = intWeapon or 0
	if !self:HasWeapon(tblLocker[intWeaponID].Weapon) then
		local strNWCurrentWep = nil
		local strNWSecondaryWep = nil
		if self:GetNWInt("Weapon1") == 0 then strNWCurrentWep = "Weapon1" strNWSecondaryWep = "Weapon2"
		elseif self:GetNWInt("Weapon2") == 0 then strNWCurrentWep = "Weapon2" strNWSecondaryWep = "Weapon1" 
		else return end
		if strNWCurrentWep then
			self:Give(tblLocker[intWeaponID].Weapon)
			self:GetWeapon(tblLocker[intWeaponID].Weapon):SetNWInt("id", intWeaponID)
			self:SetNWInt(strNWCurrentWep, intWeaponID)
			self:SetNWInt("ActiveWeapon", intWeaponID)
			self:SelectWeapon(self.Locker[intWeaponID].Weapon)
			if self:HasWeapon("weapon_crowbar") then
				self:StripWeapon("weapon_crowbar")
			end
			SendDataToAClient(self)
		end
	end
end
concommand.Add("tx_withdrawWeapon", function(ply, command, args) ply:WithdrawWeapon(tonumber(args[1]))  end)

--Perks
function Player:ActivatePerk(PerkToActivate)
	PerkToActivate = "perk_ammoup"
	if self.Perks[PerkToActivate] != nil then
		self.Perks[PerkToActivate] = true
	end
	SendDataToAClient(self)
end
concommand.Add("tx_ActivatePerk", function(ply, command, args) ply:ActivatePerk(tostring(args[1]))  end)

function Player:DeactivatePerk(PerkToDeactivate)
	PerkToDeactivate = "perk_ammoup"
	if self.Perks[PerkToDeactivate] != nil then
		self.Perks[PerkToDeactivate] = false
	end
	SendDataToAClient(self)
end
concommand.Add("tx_DeactivatePerk", function(ply, command, args) ply:DeactivatePerk(tostring(args[1]))  end)