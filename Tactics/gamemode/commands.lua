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
			--if intCash >= intPrice then
				--ply:SetNWInt("cash", intCash - intPrice)
				tblLocker[intWeapon].pwrlvl = tblLocker[intWeapon].pwrlvl + 1
			--end
		elseif strTrait == "Accuracy" && intAccuracyLevel < #Weapons[strWeapon].UpGrades.Accuracy then
			local intPrice = Weapons[strWeapon].UpGrades.Accuracy[intAccuracyLevel].Price
			--if intCash >= intPrice then
				--ply:SetNWInt("cash", intCash - intPrice)
				tblLocker[intWeapon].accrlvl = tblLocker[intWeapon].accrlvl + 1
			--end
		elseif strTrait == "ClipSize" && intClipSizeLevel < #Weapons[strWeapon].UpGrades.ClipSize then
			local intPrice = Weapons[strWeapon].UpGrades.ClipSize[intClipSizeLevel].Price
			--if intCash >= intPrice then
				--ply:SetNWInt("cash", intCash - intPrice)
				tblLocker[intWeapon].clplvl = tblLocker[intWeapon].clplvl + 1
			--end
		elseif strTrait == "FiringSpeed" && intFiringSpeedLevel < #Weapons[strWeapon].UpGrades.FiringSpeed then
			local intPrice = Weapons[strWeapon].UpGrades.FiringSpeed[intFiringSpeedLevel].Price
			--if intCash >= intPrice then
				--ply:SetNWInt("cash", intCash - intPrice)
				tblLocker[intWeapon].spdlvl = tblLocker[intWeapon].spdlvl + 1
			--end
		elseif strTrait == "ReloadSpeed" && intReloadSpeedLevel < #Weapons[strWeapon].UpGrades.ReloadSpeed then
			local intPrice = Weapons[strWeapon].UpGrades.ReloadSpeed[intReloadSpeedLevel].Price
			--if intCash >= intPrice then
				--ply:SetNWInt("cash", intCash - intPrice)
				tblLocker[intWeapon].reslvl = tblLocker[intWeapon].reslvl + 1
			--end
		end
		SendDataToAClient(ply)
	end
end
concommand.Add("tx_upgradeweapon", UpgradeWeapon)

concommand.Add("tx_updateweapons", function(ply, command, args)
	for k, weapon in pairs(ply.Locker) do
		if ply:HasWeapon(weapon.Weapon) then
			ply:GetWeapon(weapon.Weapon):SetNWInt("id", k)
			ply:GetWeapon(weapon.Weapon):Update()
			--print("sending updating " .. weapon.Weapon)
		end
	end
end)

function SellWeapon(ply,command,args)
	local lock = ply.Locker
	local weapon = tonumber(args[1])
	local cash = tonumber(ply:GetNWInt("cash"))
	PrintTable(lock[weapon])
	local pwr = lock[weapon].pwrlvl
	local acc = lock[weapon].acclvl
	local clp = lock[weapon].clplvl
	local fis = lock[weapon].spdlvl
	local res = lock[weapon].reslvl
	local pwraddition = 0
	local accaddition = 0
	local clpaddition = 0
	local fisaddition = 0
	if pwr > 1 then
		pwraddition = Weapons[weapon].Power[pwr] / 2 
	elseif acc > 1 then
		accaddition = Weapons[weapon].Accuracy[acc] / 2 
	elseif clp > 1 then
		clpaddition = Weapons[weapon].ClipSize[clp] / 2 
	elseif fis > 1 then
		fisaddition = Weapons[weapon].FiringSpeed[fis] / 2 
	end
	local price = Weapons[lock[weapon].Weapon].Price / 2 + pwraddition + accaddition + clpaddition + fisaddition
	ply:StripWeapon(lock[weapon].Weapon)
	ply:SetNWInt("cash", cash + price)
	lock[weapon] = nil
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