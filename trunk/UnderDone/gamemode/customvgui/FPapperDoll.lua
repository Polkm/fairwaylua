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
PANEL.Slots = {}
PANEL.ItemIconSize = 39

function PANEL:Init()
	for _, slotTable in pairs(GAMEMODE.DataBase.Slots) do
		local icnItem = vgui.Create("FIconItem", self)
		icnItem:SetSize(self.ItemIconSize, self.ItemIconSize)
		icnItem:SetPos(slotTable.Position.x, slotTable.Position.y)
		icnItem:SetSlot(slotTable)
		self.Slots[slotTable.Name] = icnItem
	end
end

vgui.Register("FPaperDoll", PANEL, "Panel")