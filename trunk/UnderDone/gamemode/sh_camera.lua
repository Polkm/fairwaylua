GM.IdealCammeraDistance = 100
GM.AddativeCammeraDistance = 0
GM.CammeraSmoothness = 5
GM.LastLookPos = nil

local Player = FindMetaTable("Player")
function Player:GetIdealCamPos()
	local vecPosition = self:GetPos()
	local intDistance = GAMEMODE.IdealCammeraDistance + GAMEMODE.AddativeCammeraDistance
	local intEditorRadiants = GAMEMODE.PapperDollEditor.CurrentCamRotation
	local intEditorDistance = GAMEMODE.PapperDollEditor.CurrentCamDistance
	if intEditorRadiants or intEditorDistance then
		intDistance = intDistance + (intEditorDistance or 0)
		local intAddedHeight = 75
		vecPosition.x = vecPosition.x + (math.cos(math.rad(intEditorRadiants or 0)) * intDistance)
		vecPosition.y = vecPosition.y + (math.sin(math.rad(intEditorRadiants or 0)) * intDistance)
		vecPosition.z = vecPosition.z + intAddedHeight
	else
		vecPosition = vecPosition + (self:EyeAngles():Forward() * -intDistance) + Vector(0, 0, 85)
	end
	return vecPosition
end
function Player:GetIdealCamAngle()
	local vecOldPosition = GAMEMODE.LastLookPos or LocalPlayer():GetEyeTraceNoCursor().HitPos
	local vecLookPos = vecOldPosition + ((LocalPlayer():GetEyeTraceNoCursor().HitPos - vecOldPosition) / (GAMEMODE.CammeraSmoothness / 2))
	local intEditorRadiants = GAMEMODE.PapperDollEditor.CurrentCamRotation
	if intEditorRadiants then
		vecLookPos = LocalPlayer():GetPos() + Vector(0, 0, 55)
	end
	local vecToLookPos = (vecLookPos - LocalPlayer():GetIdealCamPos())
	GAMEMODE.LastLookPos = vecLookPos
	return vecToLookPos:Angle()
end

if SERVER then
	function PlayerSpawnHook(plySpawned)
		local entViewEntity = ents.Create("prop_dynamic")
		entViewEntity:SetModel("models/error.mdl")
		entViewEntity:Spawn()
		entViewEntity:SetMoveType(MOVETYPE_NONE)
		entViewEntity:SetParent(plySpawned)
		entViewEntity:SetPos(plySpawned:GetPos())
		entViewEntity:SetRenderMode(RENDERMODE_NONE)
		entViewEntity:SetSolid(SOLID_NONE)
		entViewEntity:SetNoDraw(true)
		plySpawned:SetViewEntity(entViewEntity)
	end
	hook.Add("PlayerSpawn", "PlayerSpawnHook", PlayerSpawnHook)
else
	function GM:StutteryFix()
		local client = LocalPlayer()
		local frameTime = (FrameTime() * 100)
		client.AntiStutterAnimate = client.AntiStutterAnimate or 0
		if client:Crouching() then
			client.AntiStutterAnimate = client.AntiStutterAnimate + (client:GetVelocity():Length() / 5000 * frameTime)
		end
		if not client:Crouching() and not client:KeyDown(IN_WALK) then
			client.AntiStutterAnimate = client.AntiStutterAnimate + (client:GetVelocity():Length() / 12000 * frameTime)
		end
		if client:KeyDown(IN_WALK) then
			client.AntiStutterAnimate = client.AntiStutterAnimate + (client:GetVelocity():Length() / 6000 * frameTime)
		end
		client:SetCycle(client.AntiStutterAnimate)
		if client.AntiStutterAnimate > 1 then client.AntiStutterAnimate = 0 end
	end
	function CalcViewHook(plyClient, vecOrigin, angAngles, fovFieldOfView)
		local client = plyClient
		--This is for fixing laggy animations in multiplayer for the local player (thanks CapsAdmin :D)
		antiStutterPos = (antiStutterPos or client:GetPos()) + ((client:GetPos() - (antiStutterPos or client:GetPos())) /  5)
		client:SetPos(antiStutterPos)
		if client:IsOnGround() and not SinglePlayer() then GAMEMODE:StutteryFix() end
		--end of fix
		if !GAMEMODE.CammeraPosition then GAMEMODE.CammeraPosition = client:GetPos() end
		if !GAMEMODE.CammeraAngle then GAMEMODE.CammeraAngle = Angle(0, 0, 0) end
		GAMEMODE.CammeraPosition = GAMEMODE.CammeraPosition + ((client:GetIdealCamPos() - GAMEMODE.CammeraPosition) / GAMEMODE.CammeraSmoothness)
		GAMEMODE.CammeraAngle = client:GetIdealCamAngle()
		local tblView = {}
		tblView.origin = GAMEMODE.CammeraPosition
		tblView.angles = GAMEMODE.CammeraAngle
		return tblView
	end
	hook.Add("CalcView", "CalcViewHook", CalcViewHook)
end

 
