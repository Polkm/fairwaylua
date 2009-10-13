local Player = FindMetaTable("Player")

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