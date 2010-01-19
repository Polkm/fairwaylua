PANEL = {}
PANEL.Frame = nil
PANEL.ShopInventoryPanel = nil
PANEL.WeightBar = nil
PANEL.PlayerInventoryPanel = nil
PANEL.ItemIconPadding = 1
PANEL.ItemIconSize = 39
PANEL.ItemRow = 6

function PANEL:Init()
	self.Frame = vgui.Create("DFrame")
	self.Frame:SetTitle("Shop Menu")
	self.Frame:SetDraggable(false)
	self.Frame:ShowCloseButton(true)
	self.Frame:SetAlpha(255)
	self.Frame.Paint = function()
		local tblPaintPanel = jdraw.NewPanel()
		tblPaintPanel:SetDemensions(0, 0, self.Frame:GetWide(), self.Frame:GetTall())
		tblPaintPanel:SetStyle(4, clrTan)
		tblPaintPanel:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(tblPaintPanel)
		local tblPaintPanel = jdraw.NewPanel()
		tblPaintPanel:SetDemensions(5, 5, self.Frame:GetWide() - 10, 15)
		tblPaintPanel:SetStyle(4, clrGray)
		tblPaintPanel:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(tblPaintPanel)
	end
	self.Frame.btnClose.DoClick = function(btn)
		GAMEMODE.ShopMenu.Frame:Close()
		GAMEMODE.ShopMenu = nil
	end
	self.Frame:MakePopup()
	
	self.ShopInventoryPanel = vgui.Create("DPanelList", self.Frame)
	self.ShopInventoryPanel:SetSpacing(self.ItemIconPadding)
	self.ShopInventoryPanel:SetPadding(self.ItemIconPadding)
	self.ShopInventoryPanel:EnableHorizontal(true)
	self.ShopInventoryPanel:EnableVerticalScrollbar(true)
	self.ShopInventoryPanel.Paint = function()
		local tblPaintPanel = jdraw.NewPanel()
		tblPaintPanel:SetDemensions(0, 0, self.ShopInventoryPanel:GetWide(), self.ShopInventoryPanel:GetTall())
		tblPaintPanel:SetStyle(4, clrGray)
		tblPaintPanel:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(tblPaintPanel)
	end
	self.ShopInventoryPanel.DoDropedOn = function()
		if GAMEMODE.DraggingPanel.UseCommand == "sell" then
			GAMEMODE.DraggingPanel.DoDoubleClick()
		end
	end
	GAMEMODE:AddHoverObject(self.ShopInventoryPanel)
	GAMEMODE:AddHoverObject(self.ShopInventoryPanel.pnlCanvas, self.ShopInventoryPanel)
	
	self.WeightBar = vgui.Create("FPercentBar", self.Frame)
	self.WeightBar:SetMax(GAMEMODE.MaxWeight)
	self.WeightBar:SetValue(LocalPlayer().Weight)
	self.WeightBar:SetText("Weight " .. LocalPlayer().Weight .. "/" ..  GAMEMODE.MaxWeight)
	
	self.PlayerInventoryPanel = vgui.Create("DPanelList", self.Frame)
	self.PlayerInventoryPanel:SetSpacing(self.ItemIconPadding)
	self.PlayerInventoryPanel:SetPadding(self.ItemIconPadding)
	self.PlayerInventoryPanel:EnableHorizontal(true)
	self.PlayerInventoryPanel:EnableVerticalScrollbar(true)
	self.PlayerInventoryPanel.Paint = function()
		local tblPaintPanel = jdraw.NewPanel()
		tblPaintPanel:SetDemensions(0, 0, self.PlayerInventoryPanel:GetWide(), self.PlayerInventoryPanel:GetTall())
		tblPaintPanel:SetStyle(4, clrGray)
		tblPaintPanel:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(tblPaintPanel)
	end
	self.PlayerInventoryPanel.DoDropedOn = function()
		if GAMEMODE.DraggingPanel.UseCommand == "buy" then
			GAMEMODE.DraggingPanel.DoDoubleClick()
		end
	end
	GAMEMODE:AddHoverObject(self.PlayerInventoryPanel)
	GAMEMODE:AddHoverObject(self.PlayerInventoryPanel.pnlCanvas, self.PlayerInventoryPanel)
	
	self:PerformLayout()
