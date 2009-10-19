function ToggleShop()
	if !ShopMenu then
		ShopMenu = vgui.Create("shopmenu")
		ShopMenu:Center()
		ShopMenu:SetVisible(true)
		ShopMenu.Frame:SetVisible(true)
	else
		ShopMenu:SetVisible(false)
		ShopMenu.Frame:SetVisible(false)
		ShopMenu = nil
	end
end
concommand.Add("tx_shop", ToggleShop)


PANEL = {}
PANEL.Frame = nil
PANEL.YourWeaponsList = nil
PANEL.ShopWeaponsList = nil
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
		self.YourWeaponsList = vgui.Create("DPanelList", self.Frame)
		self.YourWeaponsList:SetSpacing(5)
		self.YourWeaponsList:SetPadding(5)
		self.YourWeaponsList:EnableVerticalScrollbar(true)
		self.ShopWeaponsList = vgui.Create("DPanelList", self.Frame)
		self.ShopWeaponsList:SetSpacing(5)
		self.ShopWeaponsList:SetPadding(5)
		self.ShopWeaponsList:EnableVerticalScrollbar(true)
		self:LoadShopWeapons()
		self:LoadYourWeapons()
	self.DoneButton = vgui.Create("DButton", self.Frame)
	self.DoneButton:SetText("Done")
	self.DoneButton.DoClick = function()
		RunConsoleCommand("tx_shop")
	end
end
function PANEL:PerformLayout()
	self.Frame:SetPos(self:GetPos())
	self.Frame:SetSize(self:GetSize())
		self.YourWeaponsList:SetSize((self.Frame:GetWide() - 15) / 2, self.Frame:GetTall() - 35)
		self.YourWeaponsList:SetPos(self.Frame:GetWide() - self.YourWeaponsList:GetWide() - 5, 5)
		self.ShopWeaponsList:SetSize((self.Frame:GetWide() - 15) / 2, self.Frame:GetTall() - 35)
		self.ShopWeaponsList:SetPos(5, 5)
	self.DoneButton:SetSize(100, 20)
	self.DoneButton:SetPos(self.Frame:GetWide() - self.DoneButton:GetWide() - 5, self.Frame:GetTall() - 25)
end

function PANEL:LoadShopWeapons()
	local Client = LocalPlayer()
	self.ShopWeaponsList:Clear()
	for k, weaponTable in pairs(Weapons) do
		if weaponTable.Price > 0 then
			self:AddWeapon(self.ShopWeaponsList, k)
		end
	end
end

function PANEL:LoadYourWeapons()
	local Client = LocalPlayer()
	self.YourWeaponsList:Clear()
	for k, weaponTable in pairs(Locker) do
		self:AddWeapon(self.YourWeaponsList, weaponTable.Weapon, k)
	end
end

