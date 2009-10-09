include( 'shared.lua' )

-- Saving / Loading
function Save(ply)
	local Steam = string.Replace(ply:SteamID(),":",";")
	local FilePath1 = "REgmod/"..Steam.."/playerinfo.txt"
	local Savetable = {}
	Savetable["Money"] = ply:GetNWInt("Money")
	Savetable["Upgrades"] = ply.Upgrades
	local StrindedItems = util.TableToKeyValues(Savetable)
	file.Write(FilePath1,StrindedItems)
end

function Load(ply)
	local Steam = string.Replace(ply:SteamID(),":",";")
	local FilePath1 = "REgmod/"..Steam.."/playerinfo.txt"
	if not file.Exists(FilePath1) then
		ply:SetNWInt("Money",500)
		ply.Upgrades = {}
		for k,v in pairs(Weapons) do
			ply.Upgrades[k] = {pwrlvl = 1, acclvl = 1, clplvl = 1, spdlvl = 1,reslvl = 1,CanSilence = false, ChangableFireRate = false, CanGrenade = false, Maxpoints = 15 }
		end
	elseif file.Exists(FilePath1) then
		local savetable = util.KeyValuesToTable(file.Read(FilePath1) )
		local upg = savetable["upgrades"]
		local muney = savetable["money"]
		ply:SetNWInt("Money",tonumber(muney) )
		ply.Upgrades = {}
			for k,v in pairs(Weapons) do
				ply.Upgrades[k] = upg[k]
			end
		end
	SendDataToAClient(ply)
end


function GM:PlayerInitialSpawn(ply)
	Load(ply)
end