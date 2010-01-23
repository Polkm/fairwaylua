--[[
	+oooooo+-`    `:oyyys+-`    +oo.       /oo-   .oo+-  ooo+`   `ooo+  
	NMMhyhmMMm-  omMNyosdMMd:   NMM:       hMM+ `oNMd:  `MMMMy`  yMMMN  
	NMM:  .NMMo /MMN:    sMMN`  NMM:       hMMo/dMm/`   `MMMmMs`oMmMMN  
	NMMhyhmMNh. yMMm     -MMM:  NMM:       hMMmNMMo     `MMM:mMhMd/MMN  
	NMMyoo+/.   /MMN:    sMMN`  NMM:       hMMy:dMMh-   `MMM`:NMN.:MMN  
	NMM:         +NMNyosdMMd:   NMMdyyyyy. hMM+ `+NMNo` `MMM` ... :MMN  
	+oo.          `:oyyys+-`    +oooooooo` /oo-   .ooo/  ooo`     .oo+  2009
]]
local PANEL = {}
local matGlossIcon = surface.GetTextureID("icons/icon_gloss")
local matBoarderIcon = surface.GetTextureID("icons/icon_boarder2")
PANEL.Icon = nil
PANEL.Text = nil
PANEL.LastClick = 0
PANEL.Draggable = false
PANEL.Item = nil
PANEL.Slot = nil
PANEL.UseCommand = nil
PANEL.LeftMouseDown = false
PANEL.DoClick = function() end
PANEL.DoRightClick = function() end
PANEL.DoDoubleClick = function() end
PANEL.DoDropedOn = function() end

function PANEL:Init()
	GAMEMODE:AddHoverObject(self)
end

function PANEL:OnMousePressed(mousecode)
	if mousecode == MOUSE_LEFT then
		if self.Draggable then
			timer.Simple(0.1, function()
				if self.Draggable && input.IsMouseDown(MOUSE_LEFT) then
					GAMEMODE.DraggingPanel = self
				end
			end)
		end
	end
end

function PANEL:OnMouseReleased(mousecode)
	if mousecode == MOUSE_RIGHT then
		self.DoRightClick()
		if GAMEMODE.DraggingPanel then
			GAMEMODE.DraggingPanel = nil
		end
	end
	if mousecode == MOUSE_LEFT then
		if GAMEMODE.DraggingPanel then
			if GAMEMODE.HoveredIcon then
				GAMEMODE.HoveredIcon.DoDropedOn()
			end
			GAMEMODE.DraggingPanel = nil
		else
			if (SysTime() - self.LastClick) < 0.3 then
				self.DoDoubleClick()
			else
				self.DoClick()
			end
		end
		self.LastClick = SysTime()
	end
end

function PANEL:Paint()
	if self.Icon then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(self.Icon)
		surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
		surface.SetDrawColor(255, 255, 255, 50)
		surface.SetTexture(matGlossIcon)
		surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
	end
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetTexture(matBoarderIcon)
	surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
	
	if self.Text then
		surface.SetFont("DefaultFixedOutline")
		local width, tall = surface.GetTextSize(tostring(self.Text)) 
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(self:GetWide() - width - 2, self:GetTall() - tall - 1) 
		surface.DrawText(tostring(self.Text))
	end
	return true
end

function PANEL:SetIcon(strIconText)
	self.Icon = strIconText
	if strIconText then
		self.Icon = surface.GetTextureID(strIconText)
	end
end

function PANEL:SetText(strText)
	self.Text = strText
end

function PANEL:SetDragable(boolDraggable)
	self.Draggable = boolDraggable
end

function PANEL:SetRightClick(fncRightClick)
	self.DoRightClick = fncRightClick
end

function PANEL:SetDoubleClick(fncDoubleClick)
	self.DoDoubleClick = fncDoubleClick
end

function PANEL:SetDropedOn(fncDropedOn)
	self.DoDropedOn = fncDropedOn
end

