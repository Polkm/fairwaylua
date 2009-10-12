require("datastream")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_menus.lua")
include("shared.lua")
include("resoucre.lua")
include("ex_player.lua")
GM.PlayerSpawnTime = {}
NodesManifest = {}

function SendDataToAClient(ply) 
	datastream.StreamToClients(ply, "LockerTransfer", {LockerTable = ply.Locker}) 
end
concommand.Add("LockerUpdate",SendDataToAClient)


function GM:Initialize()
	timer.Simple(1, function() AfterLoad() end)
	timer.Simple(5, function() SpawnARandomNPC() end)
end

function AfterLoad()
	NodesManifest = {}
	table.Add(NodesManifest, ents.FindByClass("path_corner"))
	table.Add(NodesManifest, ents.FindByClass("ai_hint"))
	--table.Add(NodesManifest, ents.FindByClass("info_node"))
end

function GM:OnNPCKilled(victim, killer, weapon)
	if killer:IsPlayer() then
		local NpcDataTable = NPCData[victim:GetClass()]
		local drops = {}
		--Ammo
		local AmmoDrop = NPCData["default"].AmmoDrop
		if type(NpcDataTable.AmmoDrop) == "boolean" then AmmoDrop = NpcDataTable.AmmoDrop end
		local RandomAmount = AmmoSizes[math.random(1, 10)]
		if AmmoDrop && type(RandomAmount) == "string" then
			table.insert(drops, {type = "ammo", amount = RandomAmount})
		end
		--Health
		local HealthDrop = NPCData["default"].HealthDrop
		if type(NpcDataTable.HealthDrop) == "boolean" then HealthDrop = NpcDataTable.HealthDrop end
		local RandomAmount = HealthSizes[math.random(1, 30)]
		if HealthDrop && type(RandomAmount) == "string"then
			table.insert(drops, {type = "health", amount = RandomAmount})
		end
		--Cash
		local CashDrop = NPCData["default"].CashDrop
		if type(NpcDataTable.CashDrop) == "boolean" then CashDrop = NpcDataTable.CashDrop end
		local CashToDrop = NpcDataTable.CashToDrop or NPCData["default"].CashToDrop
		local RandomAmount = math.random(CashToDrop - 5, CashToDrop + 5)
		local IsGoingToDrop = math.random(0, 5)
		if CashToDrop && RandomAmount > 0 && IsGoingToDrop == 1 then
			table.insert(drops, {type = "cash", amount = RandomAmount})
		end
		--Makin the reward
		if #drops > 0 then
			for _, drop in pairs(drops) do
				local reward = ents.Create("ent_reward")
				reward:SetPos(victim:GetPos() + Vector(0, 0, 20))
				reward:SetType(drop.type)
				reward:SetAmount(drop.amount)
				reward:SetNWEntity("PropProtector", killer)
				reward:Spawn()
				timer.Simple(10, function() if reward:IsValid() then reward:SetNWEntity("PropProtector", "none") end end)
				timer.Simple(40, function() if reward:IsValid() then reward:Remove() end end)
			end
		end
	end
end

