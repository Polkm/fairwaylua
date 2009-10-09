function Save(ply)
	local Steam = string.Replace(ply:SteamID(), ":", ";")
	local FilePath1 = "SSG/"..Steam.."/playerinfo.txt"
	local Savetable = {}
	Savetable["Money"] = ply:GetNWInt("Money")
	Savetable["Weapon1"] = ply:GetNWInt("Weapon1")
	Savetable["Weapon2"] = ply:GetNWInt("Weapon2")
	Savetable["Locker"] = ply.Locker
	local StrindedInfo = util.TableToKeyValues(Savetable)
	file.Write(FilePath1, StrindedInfo)
end
function Load(ply)
	local Steam = string.Replace(ply:SteamID(), ":", ";")
	local FilePath1 = "SSG/"..Steam.."/playerinfo.txt"
	if not file.Exists(FilePath1) then
		ply:SetNWInt("Money", 500)
		ply:SetNWInt("Weapon1", 0)
		ply:SetNWInt("Weapon2", 0)
		ply.Locker = {}
	elseif file.Exists(FilePath1) then
		local LoadTable = util.KeyValuesToTable(file.Read(FilePath1))
		ply:SetNWInt("Money", tonumber(LoadTable["money"]))
		ply:SetNWInt("Weapon1", tonumber(LoadTable["weapon1"]))
		ply:SetNWInt("Weapon2", tonumber(LoadTable["weapon2"]))
		ply.Locker = savetable["locker"]
	end
	SendDataToAClient(ply)
end

function GM:PlayerInitialSpawn(ply)
	//Load(ply)
end

function GM:PlayerSpawn(ply)
	Load(ply)
	GAMEMODE:PlayerSetModel( ply )
	GAMEMODE:PlayerLoadout(ply)
	GAMEMODE:SetPlayerSpeed(ply,205,405)
end

function GM:PlayerLoadout(ply)
	ply:Give("weapon_pistol")
	ply:SelectWeapon("weapon_pistol")
	local addtable = {
	Weapon = "weapon_pistol",
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
	table.insert(ply.Locker, addtable )
	PrintTable(ply.Locker)
	SendDataToAClient(ply)
	print("sent")
end