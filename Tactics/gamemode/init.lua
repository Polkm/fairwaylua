require("datastream")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_menus.lua")
AddCSLuaFile("cl_shopmenu.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("JDraw.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("player.lua")
include("ex_player.lua")
include("commands.lua")
include("resoucre.lua")
include("savingloading.lua")
GM.PlayerSpawnTime = {}
GM.MaxWeapons = 400
GM.WeaponsDataBase = {}
GM.WeaponNames = {
	RandomWords = {
		"sling",
		"loune",
		"howler",
		"yelp",
		"ter",
		"tor",
		"shun",
		"phat",
		"pour",
		"vent",
		"quot",
		"beun",
		"nuh",
		"fancler",
		"tram",
		"fling",
		"flonger",
		"kout",
		"gen",
		"doul",
		"wulel",
	},
	RandomModel = {
		"ac2",
		"45",
		"ge52",
		"4",
		"ju6",
		"ki7",
		"ux3",
		"em7",
	}
}
GM.ElementalLevels = 5
GM.ElementTypes = {
	"Incindiary",
	"Shock",
	"Explosive",
	"Acidic",
}

function GM:Initialize()
	timer.Simple(2, function()
		for i=1, GAMEMODE.MaxWeapons do
			CreateWeapon()
		end
		--table.sort(teastpowertable)
		--PrintTable(teastpowertable)
		--[[table.SortByMember(GAMEMODE.WeaponsDataBase, "Power")
		for k,v in pairs(GAMEMODE.WeaponsDataBase) do
			--print(v.Power)
		end]]
		--PrintTable(GAMEMODE.WeaponsDataBase)
	end)
end

function CreateName()
	local strBaseName = GAMEMODE.WeaponNames.RandomWords[math.random(1, #GAMEMODE.WeaponNames.RandomWords)]
	local strHalfBaseName = string.sub(strBaseName, 1, math.Round(string.len(strBaseName) / 2))
	local strSecondName = GAMEMODE.WeaponNames.RandomWords[math.random(1, #GAMEMODE.WeaponNames.RandomWords)]
	local strHalfSecondName = string.sub(strSecondName, math.Round(string.len(strSecondName) / 2))
	strBaseName = strHalfBaseName .. strHalfSecondName
	local strEnding = GAMEMODE.WeaponNames.RandomModel[math.random(1, #GAMEMODE.WeaponNames.RandomModel)]
	local intRandomNumber = math.random(-5, 9)
	if intRandomNumber >= 0 then strEnding = strEnding .. intRandomNumber end
	intRandomNumber = math.random(-5, 5)
	local strRandomLetter = string.lower(string.char(math.random(65, 90)))
	if intRandomNumber >= 0 then strEnding = strRandomLetter .. strEnding end
	return strBaseName .. "_" .. strEnding
end

teastpowertable = {}

function CreateWeapon()
	if #GAMEMODE.WeaponsDataBase < GAMEMODE.MaxWeapons then
		local strPickedName = CreateName()
		if GAMEMODE.WeaponsDataBase[strPickedName] then CreateWeapon() return end
		GAMEMODE.WeaponsDataBase[strPickedName] = {}
		local tblLowWeapon = {Power = 1, Accuracy = 35}
		local tblPickedWeapon = table.Random(GAMEMODE.WeaponsDataBase)
		if tblPickedWeapon && tblPickedWeapon.Power != nil then
			tblLowWeapon = tblPickedWeapon
		end

		local intRandomPower = math.Rand(tblLowWeapon.Power, (tblLowWeapon.Power * 2))
		local intPower = math.Round(math.Clamp(intRandomPower, 1, intRandomPower))
		GAMEMODE.WeaponsDataBase[strPickedName].Power = intPower
		
		--print(tblLowWeapon.Power, intPower, (tblLowWeapon.Power * 2))
		table.insert(teastpowertable, intPower)
		
		local intRandomAccuracy = math.Rand((tblLowWeapon.Accuracy * 0.9), (tblLowWeapon.Accuracy * 1.5))
		local intAccuracy = math.Round(math.Clamp(intRandomAccuracy, 1, 150))
		GAMEMODE.WeaponsDataBase[strPickedName].Accuracy = intAccuracy
		
		local intAttributeValue = (intPower / 3) + (intAccuracy / 60) --+ (intFireRate / 10) + (intClipSize / 50)
		local intMinLevel = math.Round(intAttributeValue)
		GAMEMODE.WeaponsDataBase[strPickedName].MinLevel = intMinLevel
		local intPrice = math.Round((intAttributeValue * 200) + math.random(-5, 5))
		GAMEMODE.WeaponsDataBase[strPickedName].Price = intPrice
	end
end

function SendDataToAClient(ply) 
	datastream.StreamToClients(ply, "LockerTransfer", {LockerTable = ply.Locker, PerkPerkPerk = ply.Perks}) 
	if ply.Locker[ply:GetNWInt("Weapon1")] && ply:GetWeapon(ply.Locker[ply:GetNWInt("Weapon1")].Weapon) then
		ply:GetWeapon(ply.Locker[ply:GetNWInt("Weapon1")].Weapon):Update()
	end
	if ply.Locker[ply:GetNWInt("Weapon2")] && ply:GetWeapon(ply.Locker[ply:GetNWInt("Weapon2")].Weapon) then
		ply:GetWeapon(ply.Locker[ply:GetNWInt("Weapon2")].Weapon):Update()
	end
end
concommand.Add("tx_updatelocker", SendDataToAClient)

function GM:OnNPCKilled(victim, killer, weapon)
	if killer:IsPlayer() then
		local NpcDataTable = NPCData[victim:GetClass()]
		local drops = {}
		--Ammo
		local AmmoDrop = NPCData["default"].AmmoDrop
		if type(NpcDataTable.AmmoDrop) == "boolean" then AmmoDrop = NpcDataTable.AmmoDrop end
		local RandomAmount = AmmoSizes[math.random(1, 8)]
		if AmmoDrop && type(RandomAmount) == "string" && RandomAmount != "full" then
			table.insert(drops, {type = "ammo", amount = RandomAmount})
		end
		--Health
		local HealthDrop = NPCData["default"].HealthDrop
		if type(NpcDataTable.HealthDrop) == "boolean" then HealthDrop = NpcDataTable.HealthDrop end
		local RandomAmount = HealthSizes[math.random(1, 70)]
		if HealthDrop && type(RandomAmount) == "string"then
			table.insert(drops, {type = "health", amount = RandomAmount})
		end
		--Cash
		local CashDrop = NPCData["default"].CashDrop
		if type(NpcDataTable.CashDrop) == "boolean" then CashDrop = NpcDataTable.CashDrop end
		local CashToDrop = NpcDataTable.CashToDrop or NPCData["default"].CashToDrop
		local RandomAmount = math.random(CashToDrop - 5, CashToDrop + 5)
		local IsGoingToDrop = math.random(1, 2)
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
				timer.Simple(60, function() if reward:IsValid() then reward:Remove() end end)
			end
		end 
	end
end
