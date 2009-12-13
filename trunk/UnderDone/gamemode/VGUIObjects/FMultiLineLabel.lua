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

PANEL.Text = nil
PANEL.Font = nil
PANEL.FixedHieght = nil

function PANEL:Init()
	self:SetDrawOnTop(false)
	self.DeleteContentsOnClose = true
	self.Text = {}
	self.Font = "Default"
	self.FixedHieght = false
end

function PANEL:Paint()
	derma.SkinHook("Paint","MultiLineLabel",self)
	local Yoffset = 5
	local Word = 1
	local CurrentLine = {}
	for k,v in pairs(self.Text) do
		surface.SetFont(self.Font)
		local w,h = surface.GetTextSize(tostring(table.concat(CurrentLine," ")))
		local wb,hb = surface.GetTextSize(tostring(" "..v))
		local StringWidth = w + wb + 10
		if StringWidth <= self:GetWide() and v != "/n" and v != "[n]" then
			table.insert(CurrentLine,v)
		end
		if StringWidth > self:GetWide() or Word >= #self.Text or v == "/n" or v == "[n]" then
			if v == "/n" or v == "[n]" then
				surface.SetFont(self.Font)
				surface.SetTextColor(Color(60,60,60,255))
				surface.SetTextPos(5,Yoffset)
				surface.DrawText(tostring(table.concat(CurrentLine," ")))
				Yoffset = Yoffset + 15
				table.Empty(CurrentLine)
			else
				surface.SetFont(self.Font)
				surface.SetTextColor(Color(60,60,60,255))
				surface.SetTextPos(5,Yoffset)
				surface.DrawText(tostring(table.concat(CurrentLine," ")))
				Yoffset = Yoffset + 15
				table.Empty(CurrentLine)
				table.insert(CurrentLine,v)
			end
		end
		Word = Word + 1
	end
	if !self.FixedHieght then
		self:SetSize(self:GetWide(),Yoffset)
	end
	return true
end

function PANEL:SetText(text)
	self.Text = string.Explode(" ",text)
end 
function PANEL:GetText()
	return self.Text
end

function PANEL:SetFont(font)
	self.Font = font
end 
function PANEL:GetFont()
	return self.Font
end

function PANEL:SetFixed(fixed)
	self.FixedHieght = fixed
end 
function PANEL:GetFixed()
	return self.FixedHieght
end
vgui.Register("FMultiLineLabel",PANEL)

function MultiExample()
	local f_Panel = vgui.Create("DFrame")
	f_Panel:SetSize(200,400)
	f_Panel:Center()
	f_Panel:SetTitle("Example")
	f_Panel:SetDraggable(true)
	f_Panel:ShowCloseButton(true)
	f_Panel:MakePopup()
		local MultiLine = vgui.Create("FMultiLineLabel")
		MultiLine:SetParent(f_Panel)
		MultiLine:SetPos(5,25)
		MultiLine:SetSize(190,375)
		MultiLine:SetText("Hey look at this thing /n /n yeah look at it indeed it looks realy cool look how its warping all this text /n /n and /n /n even /n /n making /n /n spaces!")
end
concommand.Add("MultiExample",MultiExample)