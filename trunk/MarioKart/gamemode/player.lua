function GM:PlayerInitialSpawn(ply)
	ply.Character = "Mario"
end

function GM:ShowHelp(ply)
	ply:ConCommand("mk_characterCreation")
end

function GM:PlayerDisconnected(ply)
	ply:GetNWEntity("Cart"):Remove()
end

function GM:PlayerSpawn(ply)
	if ply:GetNWEntity("Cart"):IsValid() then ply:GetNWEntity("Cart"):Remove() end
	--Kart creation
	local entKart = ents.Create("player_cart")
	entKart:SetPos(ply:GetPos())
	entKart:SetOwner(ply)
	entKart:Spawn()
	entKart:SetAngles(ply:GetAngles())
	entKart.Ragdoll:SetModel(GAMEMODE.Characters[ply.Character].Model)
	--[[local effectdata = EffectData()
	effectdata:SetEntity(entKart)
	effectdata:SetOrigin(Vector(14, -20, 30))
	util.Effect("engine_smoke", effectdata)	]]
	ply:SetNWEntity("Cart", entKart)
	ply:Spectate(MODE_CHASE)
	ply:SpectateEntity(entKart)
	ply:SetNWEntity("WatchEntity", entKart)
	ply:SetViewEntity(entKart)
	--Setting variables
	ply:SetNWInt("CheckPoint", 1)
	ply:SetNWInt("Lap", 1)
	ply:SetNWInt("Place", 1)
	ply:SetNWString("item","empty")
	ply:SetNWEntity("activeitem", "none")
	ply.Forward = GAMEMODE.Characters[ply.Character].MaxSpeed
	ply.Turn = GAMEMODE.Characters[ply.Character].MaxTurn
	ply.CanJump = true
	ply.CanSlowDown = true
	ply.CanUse = true
	ply.wipeout = false
	ply.Finished = false
	ply.SlowDown = false
	--Make the player unnoticable
	GAMEMODE:SetPlayerSpeed(ply, 0, 0)
	ply:SetPos(Vector(-40, 100, 500))
	ply:SetNoDraw(true)
	--Make the player's kart look like that last time he played
	ply:ConCommand("mk_characterDefault")
	if GetGlobalString("GameModeState") == "RACE" then
		ply:ConCommand("mk_Sound BackGround")
	end
end

function GM:SetPlayerColor(ply, strColor)
	if GAMEMODE.PosibleColors[strColor] then
		ply:GetNWEntity("Cart").BodyFrame:SetMaterial(GAMEMODE.PosibleColors[strColor])
	end
end
concommand.Add("MarioKartCRCLR", function(ply, command, args)
	--if GetGlobalString("GameModeState") != "PREP" then return end
	GAMEMODE:SetPlayerColor(ply, args[1])
end)

function GM:SetPlayerCharacter(ply, strCharacter)
	if GAMEMODE.Characters[strCharacter] then
		ply.Character = strCharacter
		ply:GetNWEntity("Cart").Ragdoll:SetModel(GAMEMODE.Characters[strCharacter].Model)
		ply.Forward = GAMEMODE.Characters[ply.Character].MaxSpeed
		ply.Turn = GAMEMODE.Characters[ply.Character].MaxTurn
	end
end
concommand.Add("MarioKartCHRCTR", function(ply, command, args)
	if GetGlobalString("GameModeState") != "PREP" then return end
	GAMEMODE:SetPlayerCharacter(ply, args[1])
end)

function GM:FireItem(ply)
	local strItem = ply:GetNWString("item")
	if ply:GetNWEntity("activeitem") == "none" && strItem != "empty" && ply.CanUse then
		GAMEMODE.mk_Items[strItem].SpawnFunction(ply)
		ply:SetNWString("item", "empty")
		return
	elseif ply:GetNWEntity("activeitem") != "none" then
		GAMEMODE.mk_Items[ply:GetNWEntity("activeitem").class].UseFunction(ply:GetNWEntity("activeitem"))
		return
	end
end
concommand.Add("mk_FireItem", function(ply, command, args)
	GAMEMODE:FireItem(ply)
end)

