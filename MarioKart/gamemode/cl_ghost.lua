GM.CurrentPath = {}
GM.Ghost = nil
GM.GhostPath = {}
GM.GhostPathSubFrame = 10
GM.GhostPathCurrentFrame = 1

function StartRecording()
	local client = LocalPlayer()
	local entKart = client:GetNWEntity("Cart")
	if entKart then
		timer.Create("mk_ghost_recording", 0.005, 0, RecordFrame)
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
end

function StopRecording()
	local client = LocalPlayer()
	local entKart = client:GetNWEntity("Cart")
	if entKart && GAMEMODE.CurrentPath then
		GAMEMODE.GhostPath = GAMEMODE.CurrentPath
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
		
		timer.Create("mk_ghost_playing", 0.005, 0, function()
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
			local difrence = (tblFrame.Position - GAMEMODE.Ghost:GetPos()) / GAMEMODE.GhostPathSubFrame
			GAMEMODE.Ghost:SetPos(tblFrame.Position)
			--GAMEMODE.Ghost:SetPos(GAMEMODE.Ghost:GetPos() + difrence)
			GAMEMODE.Ghost:SetAngles(tblFrame.Angles)
		end
	end
	--GAMEMODE.GhostPathSubFrame = GAMEMODE.GhostPathSubFrame - 1
	--if GAMEMODE.GhostPathSubFrame <= 0 then
		GAMEMODE.GhostPathCurrentFrame = GAMEMODE.GhostPathCurrentFrame + 1
	--end
end