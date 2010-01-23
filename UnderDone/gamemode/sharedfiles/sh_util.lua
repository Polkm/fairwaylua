local Entity = FindMetaTable("Entity")
local Player = FindMetaTable("Player")

function toExp(intLevel)
	if intLevel <= 1 then intLevel = 0 end
	intLevel = math.pow(intLevel, 2)
	intLevel = intLevel * 20
	return intLevel
end

function toLevel(intExp)
	intExp = intExp / 20
	intExp = math.Clamp(intExp, 1, intExp)
	intExp = math.sqrt(intExp)
	intExp = math.floor(intExp)
	return intExp
end

function Entity:CreateGrip()
	local entGrip = ents.Create("prop_physics")
	entGrip:SetModel("models/props_junk/cardboard_box004a.mdl")
	entGrip:SetPos(self:GetPos())
	entGrip:SetAngles(self:GetAngles())
	entGrip:SetCollisionGroup(COLLISION_GROUP_WORLD)
	entGrip:SetColor(0, 0, 0, 0)
	entGrip:Spawn()
	self:SetParent(entGrip)
end

if SERVER then
	function SendUsrMsg(strName, plyTarget, tblArgs)
		umsg.Start(strName, plyTarget)
		for _, value in pairs(tblArgs or {}) do
			if type(value) == "string" then umsg.String(value)
			elseif type(value) == "number" then umsg.Long(value)
			elseif type(value) == "boolean" then umsg.Bool(value)
			elseif type(value) == "Entity" or type(value) == "Player" then umsg.Entity(value)
			elseif type(value) == "Vector" then umsg.Vector(value)
			elseif type(value) == "Angle" then umsg.Angle(value) end
		end
		umsg.End()
	end

	function CreateWorldItem(strItem, intAmount)
		local tblItemTable = ItemTable(strItem)
		if tblItemTable then
			local entWorldProp = GAMEMODE:BuildModel(tblItemTable.Model)
			entWorldProp.Item = strItem
			entWorldProp.Amount = intAmount or 1
			entWorldProp:Spawn()
			entWorldProp:SetNWString("PrintName", tblItemTable.PrintName)
			if !util.IsValidProp(entWorldProp:GetModel()) then
				entWorldProp:CreateGrip()
			end
			return entWorldProp
		end
	end
end

if CLIENT then
	function SendCompactCommand(strCommand, tblArgs)
		
		
	end
	
	function CreateGenericList(pnlParent, intSpacing, boolHorz, boolScrollz)
		local pnlNewList = vgui.Create("DPanelList", pnlParent)
		pnlNewList:SetSpacing(intSpacing)
		pnlNewList:SetPadding(intSpacing)
		pnlNewList:EnableHorizontal(boolHorz)
		pnlNewList:EnableVerticalScrollbar(boolScrollz)
		pnlNewList.Paint = function()
			local tblPaintPanel = jdraw.NewPanel()
			tblPaintPanel:SetDemensions(0, 0, pnlNewList:GetWide(), pnlNewList:GetTall())
			tblPaintPanel:SetStyle(4, clrGray)
			tblPaintPanel:SetBoarder(1, clrDrakGray)
			jdraw.DrawPanel(tblPaintPanel)
		end
		return pnlNewList
	end
end