include('cl_jdraw.lua')
include('shared.lua')
include('sh_camera.lua')
include('sh_units.lua')
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

function GM:HUDPaint()
	local intMouseX, intMouseY = gui.MousePos()
	local vecMousePos = Vector(intMouseX, intMouseY, 0)
	if boolBoxSellecting && GAMEMODE:IsABoxSellect(SelectionNode1, vecMousePos) then
		local vecNodeMin = SelectionNode1
		local vecNodeMax = vecMousePos
		if vecMousePos.x < SelectionNode1.x then
			vecNodeMin = vecMousePos
			vecNodeMax = SelectionNode1
		end
		surface.SetDrawColor(50, 50, 50, 200)
		surface.DrawOutlinedRect(vecNodeMin.x, vecNodeMin.y, vecNodeMax.x - vecNodeMin.x, vecNodeMax.y - vecNodeMin.y)
		surface.SetDrawColor(20, 150, 20, 50)
		surface.DrawRect(vecNodeMin.x + 1, vecNodeMin.y + 1, vecNodeMax.x - vecNodeMin.x - 2, vecNodeMax.y - vecNodeMin.y - 2)
	end
	for _, unit in pairs(ents.FindByClass("ent_plrunit")) do
		local vecScreenPos = (unit:GetPos() + Vector(0, 0, 20)):ToScreen()
		if vecScreenPos.x > 0 and vecScreenPos.x < ScrW() then
			local intHealth = unit:GetNWInt("health")
			if GAMEMODE.Data.Units[unit:GetNWString("class")] then
				local intMaxHealth = GAMEMODE.Data.Units[unit:GetNWString("class")].Health
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
	if vecNodeOne.x + 3 < vecNodeTwo.x && vecNodeOne.y + 3 < vecNodeTwo.y then
		return true
	elseif vecNodeOne.x - 3 > vecNodeTwo.x && vecNodeOne.y - 3 > vecNodeTwo.y then
		return true
	end
	return false
end

function GM:IsInSellectionBox(vecNodeOne, vecNodeTwo, vecObjectPosition)
	if vecNodeOne.x + 3 < vecNodeTwo.x && vecNodeOne.y + 3 < vecNodeTwo.y then
		if vecObjectPosition.x > vecNodeOne.x && vecObjectPosition.x < vecNodeTwo.x &&
			vecObjectPosition.y > vecNodeOne.y && vecObjectPosition.y < vecNodeTwo.y then
			return true
		end
	elseif vecNodeOne.x - 3 > vecNodeTwo.x && vecNodeOne.y - 3 > vecNodeTwo.y then
		if vecObjectPosition.x < vecNodeOne.x && vecObjectPosition.x > vecNodeTwo.x &&
			vecObjectPosition.y < vecNodeOne.y && vecObjectPosition.y > vecNodeTwo.y then
			return true
		end
	end
	return false
end

