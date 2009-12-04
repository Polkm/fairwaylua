include('cl_jdraw.lua')
include('shared.lua')
include('sh_camera.lua')
include('sh_units.lua')
local SelectionNode1, SelectionNode2 = Vector(0, 0, 0), Vector(0, 0, 0)
local BoxSellecting = false

function GM:GUIMousePressed(input)
	local ply = LocalPlayer()
	if input == MOUSE_LEFT then
		local x, y = gui.MousePos()
		SelectionNode1 = Vector(x, y, 0)
		BoxSellecting = true
	end
end

function GM:GUIMouseReleased(input)
	local ply = LocalPlayer()
	local tracedata = {}
	tracedata.start = GAMEMODE.CammeraPosition
	tracedata.endpos = GAMEMODE.CammeraPosition + (ply:GetCursorAimVector() * 10000)
	tracedata.filter = ply
	local trace = util.TraceLine(tracedata)
	if input == MOUSE_LEFT then
		local x, y = gui.MousePos()
		SelectionNode2 = Vector(x, y, 0)
		RunConsoleCommand("WAR_UnSellect")
		if GAMEMODE:IsABoxSellect(SelectionNode1, SelectionNode2) then
			--Polkm: This is the box sellect
			for k, entity in pairs(ents.FindByClass("ent_plrunit")) do
				if GAMEMODE:IsInSellectionBox(SelectionNode1, SelectionNode2, entity:GetPos():ToScreen()) then
					RunConsoleCommand("WAR_Sellect", entity:EntIndex())
				end
			end
		else
			--Polkm: This is the click sellect
			print(trace.Entity:GetClass())
			if trace.Entity then
				if trace.Entity:GetClass() == "ent_plrunit" && trace.Entity:GetOwner() == ply then
					RunConsoleCommand("WAR_Sellect", trace.Entity:EntIndex())
				end
			end
		end
		BoxSellecting = false
	end
	if input == MOUSE_RIGHT then
		if trace.HitWorld then
			RunConsoleCommand("WAR_MoveUnits", trace.HitPos.x, trace.HitPos.y, trace.HitPos.z)
		elseif trace.Entity then
			if trace.Entity:GetClass() == "ent_plrunit" then
				RunConsoleCommand("WAR_AttackSquad", trace.Entity:EntIndex())
			end
		end
	end
end

function GM:HUDPaint()
	local x, y = gui.MousePos()
	local MousePos = Vector(x, y, 0)
	if BoxSellecting && GAMEMODE:IsABoxSellect(SelectionNode1, MousePos) then
		local vecNodeMin = SelectionNode1
		local vecNodeMax = MousePos
		if MousePos.x < SelectionNode1.x then
			vecNodeMin = MousePos
			vecNodeMax = SelectionNode1
		end
		surface.SetDrawColor(50, 50, 50, 200)
		surface.DrawOutlinedRect(vecNodeMin.x, vecNodeMin.y, vecNodeMax.x - vecNodeMin.x, vecNodeMax.y - vecNodeMin.y)
		surface.SetDrawColor(20, 150, 20, 50)
		surface.DrawRect(vecNodeMin.x + 1, vecNodeMin.y + 1, vecNodeMax.x - vecNodeMin.x - 2, vecNodeMax.y - vecNodeMin.y - 2)
	end
	for _, Unit in pairs(ents.FindByClass("ent_plrunit")) do
		local vecScreenPos = (Unit:GetPos() + Vector(0, 0, 20)):ToScreen()
		local intHealth = Unit:GetNWInt("health")
		if GAMEMODE.Data.Units[Unit:GetNWString("class")] then
			local intMaxHealth = GAMEMODE.Data.Units[Unit:GetNWString("class")].Health
			jdraw.SetDrawColor(Color(20, 250, 20, 50), Color(50, 50, 50, 50))
			if Unit:GetOwner() == LocalPlayer() and Unit:GetNWBool("sellected") then
				jdraw.SetDrawColor(Color(20, 250, 20, 100), Color(50, 50, 50, 100))
			end
			jdraw.DrawProgressBar(vecScreenPos.x - 25, vecScreenPos.y, 50, 5, intHealth, intMaxHealth)
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

