include( 'shared.lua' )

function GM:HUDShouldDraw(Name)
	if Name == "CHudHealth" or Name == "CHudBattery" or Name =="CHudSecondaryAmmo" or Name == "CHudAmmo" then
		return false
	end	
	return true
end


function GM:HUDPaint()
	local SW = ScrW()
	local SH = ScrH()
	local client = LocalPlayer()
	local Money = client:GetNWInt("Money")
	local Mag_In = client:GetActiveWeapon():Clip1()
	local Mag_Out = client:GetAmmoCount(client:GetActiveWeapon():GetPrimaryAmmoType())
	surface.SetDrawColor(200,200,200,60)
	surface.DrawRect(SW- 350, SH- 130,SW+ 350, SH+ 130)
	surface.SetDrawColor(0,0,0,60)
	surface.DrawOutlinedRect(SW- 350, SH- 130,SW+ 350 +1, SH+ 130 + 1)
	-- Weapon Box
	surface.SetTextColor(255,255,255,255)
	surface.SetFont("TitleFont")
	surface.SetTextPos(SW - 100,SH - 130)
	surface.DrawText("d")--Pistol
	surface.SetFont("DefaultSmallDropShadow")
	surface.SetDrawColor(55,55,55,130)
	-- bullet Icons
	surface.SetTextColor(255,255,255,255)
	surface.SetFont("CSKillIcons")
	surface.SetTextPos(SW - 30 ,SH - 70)
	surface.DrawText("M")
	-- Bullet mag out
	surface.SetFont("UIBold")
	local x,y = surface.GetTextSize(Mag_Out)
	surface.SetTextPos(SW - 30  ,SH - 40 - y/2)
	surface.DrawText(Mag_Out)
	--Mag in
	surface.SetFont("UIBold")
	local x,y = surface.GetTextSize(Mag_In)
	surface.SetTextPos(SW - 30  ,SH - 80 - y/2)
	surface.DrawText(Mag_In)
	-- Power
	surface.SetFont("DefaultSmallDropShadow")
	surface.DrawRect(SW- 320,SH - 70,280,5)
	local x,y = surface.GetTextSize("Power")
	surface.SetTextPos(SW - 320 ,SH - 70 - y )
	surface.DrawText("Power")
	-- Accuracy
	surface.DrawRect(SW- 320,SH - 55,280,5)
	local x,y = surface.GetTextSize("Accuracy")
	surface.SetTextPos(SW - 320 ,SH - 55 - y )
	surface.DrawText("Accuracy")
	--Firing Speed
	surface.DrawRect(SW- 320,SH - 40,280,5)
	local x,y = surface.GetTextSize("Firing Speed")
	surface.SetTextPos(SW - 320 ,SH - 40 - y )
	surface.DrawText("Firing Speed")
	-- Clip Size
	surface.DrawRect(SW- 320,SH - 25,280,5)
	local x,y = surface.GetTextSize("Clip Size")
	surface.SetTextPos(SW - 320 ,SH - 25 - y )
	surface.DrawText("Clip Size")
	-- Reload speed
	//surface.DrawRect(SW- 320,SH - 10,280,5)
	//local x,y = surface.GetTextSize("Reload Speed")
	//surface.SetTextPos(SW - 320 ,SH - 10 - y )
	//surface.DrawText("Reload Speed")
	surface.SetDrawColor(255,55,55,60)
	surface.DrawRect(SW- 320,SH - 70,280/((table.Count(Weapons[Locker[1].Weapon].Power))/(Weapons[Locker[1]].Power[Locker[1].pwrlvl].Level)),5)
	surface.DrawRect(SW- 320,SH - 55,280/((table.Count(Weapons[Locker[1].Weapon].Accuracy))/(Weapons[Locker[1]].Accuracy[Locker[1].acclvl].Level)),5)
	surface.DrawRect(SW- 320,SH - 40,280/((table.Count(Weapons[Locker[1].Weapon].FiringSpeed))/(Weapons[Locker[1]].FiringSpeed[Locker[1].spdlvl].Level)),5)
	surface.DrawRect(SW- 320,SH - 25,280/((table.Count(Weapons[Locker[1].Weapon].ClipSize))/(Weapons[Locker[1]].ClipSize[Locker[1].clplvl].Level)),5)
	//surface.DrawRect(SW- 320,SH - 10,280/((UpgradeLevels[Locker[1].Weapon].MaxReloadSpeed)/(Weapons[Locker[1]].Upgrades[Locker[1].reslvl].Level)),5)
end