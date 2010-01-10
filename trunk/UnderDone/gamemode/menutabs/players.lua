PANEL = {}
PANEL.mainlist = nil
PANEL.servercatagory = nil

function PANEL:Init()
	self.mainlist = vgui.Create("DPanelList", self)
	self.mainlist:SetSpacing(2)
	self.mainlist:SetPadding(2)
	self.mainlist:EnableHorizontal(false)
	self.mainlist:EnableVerticalScrollbar(true)
		self.servercatagory = vgui.Create("FListItem")
		self.servercatagory:SetNameText("Server")
		self.servercatagory:SetDescText(#player:GetAll() .. " Player(s)")
		self.servercatagory:SetIcon("gui/server")
		self.servercatagory:SetColor(clrTan)
		self.servercatagory:SetExpandable(true)
		self.servercatagory:SetExpanded(true)
	self.mainlist:AddItem(self.servercatagory)
	self.mainlist.Paint = function()
		local tblPaintPanle = jdraw.NewPanel()
		tblPaintPanle:SetDemensions(0, 0, self.mainlist:GetWide(), self.mainlist:GetTall())
		tblPaintPanle:SetStyle(4, clrGray)
		tblPaintPanle:SetBoarder(1, clrDrakGray)
		jdraw.DrawPanel(tblPaintPanle)
	end
	self:LoadPlayers()
end

function PANEL:PerformLayout()
	self.mainlist:SetSize(self:GetWide(), self:GetTall())
end

function PANEL:LoadPlayers()
	if self.servercatagory.ContentList then self.servercatagory.ContentList:Clear() end
	self.servercatagory:SetDescText(#player:GetAll() .. " Player(s)")
	for _, player in pairs(player:GetAll()) do
		-------------------------
		local ListItem = vgui.Create("FListItem")
		ListItem:SetHeaderSize(25)
		ListItem:SetAvatar(player, 20)
		-------------------------
		ListItem:SetNameText(player:Nick())
		ListItem:SetColor(clrGray)
		ListItem:SetIcon("gui/player")
		if player:GetFriendStatus() then ListItem:SetIcon("gui/player_green") end
		if player:IsAdmin() then ListItem:SetIcon("gui/admin") end
		------Common Button------
		local toggleMuteFunc = function()
			player:SetMuted()
			local icon = "gui/sound_on"
			local tooltip = "Mute"
			if player:IsMuted(player) then icon = "gui/sound_off" tooltip = "Un Mute" end
			ListItem.CommonButton:SetMaterial(icon)
			ListItem.CommonButton:SetTooltip(tooltip)
		end
		local icon = "gui/sound_on"
		local tooltip = "Mute"
		if player:IsMuted() then icon = "gui/sound_off" tooltip = "Un Mute" end
		ListItem:SetCommonButton(icon, toggleMuteFunc, tooltip)
		----Secondary Buttons----
		local menuFunc = function()
			GAMEMODE.MainMenu.ActiveMenu = DermaMenu()
			local strText = "Mute"
			if player:IsMuted() then strText = "Un Mute" end
			GAMEMODE.MainMenu.ActiveMenu:AddOption(strText, toggleMuteFunc)
			if LocalPlayer():IsAdmin() then
				GAMEMODE.MainMenu.ActiveMenu:AddSpacer()
				GAMEMODE.MainMenu.ActiveMenu:AddOption("Kick", function() RunConsoleCommand("UD_Admin_Kick", player:EntIndex()) end)
			end
			GAMEMODE.MainMenu.ActiveMenu:Open()
		end
		ListItem:SetSecondaryButton("gui/options", menuFunc, "Actions")
		-------------------------
		ListItem.DoRightClick = menuFunc
		-------------------------
		self.servercatagory:AddContent(ListItem)
	end
	self:PerformLayout()
end

vgui.Register("playerstab", PANEL, "Panel")