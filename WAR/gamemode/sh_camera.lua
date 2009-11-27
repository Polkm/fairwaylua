GM.IdealCammeraDistance = 500
GM.IdealCammeraAngle = Vector(45, 45, -85)
GM.CammeraSmoothness = 15
GM.OverSholder = false
GM.AimHelper = false

local Player = FindMetaTable("Player")
function Player:GetIdealCamPos()
	local vecPosition = self:GetPos()
	local intDistance = GAMEMODE.IdealCammeraDistance + self.AddativeCamDistance
	if GAMEMODE.OverSholder then
		vecPosition = vecPosition + Vector(0, 0, 120)
		vecPosition = vecPosition + (self:GetAngles():Forward() * -intDistance)
	else
		vecPosition = vecPosition + Vector(0, 0, 0)
		vecPosition = vecPosition + ((GAMEMODE.IdealCammeraAngle + self.AddativeCamAngle):Normalize() * -intDistance)
	end
	return vecPosition
end
function Player:GetIdealCamAngle()
	if GAMEMODE.OverSholder then
		return self:GetAngles()
	end
	return (GAMEMODE.IdealCammeraAngle + self.AddativeCamAngle):Angle()
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
		plySpawned:SetEyeAngles(Angle(0, 45, 0))
	end
	hook.Add("PlayerSpawn", "PlayerSpawnHook", PlayerSpawnHook)
else
	function InitializeHook()
		if !GAMEMODE.OverSholder then
			gui.EnableScreenClicker(true)
			--vgui.GetWorldPanel():SetCursor("crosshair")
		end
	end
	hook.Add("Initialize", "InitializeHook", InitializeHook)
	
	function CalcViewHook(plyClient, vecOrigin, angAngles, fovFieldOfView)
		local client = plyClient
		if !GAMEMODE.CammeraPosition then GAMEMODE.CammeraPosition = client:GetPos() end
		if !GAMEMODE.CammeraAngle then GAMEMODE.CammeraAngle = Angle(0, 0, 0) end
		client.AddativeCamAngle = Vector(0, 0, 0)
		client.AddativeCamDistance = 0
		if GAMEMODE.ShowScoreboard then
			client.AddativeCamDistance = GAMEMODE.IdealCammeraDistance * 3
		end
		GAMEMODE.CammeraPosition = GAMEMODE.CammeraPosition + ((client:GetIdealCamPos() - GAMEMODE.CammeraPosition) / GAMEMODE.CammeraSmoothness)
		GAMEMODE.CammeraAngle = GAMEMODE.CammeraAngle + ((client:GetIdealCamAngle() - GAMEMODE.CammeraAngle) * (1 / GAMEMODE.CammeraSmoothness))
		local tblView = {}
		tblView.origin = GAMEMODE.CammeraPosition
		tblView.angles = GAMEMODE.CammeraAngle
		return tblView
	end
	hook.Add("CalcView", "CalcViewHook", CalcViewHook)
end