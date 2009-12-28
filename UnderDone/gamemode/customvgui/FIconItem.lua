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
local matBoarderIcon = surface.GetTextureID("icons/icon_boarder")
PANEL.Icon = nil
PANEL.Amount = nil
PANEL.LastClick = nil

function PANEL:AllowedDrop(Wide,Tall,X,Y,Alpha)
	AllowedDrop = vgui.Create("DPanel")
	AllowedDrop:SetSize( Wide, Tall )
	AllowedDrop:SetPos( X, Y )
	AllowedDrop:SetAlpha(Alpha)
	AllowedDrop:MakePopup()
end

function PANEL:GhostIcon()
	GhostIcon = vgui.Create("FIconItem")
	GhostIcon:SetSize( self:GetWide(), self:GetTall() )
	GhostIcon.Icon = self.Icon
	GhostIcon.Amount = self.Amount
	GhostIcon:SetAlpha(200)
	GhostIcon:MakePopup()
end

function PANEL:Init()
	--RightClick Dectection--
	self.LastClick = 0
	self:SetMouseInputEnabled(true)
	self.OnMousePressed = function(self, mousecode)
		self:MouseCapture(true)
		if mousecode == MOUSE_LEFT then
			if self.Icon then
				self.ClickedIcon = true
				self:GhostIcon()
				self:AllowedDrop(self:GetWide(), self:GetTall(),ScrW() *	0.565,ScrH() * 0.31,200)
			end	
		end
	end
	self.OnMouseReleased = function(self, mousecode)
		self:MouseCapture(false)
		if mousecode == MOUSE_RIGHT then
			PCallError(self.DoRightClick, self)
			if self.ClickedIcon then
				self.ClickedIcon = false
				GhostIcon:Remove()
				AllowedDrop:Remove()
			end
		end
		if mousecode == MOUSE_LEFT then
			if self.HasEntered then
				PCallError(self.EnteredFrame, self)
				AllowedDrop:Remove()
			end
			if self.ClickedIcon then
				self.ClickedIcon = false
				GhostIcon:Remove()
				AllowedDrop:Remove()
			end
			if (SysTime() - self.LastClick) < 0.3 then
				PCallError(self.DoDoubleClick, self) return
			end
			PCallError(self.DoClick, self)
			self.LastClick = SysTime()
		end
	end
	-------------------------
	self.DoClick = function() end
	self.DoRightClick = function() end
	self.DoDoubleClick = function() end
	self.EnteredFrame = function() end
	-------------------------
end

function PANEL:Think()
	if self.ClickedIcon then
		local Position = GhostIcon:GetPos() - AllowedDrop:GetPos()
		if Position < 38  && Position > 0 then	
			self.HasEntered = true
		else
			self.HasEntered = false
		end
		GhostIcon:SetPos( gui.MouseX(),gui.MouseY())
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
	
	if self.Amount then
		local width, tall = surface.GetTextSize(tostring(self.Amount)) 
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(self:GetWide() - width - 1, self:GetTall() - tall - 2) 
		surface.DrawText(tostring(self.Amount))
	end
	return true
end

function PANEL:SetIcon(strIconText)
	self.Icon = strIconText
	if strIconText then
		self.Icon = surface.GetTextureID(strIconText)
	end
end

function PANEL:SetAmount(itnAmount)
	self.Amount = itnAmount
end

function PANEL:SetRightClick(fncRightClick)
	self.DoRightClick = fncRightClick
end

function PANEL:SetDoubleClick(fncDoubleClick)
	self.DoDoubleClick = fncDoubleClick
end

function PANEL:SetEnteredFrame(fncEnteredFrame)
	self.EnteredFrame = fncEnteredFrame
end

function PANEL:SetItem(tblItemTable, intAmount)
	tblItemTable = tblItemTable or BaseItem
	intAmount = intAmount or 1
	if tblItemTable.Icon then self:SetIcon(tblItemTable.Icon) end
	if tblItemTable.Stackable && intAmount > 1 then self:SetAmount(intAmount) end
	---------ToolTip---------
	local Tooltip = Format("%s", tblItemTable.PrintName)
	if tblItemTable.Desc then Tooltip = Format("%s\n%s", Tooltip, tblItemTable.Desc) end
	if tblItemTable.Weight && tblItemTable.Weight > 0 then Tooltip = Format("%s\n%s Kgs", Tooltip, tblItemTable.Weight) end
	self:SetTooltip(Tooltip)
	------Double Click------
	if tblItemTable.Use then
		local useFunc = function()
			RunConsoleCommand("UD_UseItem", tblItemTable.Name)
		end
		self:SetDoubleClick(useFunc)
		local EnterFrame = function()
			RunConsoleCommand("UD_UseItem", tblItemTable.Name)
		end
		self:SetEnteredFrame(EnterFrame)
	end
	-------Right Click-------
	local menuFunc = function()
		GAMEMODE.MainMenu.ActiveMenu = DermaMenu()
		if tblItemTable.Use then GAMEMODE.MainMenu.ActiveMenu:AddOption("Use", function() RunConsoleCommand("UD_UseItem", tblItemTable.Name) end) end
		if tblItemTable.Dropable then
			GAMEMODE.MainMenu.ActiveMenu:AddOption("Drop", function()
				if tblItemTable.Stackable and intAmount >= 5 then
					DisplayPromt("number", "How many to drop", function(itemamount) RunConsoleCommand("UD_DropItem", tblItemTable.Name, itemamount) end, tblItemTable.Name)
				else
					RunConsoleCommand("UD_DropItem", tblItemTable.Name, 1)
				end
			end)
		end
		if tblItemTable.Giveable then
			for _, player in pairs(player.GetAll()) do
				if player:GetPos():Distance(LocalPlayer():GetPos()) < 250 && player != LocalPlayer() then
					local GiveSubMenu = GAMEMODE.MainMenu.ActiveMenu:AddSubMenu("Give ...")
					GiveSubMenu:AddOption(player:Nick(), function()
						if tblItemTable.Stackable and intAmount >= 5 then 
							DisplayPromt("number", "How many to give", function(itemamount) RunConsoleCommand("UD_GiveItem", tblItemTable.Name, itemamount, player:EntIndex()) end, tblItemTable.Name)
						else 
							RunConsoleCommand("UD_GiveItem", tblItemTable.Name, 1, player:EntIndex())
						end
					 end)
				end
			end
		end
		GAMEMODE.MainMenu.ActiveMenu:Open()
	end
	self:SetRightClick(menuFunc)
end

function PANEL:SetSlot(tblSlotTable)
	local strIcon = nil
	local strToolTip = ""
	if tblSlotTable then
		if tblSlotTable.PrintName then strToolTip = Format("%s", tblSlotTable.PrintName) end
		if tblSlotTable.Desc then strToolTip = Format("%s\n%s", strToolTip, tblSlotTable.Desc) end
	end
	self:SetIcon(strIcon)
	self:SetTooltip(strToolTip)
	self:SetDoubleClick(function() end)
	self:SetRightClick(function() end)
end

vgui.Register("FIconItem", PANEL, "Label")
