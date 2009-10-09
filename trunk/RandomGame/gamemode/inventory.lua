include( 'shared.lua' )

function UpgradeWeapon(ply,command,args)
	local upg = ply.Locker
	local weapon = args[1]
	local trait = args[2]
	local cash = tonumber(ply:GetNWInt("Money"))
	local pwr = upg[weapon].pwrlvl
	local acc = upg[weapon].accrlvl
	local clp = upg[weapon].clplvl
	local fis = upg[weapon].spdlvl
	local res = upg[weapon].reslvl
	if trait == "Power" && upg[weapon].pwrlvl != UpgradeLevels[weapon].MaxPower then
		if cash >= UpgPrices[weapon].Power[pwr] then
			ply:SetNWInt("Money", cash - UpgPrices[weapon].Power[pwr])			
			upg[weapon].pwrlvl = upg[weapon].pwrlvl + 1
		end
	elseif trait == "Accuracy" && upg[weapon].accrlvl != UpgradeLevels[weapon].MaxAccuracy  then
		if  cash >= UpgPrices[weapon].Accuracy[acc] then	
		ply:SetNWInt("Money", cash - UpgPrices[weapon].Accuracy[acc])
		upg[weapon].accrlvl = upg[weapon].accrlvl + 1
		end
	elseif trait == "ClipSize" && upg[weapon].clplvl != UpgradeLevels[weapon].MaxClipSize then
		if  cash >= UpgPrices[weapon].ClipSize[clp] then	
			ply:SetNWInt("Money", cash - UpgPrices[weapon].ClipSize[clp])			
			upg[weapon].clplvl = upg[weapon].clplvl + 1
		end
	elseif trait == "FiringSpeed" && upg[weapon].spdlvl != UpgradeLevels[weapon].MaxFiringSpeed  then
		if  cash >= UpgPrices[weapon].FiringSpeed[fis] then	
			ply:SetNWInt("Money", cash - UpgPrices[weapon].FiringSpeed[fis])		
			upg[weapon].spdlvl = upg[weapon].spdlvl + 1
		end
	elseif trait == "ReloadSpeed" && upg[weapon].spdlvl != UpgradeLevels[weapon].MaxReloadSpeed  then
		if  cash >= UpgPrices[weapon].FiringSpeed[res] then	
			ply:SetNWInt("Money", cash - UpgPrices[weapon].FiringSpeed[res])		
			upg[weapon].reslvl = upg[weapon].reslvl + 1
		end
	end
	if ply:GetActiveWeapon():GetClass() == Weapons[weapon].Weapon then
		ply:GetActiveWeapon():Update()
	end
end
concommand.Add("UpgradeWeapon",UpgradeWeapon)
