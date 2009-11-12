GM.CurrentPath = {}
GM.Ghost = nil
GM.GhostPath = {}
GM.FramesPerSecond = 40
GM.GhostPathCurrentFrame = 1
GM.RaceTime = 0
GM.BestTime = 99999999

function StartRecording()
	local client = LocalPlayer()
	local entKart = client:GetNWEntity("Cart")
	if entKart then
		GAMEMODE.RaceTime = 0
		timer.Create("mk_ghost_recording", 1 / GAMEMODE.FramesPerSecond, 0, RecordFrame)
	end
end
concommand.Add("mk_startRecording", StartRecording)

function RecordFrame()
	local client = LocalPlayer()
	local entKart = client:GetNWEntity("Cart")
	if entKart then
		local tblNewKeyFrame = {}
		tblNewKeyFrame.Position = entKart:GetPos()
		tblNewKeyFrame.Angles = entKart:GetAngles()
		table.insert(GAMEMODE.CurrentPath, tblNewKeyFrame)
	end
	GAMEMODE.RaceTime = GAMEMODE.RaceTime + (1 / GAMEMODE.FramesPerSecond)
end

function StopRecording()
	local client = LocalPlayer()
	local entKart = client:GetNWEntity("Cart")
	if entKart && GAMEMODE.CurrentPath then
		if GAMEMODE.RaceTime < GAMEMODE.BestTime then
			GAMEMODE.GhostPath = GAMEMODE.CurrentPath
			GAMEMODE.BestTime = GAMEMODE.RaceTime
			client:PrintMessage(HUD_PRINTCENTER, "Best Time!")
		end
		GAMEMODE.CurrentPath = {}
		GAMEMODE.GhostPathCurrentFrame = 1
		if !GAMEMODE.Ghost then
			GAMEMODE.Ghost = ents.Create("prop_physics")
			GAMEMODE.Ghost:SetPos(entKart:GetPos())
			GAMEMODE.Ghost:SetModel("models/gmodcart/base_cart.mdl")
			GAMEMODE.Ghost:SetMoveType(MOVETYPE_VPHYSICS)
			GAMEMODE.Ghost:SetSolid(SOLID_VPHYSICS)
			GAMEMODE.Ghost:SetCollisionGroup(11)
			GAMEMODE.Ghost:SetColor(255, 255, 255, 50)
			GAMEMODE.Ghost:Spawn()
		end
		timer.Create("mk_ghost_playing", 1 / GAMEMODE.FramesPerSecond, 0, function()
			PlayFrame()
		end)
		StartRecording()
	end
end
concommand.Add("mk_stopRecording", StopRecording)

function PlayFrame()
	local client = LocalPlayer()
	local entKart = client:GetNWEntity("Cart")
	if entKart && GAMEMODE.CurrentPath && GAMEMODE.GhostPath && GAMEMODE.Ghost then
		local tblFrame = GAMEMODE.GhostPath[GAMEMODE.GhostPathCurrentFrame]
		if tblFrame then
			GAMEMODE.Ghost:SetPos(tblFrame.Position)
			GAMEMODE.Ghost:SetAngles(tblFrame.Angles)
		end
	end
	GAMEMODE.GhostPathCurrentFrame = GAMEMODE.GhostPathCurrentFrame + 1
end