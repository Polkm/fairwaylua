function UpgradeWeapon(ply, command, args)
	local tblLocker = ply.Locker
	local intWeapon = tonumber(args[1])
	local strWeapon = tblLocker[intWeapon].Weapon
	local strTrait = tostring(args[2])
	local intCash = tonumber(ply:GetNWInt("cash"))
	local intMaxPoints = tblLocker[intWeapon].Maxpoints
	local intPowerLevel = tblLocker[intWeapon].pwrlvl
	local intAccuracyLevel = tblLocker[intWeapon].acclvl
	local intClipSizeLevel = tblLocker[intWeapon].clplvl
	local intFiringSpeedLevel = tblLocker[intWeapon].spdlvl
	local intReloadSpeedLevel = tblLocker[intWeapon].reslvl
	local intCurrentPoints = intPowerLevel + intAccuracyLevel + intClipSizeLevel + intFiringSpeedLevel + intReloadSpeedLevel
	if intCurrentPoints < intMaxPoints then
		if strTrait == "Power" && intPowerLevel < #Weapons[strWeapon].UpGrades.Power then
			local intPrice = Weapons[strWeapon].UpGrades.Power[intPowerLevel].Price
			if intCash >= intPrice then
				ply:SetNWInt("cash", intCash - intPrice)
				tblLocker[intWeapon].pwrlvl = tblLocker[intWeapon].pwrlvl + 1
			end
		elseif strTrait == "Accuracy" && intAccuracyLevel < #Weapons[strWeapon].UpGrades.Accuracy then
			local intPrice = Weapons[strWeapon].UpGrades.Accuracy[intAccuracyLevel].Price
			if intCash >= intPrice then
				ply:SetNWInt("cash", intCash - intPrice)
				tblLocker[intWeapon].acclvl = tblLocker[intWeapon].acclvl + 1
			end
		elseif strTrait == "ClipSize" && intClipSizeLevel < #Weapons[strWeapon].UpGrades.ClipSize then
			local intPrice = Weapons[strWeapon].UpGrades.ClipSize[intClipSizeLevel].Price
			if intCash >= intPrice then
				ply:SetNWInt("cash", intCash - intPrice)
				tblLocker[intWeapon].clplvl = tblLocker[intWeapon].clplvl + 1
			end
		elseif strTrait == "FiringSpeed" && intFiringSpeedLevel < #Weapons[strWeapon].UpGrades.FiringSpeed then
			local intPrice = Weapons[strWeapon].UpGrades.FiringSpeed[intFiringSpeedLevel].Price
			if intCash >= intPrice then
				ply:SetNWInt("cash", intCash - intPrice)
				tblLocker[intWeapon].spdlvl = tblLocker[intWeapon].spdlvl + 1
			end
		elseif strTrait == "ReloadSpeed" && intReloadSpeedLevel < #Weapons[strWeapon].UpGrades.ReloadSpeed then
			local intPrice = Weapons[strWeapon].UpGrades.ReloadSpeed[intReloadSpeedLevel].Price
			if intCash >= intPrice then
				ply:SetNWInt("cash", intCash - intPrice)
				tblLocker[intWeapon].reslvl = tblLocker[intWeapon].reslvl + 1
			end
		end
		SendDataToAClient(ply)
	end
end
concommand.Add("tx_upgradeweapon", UpgradeWeapon)

function SellWeapon(ply,command,args)
	local tblLocker = ply.Locker
	local intWeapon = tonumber(args[1])
	local intCash = tonumber(ply:GetNWInt("cash"))
	local intValue = ply:GetWeaponValue(intWeapon)
	ply:DepositWeapon(intWeapon)
	ply:StripWeapon(tblLocker[intWeapon].Weapon)
	ply:SetNWInt("cash", intCash + intValue)
	tblLocker[intWeapon] = nil
	SendDataToAClient(ply)
end
concommand.Add("tx_sellweapon",SellWeapon)

function BuyWeapon(ply,command,args)
	local lock = ply.Locker
	local weapon = args[1]
	local cash = tonumber(ply:GetNWInt("cash"))
	print(Weapons[weapon].Price)
	if cash >= Weapons[weapon].Price then
		ply:SetNWInt("cash", cash - Weapons[weapon].Price)
		ply:AddWeaponToLocker(Weapons[weapon].Weapon)
	end
	SendDataToAClient(ply)
end
concommand.Add("tx_buyweapon", BuyWeapon)