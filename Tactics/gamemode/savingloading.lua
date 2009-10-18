function Save(ply)
	local Steam = string.Replace(ply:SteamID(),":",";")
	local FilePath1 = "Tactics/"..Steam.."/playerinfo.txt"
	local Savetable = {}
	Savetable["Name"] = ply:Nick()
	Savetable["Cash"] = ply:GetNWInt("Cash")
	Savetable["Perks"] = ply.Perks
	Savetable["Locker"] = ply.Locker
	Savetable["Weapon1"] = ply:GetNWInt("Weapon1")
	Savetable["Weapon2"] = ply:GetNWInt("Weapon2")
	local StrindedItems = util.TableToKeyValues(Savetable)
	file.Write(FilePath1,StrindedItems)
end

function Load(ply)
	local Steam = string.Replace(ply:SteamID(),":",";")
	local FilePath1 = "Tactics/"..Steam.."/playerinfo.txt"
	if not file.Exists(FilePath1) then
		ply:SetNWInt("cash",0)
		ply.Locker = {}
		ply.Perks = {}
		ply:SetNWBool("LockerZone", false)
		ply:SetNWBool("PvpFlag", false)
		ply:SetNWInt("MaxHp", 100)
		ply:AddWeaponToLocker("weapon_p220_tx")
		ply:SetNWInt("ActiveWeapon", 1)
		ply:SetNWInt("Weapon1", 1)
	elseif file.Exists(FilePath1) then
		local savetable = util.KeyValuesToTable(file.Read(FilePath1) )
		local lock = savetable["locker"]
		local cash = savetable["cash"]
		local purks = savetable["perks"]
		ply:SetNWInt("cash", tonumber(cash))
		ply:SetNWInt("Weapon1", tonumber(savetable["weapon1"]))
		ply:SetNWInt("Weapon2", tonumber(savetable["weapon2"]))
		ply:SetNWInt("ActiveWeapon", ply:GetNWInt("Weapon1"))
		ply.Locker = {}
		ply.Perks = {}
		for k,v in pairs(lock) do
			ply:AddWeaponToLocker(v.weapon,
			tonumber(v.maxpoints),
			tonumber(v.pwrlvl), 
			tonumber(v.acclvl),
			tonumber(v.clplvl),
			tonumber(v.spdlvl),
			tonumber(v.reslvl))	
		end
		PrintTable(ply.Locker)
		if purks != nil then
			for k,v in pairs(purks) do 
				ply.Perks[tostring(k)] = v
			end
		end
		PrintTable(ply.Perks)
		PrintTable(ply.Locker)		
		print("loaded")
	end
	timer.Simple(10,function() Save(ply) end)
	SendDataToAClient(ply)
end