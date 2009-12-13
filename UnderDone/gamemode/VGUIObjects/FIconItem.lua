--[[
                     `.--.                                                      
  sMMMMMMMNds.    -yNMMMMMMdo`    sMMM         dMMd   `sMMNs` -MMMMs    .mMMMs  
  sMMM+++sMMMM-  sMMMh/--+NMMN-   sMMM         dMMd  :NMMh.   -MMMMM+  `mMMMMs  
  sMMM    hMMM/ /MMMh     -NMMm`  sMMM         dMMd`hMMm:     -MMMmMM/ hMmMMMs  
  sMMMssymMMMy  sMMM+      dMMM-  sMMM         dMMNNMMN-      -MMM+hMNyMN-MMMs  
  sMMMddddyo.   +MMMs     `NMMN.  sMMM         dMMNodMMMo`    -MMM+`mMMM: MMMs  
  sMMM          `hMMMs. `:dMMM+   sMMM------.  dMMd  +NMMm:   -MMM+ .ss+  MMMs  
  sMMM            +mMMMMMMMMy-    sMMMMMMMMMd  dMMd   .hMMMy` -MMM+       MMMs  
  .---              `:/++/-       .---------.  .--.     ----. `---`       ---.  2009
]]

local PANEL = {}
local matGlossIcon = surface.GetTextureID("icons/icon_gloss")
local matBoarderIcon = surface.GetTextureID("icons/icon_boarder")
PANEL.Icon = nil
PANEL.Amount = nil
PANEL.LastClick = nil

function PANEL:Init()
	--RightClick Dectection--
	self.LastClick = 0
	self:SetMouseInputEnabled(true)
	self.OnMousePressed = function(self, mousecode)
		self:MouseCapture(true)
	end
	self.OnMouseReleased = function(self, mousecode)
		self:MouseCapture(false)
		if mousecode == MOUSE_RIGHT then
			PCallError(self.DoRightClick, self)
		end
		if mousecode == MOUSE_LEFT then
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
	-------------------------
end

function PANEL:Paint()
	if self.Icon then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(self.Icon)
		surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
		surface.SetDrawColor(255, 255, 255, 20)
		surface.SetTexture(matGlossIcon)
		surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetTexture(matBoarderIcon)
		surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
	end
	if self.Amount then
		local width, tall = surface.GetTextSize(tostring(self.Amount)) 
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(self:GetWide() - width - 1, self:GetTall() - tall - 2) 
		surface.DrawText(tostring(self.Amount))
	end
	return true
end

function PANEL:SetIcon(strIconText)
	self.Icon = surface.GetTextureID(strIconText)
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

vgui.Register("FIconItem", PANEL, "Label")