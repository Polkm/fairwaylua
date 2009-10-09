function ToggleShop()
	if !OpenMenu then
		OpenMenu = vgui.Create("shopmenu")
		OpenMenu:Center()
		OpenMenu:SetVisible(true)
		OpenMenu.Frame:SetVisible(true)
		gui.EnableScreenClicker(true)
		RestoreCursorPosition()
	else
		OpenMenu:SetVisible(false)
		OpenMenu.Frame:SetVisible(false)
		RememberCursorPosition()
		gui.EnableScreenClicker(false)
		OpenMenu = nil
	end
end
concommand.Add("hlmo_shop", ToggleShop)

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
		self.YourWeaponsList:EnableHorizontal(false)
		self.YourWeaponsList:EnableVerticalScrollbar(true)
		self:LoadPlayerWeapons()
		self.ShopWeaponsList = vgui.Create("DPanelList", self.Frame)
		self.ShopWeaponsList:SetSpacing(5)
		self.ShopWeaponsList:SetPadding(5)
		self.ShopWeaponsList:EnableHorizontal(false)
		self.ShopWeaponsList:EnableVerticalScrollbar(true)
		self:LoadShopWeapons()
	self.DoneButton = vgui.Create("DButton", self.Frame)
	self.DoneButton:SetText("Done")
	self.DoneButton.DoClick = function()
		RunConsoleCommand("hlmo_shop")
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

local txtUpGradTexture = surface.GetTextureID("gui/gradient_down")
function PANEL:LoadPlayerWeapons()
	local Client = LocalPlayer()
	if #Client:GetWeapons() <= 0 then return end
	self.YourWeaponsList:Clear()
	local tblWeaponSlots = {}
	for _, weapon in pairs(Client:GetWeapons()) do table.insert(tblWeaponSlots, weapon:GetClass()) end
	--PrintTable(Client:GetWeapons())
	for i = 1, GAMEMODE.MaximumSlots - table.Count(Client:GetWeapons()) do table.insert(tblWeaponSlots, "default") end
	for _, weapon in pairs(tblWeaponSlots) do
		local strIconLetter = WeaponData[weapon].Letter or WeaponData["default"].Letter
		local strPrintName = WeaponData[weapon].PrintName or WeaponData["default"].PrintName
		local strDescription = WeaponData[weapon].Desc or WeaponData["default"].Desc
		local boolSellable = WeaponData[weapon].Sellable or WeaponData["default"].Sellable
		local intSellPrice = WeaponData[weapon].SellPrice or WeaponData["default"].SellPrice
		local WeaponPanel = vgui.Create("DPanel")
		WeaponPanel:SetSize(self.YourWeaponsList:GetWide() - 10, 60)
		WeaponPanel.Paint = function()
			draw.RoundedBox(4, 0, 0, WeaponPanel:GetWide(), WeaponPanel:GetTall(), Color(100, 100, 100, 150))
			surface.SetDrawColor(0, 0, 0, 100)
			surface.SetTexture(txtUpGradTexture)
			surface.DrawTexturedRect(0, 0, WeaponPanel:GetWide(), WeaponPanel:GetTall())
		end
		WeaponPanel:SetTooltip(strDescription)
			local WeaponPicture = vgui.Create("DLabel", WeaponPanel)
			WeaponPicture:SetFont("TitleFont")
			WeaponPicture:SetText(strIconLetter)
			WeaponPicture:SetPos(5, -5)
			WeaponPicture:SetSize(150, 60)
			local DescriptionLabel = vgui.Create("DLabel", WeaponPanel)
			DescriptionLabel:SetFont("UiBold")
			DescriptionLabel:SetText(strPrintName)
			DescriptionLabel:SetColor(Color(200, 200, 200, 255))
			DescriptionLabel:SetPos(115, 5)
			DescriptionLabel:SetSize(120, 10)
			if boolSellable then
				local SellButton = vgui.Create("DButton", WeaponPanel)
				SellButton:SetSize(80, 18)
				SellButton:SetPos(152, 40)
				SellButton:SetDrawBackground(false)
				SellButton:SetText("Sell For $" .. intSellPrice)
				SellButton.DoClick = function(SellButton)
					RunConsoleCommand("hlmo_sellweapon", weapon)
					timer.Simple(0.1, function() self:LoadPlayerWeapons() end)
					timer.Simple(0.1, function() self:LoadShopWeapons() end)
				end
			end
		self.YourWeaponsList:AddItem(WeaponPanel)
	end
end

function PANEL:LoadShopWeapons()
	local Client = LocalPlayer()
	self.ShopWeaponsList:Clear()
	local tblBuyWeapons = {}
	for class, info in pairs(WeaponData) do
		if info.Buyable then
			local clientsHas = false
			for _, weapon in pairs(Client:GetWeapons()) do
				if weapon:GetClass() == class then
					clientsHas = true
					break
				end
			end
			if !clientsHas then
				table.insert(tblBuyWeapons, class)
			end
		end
	end
	--PrintTable(tblBuyWeapons)
	for _, weapon in pairs(tblBuyWeapons) do
		local strIconLetter = WeaponData[weapon].Letter or WeaponData["default"].Letter
		local strPrintName = WeaponData[weapon].PrintName or WeaponData["default"].PrintName
		local strDescription = WeaponData[weapon].Desc or WeaponData["default"].Desc
		local intBuyPrice = WeaponData[weapon].BuyPrice or WeaponData["default"].BuyPrice
		local WeaponPanel = vgui.Create("DPanel")
		WeaponPanel:SetSize(self.ShopWeaponsList:GetWide() - 10, 60)
		WeaponPanel.Paint = function()
			draw.RoundedBox(4, 0, 0, WeaponPanel:GetWide(), WeaponPanel:GetTall(), Color(100, 100, 100, 150))
			surface.SetDrawColor(0, 0, 0, 100)
			surface.SetTexture(txtUpGradTexture)
			surface.DrawTexturedRect(0, 0, WeaponPanel:GetWide(), WeaponPanel:GetTall())
		end
		WeaponPanel:SetTooltip(strDescription)
			local WeaponPicture = vgui.Create("DLabel", WeaponPanel)
			WeaponPicture:SetFont("TitleFont")
			WeaponPicture:SetText(strIconLetter)
			WeaponPicture:SetPos(5, -5)
			WeaponPicture:SetSize(150, 60)
			local DescriptionLabel = vgui.Create("DLabel", WeaponPanel)
			DescriptionLabel:SetFont("UiBold")
			DescriptionLabel:SetText(strPrintName)
			DescriptionLabel:SetColor(Color(200, 200, 200, 255))
			DescriptionLabel:SetPos(115, 5)
			DescriptionLabel:SetSize(120, 10)
			local BuyButton = vgui.Create("DButton", WeaponPanel)
			BuyButton:SetSize(80, 18)
			BuyButton:SetPos(152, 40)
			BuyButton:SetDrawBackground(false)
			BuyButton:SetText("Buy For $" .. intBuyPrice)
			BuyButton.DoClick = function(BuyButton)
				RunConsoleCommand("hlmo_buyweapon", weapon)
				timer.Simple(0.1, function() self:LoadPlayerWeapons() end)
				timer.Simple(0.1, function() self:LoadShopWeapons() end)
			end
		self.ShopWeaponsList:AddItem(WeaponPanel)
	end
end
vgui.Register("shopmenu", PANEL, "Panel")
