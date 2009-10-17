require("datastream")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_menus.lua")
AddCSLuaFile("cl_shopmenu.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_scoreboard.lua")
include("shared.lua")
include("player.lua")
include("ex_player.lua")
include("resoucre.lua")
GM.PlayerSpawnTime = {}
NodesManifest = {}

function SendDataToAClient(ply) 
	datastream.StreamToClients(ply, "LockerTransfer", {LockerTable = ply.Locker, PerkPerkPerk = ply.Perks}) 
end
concommand.Add("LockerUpdate",SendDataToAClient)

function GM:Initialize()
	timer.Simple(1, function() AfterLoad() end)
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
		local RandomAmount = AmmoSizes[math.random(1, 25)]
		if AmmoDrop && type(RandomAmount) == "string" && RandomAmount != "full" then
			table.insert(drops, {type = "ammo", amount = RandomAmount})
		end
		--Health
		local HealthDrop = NPCData["default"].HealthDrop
		if type(NpcDataTable.HealthDrop) == "boolean" then HealthDrop = NpcDataTable.HealthDrop end
		local RandomAmount = HealthSizes[math.random(1, 50)]
		if HealthDrop && type(RandomAmount) == "string"then
			table.insert(drops, {type = "health", amount = RandomAmount})
		end
		--Cash
		local CashDrop = NPCData["default"].CashDrop
		if type(NpcDataTable.CashDrop) == "boolean" then CashDrop = NpcDataTable.CashDrop end
		local CashToDrop = NpcDataTable.CashToDrop or NPCData["default"].CashToDrop
		local RandomAmount = math.random(CashToDrop - 5, CashToDrop + 5)
		local IsGoingToDrop = math.random(0, 10)
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

function UpgradeWeapon(ply,command,args)
	local lock = ply.Locker
	local weapon = args[1]
	local trait = args[2]
	local cash = tonumber(ply:GetNWInt("cash"))
	local pwr = lock[weapon].pwrlvl
	local acc = lock[weapon].accrlvl
	local clp = lock[weapon].clplvl
	local fis = lock[weapon].spdlvl
	local res = lock[weapon].reslvl
	local maxpoints = lock[weapon].Maxpoints 
	local totalpoints = pwr + acc + clp + fis + res
	if trait == "Power" && lock[weapon].pwrlvl != #Weapons[weapon].lockrades.Power && totalpoints < maxpoints then
		if cash >= Weapons[weapon].lockrades.Power[pwr] then
			ply:SetNWInt("cash", cash - Weapons[weapon].lockrades[Power].Price[pwr])			
			lock[weapon].pwrlvl = lock[weapon].pwrlvl + 1
		end
	elseif trait == "Accuracy" && lock[weapon].acclvl != #Weapons[weapon].lockrades.Accuracy && totalpoints < maxpoints then
		if  cash >= lockPrices[weapon].Accuracy[acc] then	
		ply:SetNWInt("cash", cash - Weapons[weapon].lockrades[Accuracy].Price[acc])
		lock[weapon].accrlvl = lock[weapon].accrlvl + 1
		end
	elseif trait == "ClipSize" && lock[weapon].clplvl != #Weapons[weapon].lockrades.ClipSize && totalpoints < maxpoints then
		if  cash >= lockPrices[weapon].ClipSize[clp] then	
			ply:SetNWInt("cash", cash - Weapons[weapon].lockrades[ClipSize].Price[clp])			
			lock[weapon].clplvl = lock[weapon].clplvl + 1
		end
	elseif trait == "FiringSpeed" && lock[weapon].spdlvl != #Weapons[weapon].lockrades.FiringSpeed && totalpoints < maxpoints  then
		if  cash >= lockPrices[weapon].FiringSpeed[fis] then	
			ply:SetNWInt("cash", cash - Weapons[weapon].lockrades[FiringSpeed].Price[fis])		
			lock[weapon].spdlvl = lock[weapon].spdlvl + 1
		end
	elseif trait == "ReloadSpeed" && lock[weapon].spdlvl != #Weapons[weapon].lockrades.ReloadSpeed && totalpoints < maxpoints then
		if  cash >= lockPrices[weapon].FiringSpeed[res] then	
			ply:SetNWInt("cash", cash - Weapons[weapon].lockrades[ReloadSpeed].Price[res])		
			lock[weapon].reslvl = lock[weapon].reslvl + 1
		end
	end
	if ply:GetActiveWeapon():GetClass() == Weapons[weapon].Weapon then
		ply:GetActiveWeapon():Update()
	end
	SendDataToAClient(ply)
end
concommand.Add("tx_UpgradeWeapon", UpgradeWeapon)

function SellWeapon(ply,command,args)
	local lock = ply.Locker
	local weapon = args[1]
	local trait = args[2]
	local cash = tonumber(ply:GetNWInt("cash"))
	local pwr = lock[weapon].pwrlvl
	local acc = lock[weapon].accrlvl
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
	local price = Weapons[weapon].Price / 2 + pwraddition + accaddition + clpaddition + fisaddition
	ply:StripWeapon(lock[weapon].Weapon)
	ply:SetNWInt("cash",cash + price)
	lock[weapon] = nil
	SendDataToAClient(ply)
end
concommand.Add("tx_SellWeapon",SellWeapon)

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