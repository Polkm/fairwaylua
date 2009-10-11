surface.CreateFont("csd", ScreenScale(40), 500, true, true, "CSSelectIcons")

function ToggleShop()
	if !LockerMenu then
		LockerMenu = vgui.Create("lockermenu")
		LockerMenu:Center()
		LockerMenu:SetVisible(true)
		LockerMenu.Frame:SetVisible(true)
		gui.EnableScreenClicker(true)
		RestoreCursorPosition()
	else
		LockerMenu:SetVisible(false)
		LockerMenu.Frame:SetVisible(false)
		RememberCursorPosition()
		gui.EnableScreenClicker(false)
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
		local ProperList = self.LockerWeaponsList
		if k == Client:GetNWInt("Weapon1") or k == Client:GetNWInt("Weapon2") then
			ProperList = self.EquiptedWeaponsList
		end
		local WeaponPanel = vgui.Create("DPanel")
		WeaponPanel:SetSize(self.EquiptedWeaponsList:GetWide() - 10, 60)
		WeaponPanel.Paint = function()
			draw.RoundedBox(4, 0, 0, WeaponPanel:GetWide(), WeaponPanel:GetTall(), Color(100, 100, 100, 150))
		end
		WeaponPanel:SetTooltip(strDescription)
		local WeaponPicture = vgui.Create("DLabel", WeaponPanel)
		WeaponPicture:SetFont("CSSelectIcons")
		WeaponPicture:SetText("b") --Weapons[weaponTable.Weapon].Icon
		WeaponPicture:SetPos(5, -10)
		WeaponPicture:SetSize(150, 120)
		local DescriptionLabel = vgui.Create("DLabel", WeaponPanel)
		DescriptionLabel:SetFont("UiBold")
		DescriptionLabel:SetText(weaponTable.Weapon)
		DescriptionLabel:SetColor(Color(200, 200, 200, 255))
		DescriptionLabel:SetPos(115, 5)
		DescriptionLabel:SetSize(120, 15)
		local MoveButton = vgui.Create("DButton", WeaponPanel)
		MoveButton:SetSize(80, 18)
		MoveButton:SetPos(152, 40)
		MoveButton:SetDrawBackground(false)
		MoveButton:SetText("Move")
		MoveButton.DoClick = function(MoveButton)
			--RunConsoleCommand("hlmo_sellweapon", weapon)
			timer.Simple(0.1, function() self:LoadWeapons() end)
		end
		ProperList:AddItem(WeaponPanel)
	end
end
vgui.Register("lockermenu", PANEL, "Panel")