function SpawnARandomNPC()
	if #ents.FindByClass("npc_zombie") < 30 then
		local randomNode = NodesManifest[math.random(1, #NodesManifest)]
		local zombie = ents.Create("npc_zombie")
		zombie:SetPos(randomNode:GetPos())
		zombie:SetKeyValue("spawnflags",tostring(512))
		zombie:Spawn()
	end
	timer.Simple(3, function() SpawnARandomNPC() end)
end

-- Lockers

function DepositWeapon(ply,command,args)
	local lock = ply.Locker
	local weaponid = tonumber(args[1])
	local wep1 = ply:GetNWInt("Weapon1")
	local wep2 = ply:GetNWInt("Weapon2")
	if wep1 == weaponid then
		ply:StripWeapon(lock[weaponid].Weapon)
		ply:SetNWInt("Weapon1", 0)
		if wep1 == ply:GetNWInt("ActiveWeapon") && wep2 > 0 && wep2 != 1337  then 
			ply:SetNWInt("ActiveWeapon", 0)
			ply:ConCommand("FS_SwitchWep")
		elseif wep1 == ply:GetNWInt("ActiveWeapon") && wep2 < 0 && wep2 != 1337 then 
			ply:SetNWInt("ActiveWeapon", 1337)
			ply:SelectWeapon(lock[ply:GetNWInt("ActiveWeapon")].Weapon)
		end
	elseif wep2 == weaponid then
		ply:StripWeapon(lock[weaponid].Weapon)
		ply:SetNWInt("Weapon2", 0)
		if wep2 == ply:GetNWInt("ActiveWeapon") && wep1 > 0 && wep1 != 1337 then 
			ply:SetNWInt("ActiveWeapon", 0)
			ply:ConCommand("FS_SwitchWep")
		elseif wep2 == ply:GetNWInt("ActiveWeapon") && wep1 < 0 && wep1 != 1337 then 
			ply:SetNWInt("ActiveWeapon", 1337)
			ply:SelectWeapon(lock[ply:GetNWInt("ActiveWeapon")].Weapon)
		end
	else 
		return
	end
	SendDataToAClient(ply)
end
concommand.Add("DepositWeapon",DepositWeapon)

function WithdrawWeapon(ply,command,args)
	local lock = ply.Locker
	local weaponid = tonumber(args[1])
	local wep1 = ply:GetNWInt("Weapon1")
	local wep2 = ply:GetNWInt("Weapon2")
	if wep1 == 0 || wep1 == 1337 then
		ply:Give(lock[weaponid].Weapon)
		ply:SetNWInt("Weapon1", weaponid)
		if wep1 == ply:GetNWInt("ActiveWeapon") && wep2 > 0 && wep2 != 1337 then 
			ply:SetNWInt("ActiveWeapon", 0)
		else
			ply:ConCommand("FS_SwitchWep")
		end
	elseif wep2 == 0 || wep2 == 1337 && wep1 > 0 then
		ply:Give(lock[weaponid].Weapon)
		ply:SetNWInt("Weapon2", weaponid)
		if wep2 == ply:GetNWInt("ActiveWeapon") && wep1 > 0 && wep1 != 1337 then 
			ply:SetNWInt("ActiveWeapon", 0)
		else
			ply:ConCommand("FS_SwitchWep")
		end
	else 
		return
	end
	SendDataToAClient(ply)
end
concommand.Add("WithdrawWeapon",WithdrawWeapon)





function UpgradeWeapon(ply,command,args)
	local upg = ply.Locker
	local weapon = args[1]
	local trait = args[2]
	local cash = tonumber(ply:GetNWInt("Money") + 500000)
	local pwr = upg[weapon].pwrlvl
	local acc = upg[weapon].accrlvl
	local clp = upg[weapon].clplvl
	local fis = upg[weapon].spdlvl
	local res = upg[weapon].reslvl
	if trait == "Power" && upg[weapon].pwrlvl != #Weapons[weapon].UpGrades.Power then
		if cash >= Weapons[weapon].UpGrades.Power[pwr] then
			ply:SetNWInt("Money", cash - Weapons[weapon].Upgrades[Power].Price[pwr])			
			upg[weapon].pwrlvl = upg[weapon].pwrlvl + 1
		end
	elseif trait == "Accuracy" && upg[weapon].acclvl != #Weapons[weapon].UpGrades.Accuracy then
		if  cash >= UpgPrices[weapon].Accuracy[acc] then	
		ply:SetNWInt("Money", cash - Weapons[weapon].Upgrades[Accuracy].Price[acc])
		upg[weapon].accrlvl = upg[weapon].accrlvl + 1
		end
	elseif trait == "ClipSize" && upg[weapon].clplvl != #Weapons[weapon].UpGrades.ClipSize then
		if  cash >= UpgPrices[weapon].ClipSize[clp] then	
			ply:SetNWInt("Money", cash - Weapons[weapon].Upgrades[ClipSize].Price[clp])			
			upg[weapon].clplvl = upg[weapon].clplvl + 1
		end
	elseif trait == "FiringSpeed" && upg[weapon].spdlvl != #Weapons[weapon].UpGrades.FiringSpeed  then
		if  cash >= UpgPrices[weapon].FiringSpeed[fis] then	
			ply:SetNWInt("Money", cash - Weapons[weapon].UpGrades[FiringSpeed].Price[fis])		
			upg[weapon].spdlvl = upg[weapon].spdlvl + 1
		end
	elseif trait == "ReloadSpeed" && upg[weapon].spdlvl != #Weapons[weapon].UpGrades.ReloadSpeed  then
		if  cash >= UpgPrices[weapon].FiringSpeed[res] then	
			ply:SetNWInt("Money", cash - Weapons[weapon].UpGrades[ReloadSpeed].Price[res])		
			upg[weapon].reslvl = upg[weapon].reslvl + 1
		end
	end
	if ply:GetActiveWeapon():GetClass() == Weapons[weapon].Weapon then
		ply:GetActiveWeapon():Update()
	end
end
concommand.Add("UpgradeWeapon",UpgradeWeapon)
