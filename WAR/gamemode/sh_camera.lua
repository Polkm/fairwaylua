GM.IdealCammeraDistance = 500
GM.AddativeCamDistance = 0
GM.IdealCammeraAngle = Vector(45, 45, -85)
GM.AddativeCamAngle = Vector(0, 0, 0)
GM.CammeraSmoothness = 15
GM.OverSholder = false
GM.AimHelper = false
GM.ScrollDelta = 0

local Player = FindMetaTable("Player")

function Player:GetIdealCamPos()
	local vecPosition = self:GetPos()
	local intDistance = GAMEMODE.IdealCammeraDistance + self.AddativeCamDistance
	return vecPosition + ((GAMEMODE.IdealCammeraAngle + self.AddativeCamAngle):Normalize() * -intDistance)
	
end
function Player:GetIdealCamAngle()
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
		plySpawned:SetNoDraw(true)
	end
	hook.Add("PlayerSpawn", "PlayerSpawnHook", PlayerSpawnHook)
else
	function InitializeHook()
		if !GAMEMODE.OverSholder then
			gui.EnableScreenClicker(true)
			--vgui.GetWorldPanel():SetCursor("crosshair")
			vgui.GetWorldPanel().OnMouseWheeled = function(panel, delta)
				GAMEMODE.ScrollDelta = delta * -20
			end
		end
	end
	hook.Add("Initialize", "InitializeHook", InitializeHook)
	
	function CalcViewHook(plyClient, vecOrigin, angAngles, fovFieldOfView)
		local client = plyClient
		if !GAMEMODE.CammeraPosition then GAMEMODE.CammeraPosition = client:GetPos() end
		if !GAMEMODE.CammeraAngle then GAMEMODE.CammeraAngle = Angle(0, 0, 0) end
		client.AddativeCamAngle = Vector(0, 0, 0)
		if !client.AddativeCamDistance then client.AddativeCamDistance = 0 end
		if GAMEMODE.ScrollDelta != 0 then
			client.AddativeCamDistance = math.Clamp(client.AddativeCamDistance + GAMEMODE.ScrollDelta, -100, 1000)
			GAMEMODE.ScrollDelta = 0
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
