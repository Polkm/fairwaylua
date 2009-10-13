local Player = FindMetaTable("Player")

function GM:PlayerInitialSpawn(ply)
	ply:SetNWBool("PvpFlag", false)
	ply.Locker = {}
	ply.Locker[0] = {
		Weapon = "none",
		pwrlvl = 1,
		acclvl = 1,
		clplvl = 1, 
		spdlvl = 1,
		reslvl = 1,
		CanSilence = false, 
		ChangableFireRate = false, 
		CanGrenade = false, 
		Maxpoints = 15, 
	}
	ply.Locker[1337] = {
		Weapon = "weapon_crowbar",
		pwrlvl = 1,
		acclvl = 1,
		clplvl = 1, 
		spdlvl = 1,
		reslvl = 1,
		CanSilence = false, 
		ChangableFireRate = false, 
		CanGrenade = false, 
		Maxpoints = 15, 
	}
	ply:AddWeaponToLocker("weapon_p220_tx")
	ply:AddWeaponToLocker("weapon_mp5_tx")
	ply:SelectWeapon(ply.Locker[1].Weapon)
	ply:SetNWInt("ActiveWeapon", 1)
	ply:SetNWInt("Weapon1", 1)
	ply:SetNWInt("Weapon2", 2)
end

function GM:PlayerLoadout(ply)
	local entity = ents.Create("prop_dynamic")
	entity:SetModel("models/error.mdl")
	entity:Spawn()
	entity:SetAngles(ply:GetAngles())
	entity:SetMoveType(MOVETYPE_NONE)
	entity:SetParent(ply)
	entity:SetPos(ply:GetPos())
	entity:SetRenderMode(RENDERMODE_NONE)
	entity:SetSolid(SOLID_NONE)
	entity:SetNoDraw(true)
	ply:SetViewEntity(entity)
	ply.CanUse = true
	for k, weapon in pairs(ply.Locker) do
		if k != 0 then
			ply:Give(weapon.Weapon)
		end
	end
	ply:SelectWeapon(ply.Locker[ply:GetNWInt("ActiveWeapon")].Weapon)
	for _, weapon in pairs(ply:GetWeapons()) do
		if tostring(weapon:GetClass()) == "weapon_crowbar" then break end
		ply:GiveAmmo(AmmoTypes[weapon:GetPrimaryAmmoType()]["full"], weapon:GetPrimaryAmmoType())
	end
	PrintTable(ply.Locker)
	SendDataToAClient(ply) 
end

function GM:PlayerShouldTakeDamage(victim, attacker)
	if victim == attacker then return true end
	if attacker:IsPlayer() && victim:IsPlayer() then
		if victim:GetNWBool("PvpFlag") != true || attacker:GetNWBool("PvpFlag") != true then return false end
	end
	return true
end

function GM:PlayerUse(ply, ent)
	if !ply.CanUse then return end
	if ply:GetNWBool("LockerZone") then
		ply:ConCommand("tx_Locker")
	end
	ply.CanUse = false
	timer.Simple(0.3, function() ply.CanUse = true end)
	return true
end

function Player:GiveCash(intAmount)
	local Amount = tonumber(intAmount) or 0
	if self:GetNWInt("cash") + Amount >= 0 then 
		self:SetNWInt("cash", self:GetNWInt("cash") + Amount)
		return true
	else
		return false
	end
end

function Player:AddWeaponToLocker(strWeapon, intMaxPoints)
	local WeaponClass = tostring(strWeapon) or "weapon_crowbar"
	local MaximumPoints = intMaxPoints or 15
	local tblNewWeaponTable = {
		Weapon = WeaponClass,
		pwrlvl = 1,
		acclvl = 1,
		clplvl = 1, 
		spdlvl = 1,
		reslvl = 1,
		CanSilence = false,
		ChangableFireRate = false,
		CanGrenade = false,
		Maxpoints = MaximumPoints,
	}
	table.insert(self.Locker, tblNewWeaponTable)
end

function Player:SwitchWeapon()
	if self:GetNWInt("ActiveWeapon") == self:GetNWInt("Weapon1") then
		self:SelectWeapon(self.Locker[self:GetNWInt("Weapon2")].Weapon)
		if self:GetActiveWeapon():GetClass() == self.Locker[self:GetNWInt("Weapon2")].Weapon then
			self:SetNWInt("ActiveWeapon", self:GetNWInt("Weapon2"))
		end
	elseif self:GetNWInt("ActiveWeapon") == self:GetNWInt("Weapon2") then
		self:SelectWeapon(self.Locker[self:GetNWInt("Weapon1")].Weapon)
		if self:GetActiveWeapon():GetClass() == self.Locker[self:GetNWInt("Weapon1")].Weapon then
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
	elseif self:GetNWInt("Weapon2") == intWeaponID then strNWInt = "Weapon2" strNWIntOp = "Weapon1" end
	if strNWInt then
		self:StripWeapon(tblLocker[intWeaponID].Weapon)
		self:SetNWInt(strNWInt, 0)
		self:SetNWInt("ActiveWeapon", 0)
		if self:GetNWInt(strNWIntOp) != 0 && self:GetNWInt(strNWIntOp) != 1337 then
			self:ConCommand("tx_switchWeapon")
		else
			self:SetNWInt("ActiveWeapon", 1337)
			self:SelectWeapon(self.Locker[1337].Weapon)
			if self:GetNWInt(strNWIntOp) == 0 then
				self:SetNWInt(strNWInt, 1337)
			end
		end
	else
		return
	end
	SendDataToAClient(self)
end
concommand.Add("tx_depositWeapon", function(ply, command, args) ply:DepositWeapon(tonumber(args[1]))  end)

function Player:WithdrawWeapon(intWeapon)
	local tblLocker = self.Locker
	local intWeaponID = intWeapon or 0
	local strNWInt = nil
	local strNWIntOp = nil
	if self:GetNWInt("Weapon1") == 0 or self:GetNWInt("Weapon1") == 1337 then strNWInt = "Weapon1" strNWIntOp = "Weapon2"
	elseif self:GetNWInt("Weapon2") == 0 or self:GetNWInt("Weapon2") == 1337 then strNWInt = "Weapon2" strNWIntOp = "Weapon1" end
	if strNWInt then
		print("Atteping withdraw")
		print(self:GetNWInt("Weapon1"), self:GetNWInt("Weapon2"), self:GetNWInt("ActiveWeapon"))
		self:Give(tblLocker[intWeaponID].Weapon)
		self:SetNWInt(strNWInt, intWeaponID)
		print(self:GetNWInt("Weapon1"), self:GetNWInt("Weapon2"), self:GetNWInt("ActiveWeapon"))
		if self:GetNWInt(strNWIntOp) != 0 then
			self:ConCommand("tx_switchWeapon")
		else
			self:SetNWInt("ActiveWeapon", intWeaponID)
			self:SelectWeapon(self.Locker[intWeaponID].Weapon)
			self:SetNWInt(strNWIntOp, 0)
		end
	else
		return
	end
	SendDataToAClient(self)
end
concommand.Add("tx_withdrawWeapon", function(ply, command, args) ply:WithdrawWeapon(tonumber(args[1]))  end)