function PANEL:AddWeapon(lstWeaponList, strWeapon, intWeapon)
	local Client = LocalPlayer()
	local WeaponPanel = vgui.Create("DPanel")
	WeaponPanel:SetSize(self.YourWeaponsList:GetWide() - 10, 100)
	if lstWeaponList != self.ShopWeaponsList then
		WeaponPanel:SetSize(self.YourWeaponsList:GetWide() - 10, 125)
	end
	WeaponPanel.Paint = function() PaintWeaponItem(WeaponPanel, strWeapon, true) end
	if intWeapon then
		WeaponPanel.Paint = function() PaintWeaponItem(WeaponPanel, intWeapon, true) end
	end
	local WeaponPicture = vgui.Create("DLabel", WeaponPanel)
	WeaponPicture:SetFont("TXSmallWeaponIcons")
	WeaponPicture:SetText(Weapons[Weapons[strWeapon].Weapon].Icon)
	WeaponPicture:SetPos(5, 0)
	WeaponPicture:SetSize(150, 120)
	local DescriptionLabel = vgui.Create("DLabel", WeaponPanel)
	DescriptionLabel:SetFont("UiBold")
	local strWeaponName = Weapons[strWeapon].PrintName or Weapons[strWeapon].Weapon
	DescriptionLabel:SetText(strWeaponName)
	DescriptionLabel:SetColor(Color(200, 200, 200, 255))
	DescriptionLabel:SetPos(5, 5)
	DescriptionLabel:SetSize(120, 15)
	if lstWeaponList == self.ShopWeaponsList then
		local BuyButton = vgui.Create("DButton", WeaponPanel)
		BuyButton:SetSize(80, 18)
		BuyButton:SetPos(5, 73)
		BuyButton:SetDrawBackground(false)
		BuyButton:SetText("Buy For $" .. Weapons[strWeapon].Price)
		BuyButton.DoClick = function(BuyButton)
			RunConsoleCommand("tx_buyweapon", strWeapon)
			BuyButton:SetDisabled(true)
			timer.Simple(2, function() BuyButton:SetDisabled(false) end)
		end
	else
		local SellButton = vgui.Create("DButton", WeaponPanel)
		SellButton:SetSize(80, 18)
		SellButton:SetPos(5, 73)
		SellButton:SetDrawBackground(false)
		SellButton:SetText("Sell For $" .. Client:GetWeaponValue(intWeapon))
		SellButton.DoClick = function(SellButton)
			RunConsoleCommand("tx_sellweapon", intWeapon)
			SellButton:SetDisabled(true)
			timer.Simple(2, function() SellButton:SetDisabled(false) end)
		end
		local UpgradeButton = vgui.Create("DButton", WeaponPanel)
		UpgradeButton:SetSize(80, 18)
		UpgradeButton:SetPos(5, 100)
		UpgradeButton:SetDrawBackground(false)
		UpgradeButton:SetText("Upgrade")
		if Client:GetTotalPoints(intWeapon) >= Locker[intWeapon].Maxpoints then
			UpgradeButton:SetDisabled(true)
		end
		UpgradeButton.DoClick = function(UpgradeButton)
			local MenuButtonOptions = DermaMenu()
			local function UpgradCommand(stringCommand)
				UpgradeButton:SetDisabled(true)
				RunConsoleCommand("tx_upgradeweapon", intWeapon, stringCommand)
				timer.Simple(2, function() UpgradeButton:SetDisabled(false) end)
			end
			if Weapons[strWeapon].UpGrades.Power[Locker[intWeapon].pwrlvl] then
				MenuButtonOptions:AddOption("Power For $" .. Weapons[strWeapon].UpGrades.Power[Locker[intWeapon].pwrlvl].Price, function() UpgradCommand("Power") end)
			end
			if Weapons[strWeapon].UpGrades.Accuracy[Locker[intWeapon].acclvl] then
				MenuButtonOptions:AddOption("Accuracy For $" .. Weapons[strWeapon].UpGrades.Accuracy[Locker[intWeapon].acclvl].Price, function() UpgradCommand("Accuracy") end)
			end
			if Weapons[strWeapon].UpGrades.FiringSpeed[Locker[intWeapon].spdlvl] then
				MenuButtonOptions:AddOption("Firing Speed For $" .. Weapons[strWeapon].UpGrades.FiringSpeed[Locker[intWeapon].spdlvl].Price, function() UpgradCommand("FiringSpeed") end)
			end
			if Weapons[strWeapon].UpGrades.ClipSize[Locker[intWeapon].clplvl] then
				MenuButtonOptions:AddOption("Clip Size For $" .. Weapons[strWeapon].UpGrades.ClipSize[Locker[intWeapon].clplvl].Price, function() UpgradCommand("ClipSize") end)
			end
			if Weapons[strWeapon].UpGrades.ReloadSpeed[Locker[intWeapon].reslvl] then
				MenuButtonOptions:AddOption("Reload Speed For $" .. Weapons[strWeapon].UpGrades.ReloadSpeed[Locker[intWeapon].reslvl].Price, function() UpgradCommand("ReloadSpeed") end)
			end
			MenuButtonOptions:Open()
		end
	end
	lstWeaponList:AddItem(WeaponPanel)
end

vgui.Register("shopmenu", PANEL, "Panel")