include('cl_jdraw.lua')
include('shared.lua')
include('sh_camera.lua')
include('sh_units.lua')
include('sh_locker.lua')
include('sh_util.lua')
local SelectionNode1, SelectionNode2 = Vector(0, 0, 0), Vector(0, 0, 0)
local boolBoxSellecting = false

function GM:GUIMousePressed(input)
	if input == MOUSE_LEFT then
		local intMouseX, intMouseY = gui.MousePos()
		SelectionNode1 = Vector(intMouseX, intMouseY, 0)
		boolBoxSellecting = true
	end
end

function GM:GUIMouseReleased(input)
	local client = LocalPlayer()
	local tblTraceData = {}
	tblTraceData.start = GAMEMODE.CammeraPosition
	tblTraceData.endpos = GAMEMODE.CammeraPosition + (client:GetCursorAimVector() * 10000)
	tblTraceData.filter = client
	local trcCursorTrace = util.TraceLine(tblTraceData)
	local entTraceEnt = trcCursorTrace.Entity
	if input == MOUSE_LEFT then
		local intMouseX, intMouseY = gui.MousePos()
		SelectionNode2 = Vector(intMouseX, intMouseY, 0)
		RunConsoleCommand("WAR_UnSellect")
		if GAMEMODE:IsABoxSellect(SelectionNode1, SelectionNode2) then
			for _, entity in pairs(ents.FindByClass("ent_plrunit")) do
				if GAMEMODE:IsInSellectionBox(SelectionNode1, SelectionNode2, entity:GetPos():ToScreen()) then
					RunConsoleCommand("WAR_Sellect", entity:EntIndex())
				end
			end
		else
			if entTraceEnt && entTraceEnt:IsValid() &&  entTraceEnt:GetClass() == "ent_plrunit" then
				if entTraceEnt:GetOwner() == client then
					RunConsoleCommand("WAR_Sellect", entTraceEnt:EntIndex())
				end
			end
		end
		boolBoxSellecting = false
		return true
	end
	if input == MOUSE_RIGHT then
		if trcCursorTrace.HitWorld then
			local vecHitPos = trcCursorTrace.HitPos
			RunConsoleCommand("WAR_MoveUnits", vecHitPos.x, vecHitPos.y, vecHitPos.z)
		elseif entTraceEnt && entTraceEnt:IsValid() then
			if entTraceEnt:GetClass() == "ent_plrunit" then
				RunConsoleCommand("WAR_AttackSquad", entTraceEnt:EntIndex())
			end
		end
		return true
	end
	return false
end

function GM:HUDShouldDraw(name)
	if (name == "CHudHealth" or name == "CHudBattery") then
		return false
	end
	return true
end

function GM:HUDPaint()
	local intMouseX, intMouseY = gui.MousePos()
	local vecMousePos = Vector(intMouseX, intMouseY, 0)
	if boolBoxSellecting && GAMEMODE:IsABoxSellect(SelectionNode1, vecMousePos) then
		local vecMin = Vector(math.min(SelectionNode1.x, vecMousePos.x), math.min(SelectionNode1.y, vecMousePos.y), 0)
		local vecMax = Vector(math.max(SelectionNode1.x, vecMousePos.x), math.max(SelectionNode1.y, vecMousePos.y), 0)
		surface.SetDrawColor(50, 50, 50, 100)
		surface.DrawOutlinedRect(vecMin.x, vecMin.y, vecMax.x - vecMin.x, vecMax.y - vecMin.y)
		surface.SetDrawColor(20, 150, 20, 50)
		surface.DrawRect(vecMin.x + 1, vecMin.y + 1, vecMax.x - vecMin.x - 2, vecMax.y - vecMin.y - 2)
	end
	
	for _, unit in pairs(ents.FindByClass("ent_plrunit")) do
		local vecScreenPos = (unit:GetPos() + Vector(0, 0, 20)):ToScreen()
		if vecScreenPos.x > 0 and vecScreenPos.x < ScrW() then
			local intHealth = unit:GetNWInt("health")
			if GAMEMODE.Data.Classes[unit:GetNWString("class")] then
				local intMaxHealth = GAMEMODE.Data.Classes[unit:GetNWString("class")].Health
				jdraw.SetDrawColor(Color(20, 250, 20, 50), Color(50, 50, 50, 50))
				if unit:GetOwner() == LocalPlayer() and unit:GetNWBool("sellected") then
					jdraw.SetDrawColor(Color(20, 250, 20, 100), Color(50, 50, 50, 100))
				end
				jdraw.DrawProgressBar(vecScreenPos.x - 25, vecScreenPos.y, 50, 5, intHealth, intMaxHealth)
			end
		end
	end
end

function GM:IsABoxSellect(vecNodeOne, vecNodeTwo)
	if vecNodeOne.x + 3 < vecNodeTwo.x or vecNodeOne.x - 3 > vecNodeTwo.x then
		if vecNodeOne.y + 3 < vecNodeTwo.y or vecNodeOne.y - 3 > vecNodeTwo.y then
			return true
		end
	end
	return false
end

function GM:IsInSellectionBox(vecNodeOne, vecNodeTwo, vecObjectPosition)
	local vecMin = Vector(math.min(vecNodeOne.x, vecNodeTwo.x), math.min(vecNodeOne.y, vecNodeTwo.y), 0)
	local vecMax = Vector(math.max(vecNodeOne.x, vecNodeTwo.x), math.max(vecNodeOne.y, vecNodeTwo.y), 0)
	if vecObjectPosition.x >= vecMin.x && vecObjectPosition.x <= vecMax.x then
		if vecObjectPosition.y >= vecMin.y && vecObjectPosition.y <= vecMax.y then
			return true
		end
	end
	return false
end

