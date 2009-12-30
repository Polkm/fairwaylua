GM.IdealCammeraDistance = 50
GM.CammeraSmoothness = 15
GM.SholderCam = true

GM.LastLookPos = nil

local Player = FindMetaTable("Player")
function Player:GetIdealCamPos()
	local vecPosition = self:GetPos()
	local intDistance = GAMEMODE.IdealCammeraDistance + self.AddativeCamDistance
	vecPosition.z = vecPosition.z + 100
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
	function CalcViewHook(plyClient, vecOrigin, angAngles, fovFieldOfView)
		if !GAMEMODE.SholderCam then return end
		local client = plyClient
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

 
