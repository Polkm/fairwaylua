PANEL = {}
PANEL.Frame = nil

function PANEL:Init()
	self:SetSize(500, 300)
	self.Frame = vgui.Create("DFrame")
	self.Frame:SetTitle("")
	self.Frame:SetDraggable(false)
	self.Frame:ShowCloseButton(false)
	self.Frame.Paint = function() end
	self.Frame:SetAlpha(0)
	self.Frame:MakePopup()
	
	self:PerformLayout()
end

function PANEL:PerformLayout()
	self.Frame:SetPos(self:GetPos())
	self.Frame:SetSize(self:GetSize())
end
vgui.Register("shopmenu", PANEL, "Panel")
