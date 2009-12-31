GM.IdealCammeraDistance = 100
GM.CammeraSmoothness = 10
GM.SholderCam = true

GM.LastLookPos = nil

local Player = FindMetaTable("Player")
function Player:GetIdealCamPos()
	local vecPosition = self:GetPos()
	local intDistance = GAMEMODE.IdealCammeraDistance + self.AddativeCamDistance
	vecPosition.z = vecPosition.z + ( (self:EyeAngles():Forward() * -intDistance).z) + 85
	local angForward = (self:EyeAngles():Forward() * -intDistance)
	angForward.z = 0
	vecPosition = vecPosition + angForward
	vecPosition = vecPosition + (self:EyeAngles():Right() * 0)
	
	return vecPosition
end
function Player:GetIdealCamAngle()
	--local vecToLookPos = LocalPlayer():GetEyeTraceNoCursor().HitPos - LocalPlayer():GetIdealCamPos()
	local vecOldPosition = GAMEMODE.LastLookPos or LocalPlayer():GetEyeTraceNoCursor().HitPos
	local vecLookPos = vecOldPosition + ((LocalPlayer():GetEyeTraceNoCursor().HitPos - vecOldPosition) / 5)
	local vecToLookPos = (vecLookPos - LocalPlayer():GetIdealCamPos())
	GAMEMODE.LastLookPos = vecLookPos
	return vecToLookPos:Angle()
end

if SERVER then
	function PlayerSpawnHook(plySpawned)
		if !GAMEMODE.SholderCam then return end
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
		if !GAMEMODE.SholderCam then return end
		local client = plyClient
		--This is for fixing laggy animations in multiplayer for the local player (thanks CapsAdmin :D)
		antiStutterPos = (antiStutterPos or client:GetPos()) + ((client:GetPos() - (antiStutterPos or client:GetPos())) /  5)
		client:SetPos(antiStutterPos)
		if client:IsOnGround() and not SinglePlayer() then GAMEMODE:StutteryFix() end
		--end of fix
		if !GAMEMODE.CammeraPosition then GAMEMODE.CammeraPosition = client:GetPos() end
		if !GAMEMODE.CammeraAngle then GAMEMODE.CammeraAngle = Angle(0, 0, 0) end
		client.AddativeCamAngle = Vector(0, 0, 0)
		client.AddativeCamDistance = 0
		GAMEMODE.CammeraPosition = GAMEMODE.CammeraPosition + ((client:GetIdealCamPos() - GAMEMODE.CammeraPosition) / GAMEMODE.CammeraSmoothness)
		GAMEMODE.CammeraAngle = client:GetIdealCamAngle()
		local tblView = {}
		tblView.origin = GAMEMODE.CammeraPosition
		tblView.angles = GAMEMODE.CammeraAngle
		return tblView
	end
	hook.Add("CalcView", "CalcViewHook", CalcViewHook)
end

 