function PANEL:SetItem(tblItemTable, intAmount, strUseCommand, intCost)
	intCost = intCost or 0
	strUseCommand = strUseCommand or "use"
	self.UseCommand = strUseCommand
	intAmount = intAmount or 1
	self:SetDragable(true)
	if tblItemTable.Icon then self:SetIcon(tblItemTable.Icon) end
	if tblItemTable.Stackable && intAmount > 1 then self:SetText(intAmount) end
	if tblItemTable.Name then self.Item = tblItemTable.Name end
	if tblItemTable.Slot then self.Slot = tblItemTable.Slot end
	if strUseCommand == "use" && tblItemTable.Dropable then
		self.DoDropItem = function()
			if tblItemTable.Stackable and intAmount >= 5 then
				DisplayPromt("number", "How many to drop", function(itemamount) RunConsoleCommand("UD_DropItem", tblItemTable.Name, itemamount) end, tblItemTable.Name)
			else
				RunConsoleCommand("UD_DropItem", tblItemTable.Name, 1)
			end
		end
	end
	if strUseCommand == "use" && tblItemTable.Giveable then
		self.DoGiveItem = function(plyGivePlayer)
			if tblItemTable.Stackable and intAmount >= 5 then 
				DisplayPromt("number", "How many to give", function(itemamount)
					RunConsoleCommand("UD_GiveItem", tblItemTable.Name, itemamount, plyGivePlayer:EntIndex())
				end, tblItemTable.Name)
			else 
				RunConsoleCommand("UD_GiveItem", tblItemTable.Name, 1, plyGivePlayer:EntIndex())
			end
		end
	end
	if strUseCommand == "use" && tblItemTable.Use then
		self.DoUseItem = function() RunConsoleCommand("UD_UseItem", tblItemTable.Name) end
	end
	if strUseCommand == "buy" then
		self.DoUseItem = function() RunConsoleCommand("UD_BuyItem", tblItemTable.Name) end
	end
	if strUseCommand == "sell" then
		self.DoUseItem = function(intAmountToSell) RunConsoleCommand("UD_SellItem", tblItemTable.Name, intAmountToSell) end
	end
	---------ToolTip---------
	local strTooltip = Format("%s", tblItemTable.PrintName)
	if tblItemTable.Desc then strTooltip = Format("%s\n%s", strTooltip, tblItemTable.Desc) end
	if tblItemTable.Weight && tblItemTable.Weight > 0 then strTooltip = Format("%s\n%s Kgs", strTooltip, tblItemTable.Weight) end
	if strUseCommand == "buy" && intCost > 0 then strTooltip = Format("%s\nBuy For $%s", strTooltip, intCost) end
	if strUseCommand == "sell" && intCost > 0 then strTooltip = Format("%s\nSell For $%s", strTooltip, intCost) end
	self:SetTooltip(strTooltip)
	------Double Click------
	if self.DoUseItem then self:SetDoubleClick(self.DoUseItem) end
	-------Right Click-------
	local menuFunc = function()
		GAMEMODE.ActiveMenu = nil
		GAMEMODE.ActiveMenu = DermaMenu()
		if strUseCommand == "use" && tblItemTable.Use && self.DoUseItem then GAMEMODE.ActiveMenu:AddOption("Use", self.DoUseItem) end
		if strUseCommand == "buy" && self.DoUseItem then GAMEMODE.ActiveMenu:AddOption("Buy", self.DoUseItem) end
		if strUseCommand == "sell" && intCost > 0 && self.DoUseItem then GAMEMODE.ActiveMenu:AddOption("Sell", self.DoUseItem) end
		if strUseCommand == "sell" && intCost > 0 && intAmount > 1 then GAMEMODE.ActiveMenu:AddOption("Sell All", function() self.DoUseItem(intAmount) end) end
		if strUseCommand == "use" && tblItemTable.Dropable then GAMEMODE.ActiveMenu:AddOption("Drop", self.DoDropItem) end
		if strUseCommand == "use" && tblItemTable.Giveable && #player.GetAll() > 1 then
			local GiveSubMenu = nil
			for _, player in pairs(player.GetAll()) do
				if player:GetPos():Distance(LocalPlayer():GetPos()) < 250 && player != LocalPlayer() then
					GiveSubMenu = GiveSubMenu or GAMEMODE.ActiveMenu:AddSubMenu("Give ...")
					GiveSubMenu:AddOption(player:Nick(), function() self.DoGiveItem(player) end)
				end
			end
		end
		GAMEMODE.ActiveMenu:Open()
	end
	self:SetRightClick(menuFunc)
end

function PANEL:SetSlot(tblSlotTable)
	local strToolTip = ""
	if tblSlotTable then
		if tblSlotTable.PrintName then strToolTip = Format("%s", tblSlotTable.PrintName) end
		if tblSlotTable.Desc then strToolTip = Format("%s\n%s", strToolTip, tblSlotTable.Desc) end
	end
	self.IsPapperDollSlot = true
	self:SetDragable(false)
	self:SetIcon(nil)
	self:SetTooltip(strToolTip)
	self:SetDropedOn(function()
		if GAMEMODE.DraggingPanel && GAMEMODE.DraggingPanel.Slot && GAMEMODE.DraggingPanel.Slot == tblSlotTable.Name then
			if GAMEMODE.DraggingPanel.Item && LocalPlayer().Data.Paperdoll[tblSlotTable.Name] != GAMEMODE.DraggingPanel.Item then
				GAMEMODE.DraggingPanel.DoDoubleClick()
			end
		end
	end)
	self:SetDoubleClick(function() end)
	self:SetRightClick(function() end)
end

function PANEL:SetSkill(tblSkillTable, intSkillLevel)
	if !tblSkillTable then return false end
	local strToolTip = ""
	if tblSkillTable.PrintName then strToolTip = Format("%s", tblSkillTable.PrintName) end
	if tblSkillTable.Desc["story"] then strToolTip = Format("%s\n%s", strToolTip, tblSkillTable.Desc["story"]) end
	if tblSkillTable.Desc[intSkillLevel] then strToolTip = Format("%s\n%s", strToolTip, tblSkillTable.Desc[intSkillLevel]) end
	if tblSkillTable.Desc[intSkillLevel + 1] && tblSkillTable.Desc[intSkillLevel] then strToolTip = Format("%s\n\n%s", strToolTip, "Next Level") end
	if tblSkillTable.Desc[intSkillLevel + 1] then strToolTip = Format("%s\n%s", strToolTip, tblSkillTable.Desc[intSkillLevel + 1]) end
	self:SetTooltip(strToolTip)
	self:SetIcon(tblSkillTable.Icon or nil)
	self:SetText((intSkillLevel or 0) .. "/" .. tblSkillTable.Levels)
	self:SetDragable(false)
	
	self:SetDoubleClick(function() RunConsoleCommand("UD_BuySkill", tblSkillTable.Name) end)
end
vgui.Register("FIconItem", PANEL, "Panel")
