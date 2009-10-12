function ToggleShop()
	if !LockerMenu then
		LockerMenu = vgui.Create("lockermenu")
		LockerMenu:Center()
		LockerMenu:SetVisible(true)
		LockerMenu.Frame:SetVisible(true)
	else
		LockerMenu:SetVisible(false)
		LockerMenu.Frame:SetVisible(false)
		LockerMenu = nil
	end
end
concommand.Add("tx_locker", ToggleShop)

PANEL = {}
PANEL.Frame = nil
PANEL.EquiptedWeaponsList = nil
PANEL.LockerWeaponsList = nil
PANEL.DoneButton = nil
function PANEL:Init()
	self:SetSize(505, 505)
	self.Frame = vgui.Create("DFrame")
	self.Frame:SetTitle("")
	self.Frame:SetDraggable(false)
	self.Frame:ShowCloseButton(false)
	self.Frame.Paint = function()
		draw.RoundedBox(4, 0, 0, self.Frame:GetWide(), self.Frame:GetTall(), Color(150, 150, 150, 255))
	end
	self.Frame:MakePopup()
		self.EquiptedWeaponsList = vgui.Create("DPanelList", self.Frame)
		self.EquiptedWeaponsList:SetSpacing(5)
		self.EquiptedWeaponsList:SetPadding(5)
		self.LockerWeaponsList = vgui.Create("DPanelList", self.Frame)
		self.LockerWeaponsList:SetSpacing(5)
		self.LockerWeaponsList:SetPadding(5)
		self.LockerWeaponsList:EnableVerticalScrollbar(true)
		self:LoadWeapons()
	self.DoneButton = vgui.Create("DButton", self.Frame)
	self.DoneButton:SetText("Done")
	self.DoneButton.DoClick = function()
		RunConsoleCommand("tx_locker")
	end
end
function PANEL:PerformLayout()
	self.Frame:SetPos(self:GetPos())
	self.Frame:SetSize(self:GetSize())
		self.EquiptedWeaponsList:SetSize((self.Frame:GetWide() - 15) / 2, self.Frame:GetTall() - 35)
		self.EquiptedWeaponsList:SetPos(self.Frame:GetWide() - self.EquiptedWeaponsList:GetWide() - 5, 5)
		self.LockerWeaponsList:SetSize((self.Frame:GetWide() - 15) / 2, self.Frame:GetTall() - 35)
		self.LockerWeaponsList:SetPos(5, 5)
	self.DoneButton:SetSize(100, 20)
	self.DoneButton:SetPos(self.Frame:GetWide() - self.DoneButton:GetWide() - 5, self.Frame:GetTall() - 25)
end

function PANEL:LoadWeapons()
	local Client = LocalPlayer()
	self.EquiptedWeaponsList:Clear()
	self.LockerWeaponsList:Clear()
	for k, weaponTable in pairs(Locker) do
		if k != 0 && k != 1337 then 
			local ProperList = self.LockerWeaponsList
			if k == Client:GetNWInt("Weapon1") or k == Client:GetNWInt("Weapon2") then
				ProperList = self.EquiptedWeaponsList
			end
			local WeaponPanel = vgui.Create("DPanel")
			WeaponPanel:SetSize(self.EquiptedWeaponsList:GetWide() - 10, 100)
			WeaponPanel.Paint = function()
				draw.RoundedBox(4, 0, 0, WeaponPanel:GetWide(), WeaponPanel:GetTall(), Color(100, 100, 100, 150))
					surface.SetTextColor(255,255,255,255)
					-- Power
					surface.SetFont("DefaultSmallDropShadow")
					surface.DrawRect(120,80,100,5)
					local x,y = surface.GetTextSize("Power")
					surface.SetTextPos(120 ,  80 - y )
					surface.DrawText("Power")
					-- Accuracy
					surface.DrawRect(120,  65,100,5)
					local x,y = surface.GetTextSize("Accuracy")
					surface.SetTextPos(120 ,  65 - y )
					surface.DrawText("Accuracy")
					--Firing Speed
					surface.DrawRect(120,  50,100,5)
					local x,y = surface.GetTextSize("Firing Speed")
					surface.SetTextPos(120 ,  50 - y )
					surface.DrawText("Firing Speed")
					-- Clip Size
					surface.DrawRect(120,  35,100,5)
					local x,y = surface.GetTextSize("Clip Size")
					surface.SetTextPos(120 ,  35 - y )
					surface.DrawText("Clip Size")
					-- Reload speed
					surface.DrawRect(120,  20,100,5)
					local x,y = surface.GetTextSize("Reload Speed")
					surface.SetTextPos(120 ,  20 - y )
					surface.DrawText("Reload Speed")
					
					surface.SetDrawColor(255, 55, 55, 60)
					surface.DrawRect(120,   80, 100 / (table.Count(Weapons[Locker[k].Weapon].UpGrades.Power) / Locker[k].pwrlvl), 5)
					surface.DrawRect(120,   65, 100 / (table.Count(Weapons[Locker[k].Weapon].UpGrades.Accuracy) / Locker[k].acclvl), 5)
					surface.DrawRect(120,   50, 100 / (table.Count(Weapons[Locker[k].Weapon].UpGrades.FiringSpeed) / Locker[k].spdlvl), 5)
					surface.DrawRect(120,   35, 100 / (table.Count(Weapons[Locker[k].Weapon].UpGrades.ClipSize) / Locker[k].clplvl), 5)
					surface.DrawRect(120,   20, 100 / (table.Count(Weapons[Locker[k].Weapon].UpGrades.ReloadSpeed)/Locker[k].reslvl),5)
			end
			WeaponPanel:SetTooltip(strDescription)
			local WeaponPicture = vgui.Create("DLabel", WeaponPanel)
			WeaponPicture:SetFont("CSSelectIcons")
			WeaponPicture:SetText(Weapons[weaponTable.Weapon].Icon) --Weapons[weaponTable.Weapon].Icon
			WeaponPicture:SetPos(5, 0)
			WeaponPicture:SetSize(150, 120)
			local DescriptionLabel = vgui.Create("DLabel", WeaponPanel)
			DescriptionLabel:SetFont("UiBold")
			DescriptionLabel:SetText(weaponTable.Weapon)
			DescriptionLabel:SetColor(Color(200, 200, 200, 255))
			DescriptionLabel:SetPos(5, 5)
			DescriptionLabel:SetSize(120, 15)
			if ProperList == self.EquiptedWeaponsList then
				local MoveButton = vgui.Create("DButton", WeaponPanel)
				MoveButton:SetSize(80, 18)
				MoveButton:SetPos(5, 70)
				MoveButton:SetDrawBackground(false)
				MoveButton:SetText("Deposit")
				MoveButton.DoClick = function(MoveButton)
					print(k)
					RunConsoleCommand("DepositWeapon", k)
					timer.Simple(0.1, function() self:LoadWeapons() end)
				end
			else
				local MoveButton = vgui.Create("DButton", WeaponPanel)
				MoveButton:SetSize(80, 18)
				MoveButton:SetPos(5, 70)
				MoveButton:SetDrawBackground(false)
				MoveButton:SetText("Withdraw")
				MoveButton.DoClick = function(MoveButton)
					print(k)
					RunConsoleCommand("WithdrawWeapon", k)
					timer.Simple(0.1, function() self:LoadWeapons() end)
				end
			end
			ProperList:AddItem(WeaponPanel)
		end
	end
end
vgui.Register("lockermenu", PANEL, "Panel")