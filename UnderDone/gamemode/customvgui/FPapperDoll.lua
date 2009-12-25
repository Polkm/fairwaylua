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