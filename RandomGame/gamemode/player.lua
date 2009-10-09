include( 'shared.lua' )

-- Saving / Loading
function Save(ply)
	local Steam = string.Replace(ply:SteamID(),":",";")
	local FilePath1 = "SSG/"..Steam.."/playerinfo.txt"
	local Savetable = {}
	Savetable["Money"] = ply:GetNWInt("Money")
	Savetable["Upgrades"] = ply.Upgrades
	local StrindedItems = util.TableToKeyValues(Savetable)
	file.Write(FilePath1,StrindedItems)
end

function Load(ply)
	local Steam = string.Replace(ply:SteamID(),":",";")
	local FilePath1 = "SSG/"..Steam.."/playerinfo.txt"
	if not file.Exists(FilePath1) then
		ply:SetNWInt("Money",500)
		ply.Locker = {}
		ply:SetNWInt("Weapon1",0)
		ply:SetNWInt("Weapon2",0)
	elseif file.Exists(FilePath1) then
		local savetable = util.KeyValuesToTable(file.Read(FilePath1) )
		local upg = savetable["upgrades"]
		local muney = savetable["money"]
		ply:SetNWInt("Money",tonumber(muney) )
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