end

function PANEL:LoadShop(strShop)
	local tblShopTable = ShopTable(strShop)
	self.Frame:SetTitle(tblShopTable.PrintName)
	self.ShopInventoryPanel:Clear()
	for strItem, tblInfo in pairs(tblShopTable.Inventory or {}) do
		self:AddItem(self.ShopInventoryPanel, strItem, 1, "buy", tblInfo.Price)
	end
end

function PANEL:LoadPlayer()
	self.WeightBar:SetValue(LocalPlayer().Weight)
	self.WeightBar:SetText("Weight " .. LocalPlayer().Weight .. "/" ..  GAMEMODE.MaxWeight)
	local tblInventory = LocalPlayer().Data.Inventory or {}
	self.PlayerInventoryPanel:Clear()
	if tblInventory["money"] && tblInventory["money"] > 0 then
		self:AddItem(self.PlayerInventoryPanel, "money", tblInventory["money"], "sell")
	end
	for strItem, intAmount in pairs(tblInventory) do
		if intAmount > 0 && strItem != "money" then
			local tblItemTable = ItemTable(strItem)
			self:AddItem(self.PlayerInventoryPanel, strItem, intAmount, "sell", tblItemTable.SellPrice)
		end
	end
end

function PANEL:AddItem(lstAddList, item, amount, strCommand, intCost)
	local tblItemTable = ItemTable(item)
	local intListItems = 1
	if !tblItemTable.Stackable then intListItems = amount or 1 end
	for i = 1, intListItems do
		local icnItem = vgui.Create("FIconItem")
		icnItem:SetSize(self.ItemIconSize, self.ItemIconSize)
		icnItem:SetItem(tblItemTable, amount, strCommand or "use", intCost or 0)
		lstAddList:AddItem(icnItem)
	end
end

function PANEL:PerformLayout()
	self.ShopInventoryPanel:SetPos(5, 25)
	self.ShopInventoryPanel:SetSize(((self.ItemIconSize + self.ItemIconPadding) * self.ItemRow) + self.ItemIconPadding, self.Frame:GetTall() - 30)
	
	self.PlayerInventoryPanel:SetPos(self.ShopInventoryPanel:GetWide() + 10, 45)
	self.PlayerInventoryPanel:SetSize(((self.ItemIconSize + self.ItemIconPadding) * self.ItemRow) + self.ItemIconPadding, self.Frame:GetTall() - 50)
	
	self.WeightBar:SetPos(self.ShopInventoryPanel:GetWide() + 10, 25)
	self.WeightBar:SetSize(self.PlayerInventoryPanel:GetWide(), 15)
	self.WeightBar:SetValue(LocalPlayer().Weight)
	self.WeightBar:SetText("Weight " .. LocalPlayer().Weight .. "/" ..  GAMEMODE.MaxWeight)
	
	self:SetSize(self.ShopInventoryPanel:GetWide() + self.PlayerInventoryPanel:GetWide() + 15, 300)
	self.Frame:SetPos(self:GetPos())
	self.Frame:SetSize(self:GetSize())
end
vgui.Register("shopmenu", PANEL, "Panel")

concommand.Add("UD_OpenShopMenu", function(ply, command, args)
	GAMEMODE.ShopMenu = (GAMEMODE.ShopMenu or vgui.Create("shopmenu"))
	GAMEMODE.ShopMenu:SetSize(505, 300)
	GAMEMODE.ShopMenu:Center()
	GAMEMODE.ShopMenu:LoadShop(args[1])
	GAMEMODE.ShopMenu:LoadPlayer()
end)
