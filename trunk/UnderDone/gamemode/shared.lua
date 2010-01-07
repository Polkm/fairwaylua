-------------------------
---------Generic---------
GM.Name 		= "UnderDone"
GM.Author 		= "Shell Shocked Gaming"
GM.Email 		= "polkmpolkmpolkm@gmail.com"
GM.Website 		= "http://shellshocked.net46.net/"
-----Global Inv Vars-----
MaxWeight = 20
--------DataBase---------
GM.DataBase = {}
GM.DataBase.Items = {}
GM.DataBase.Slots = {}
GM.DataBase.Stats = {}
GM.DataBase.NPCs = {}
--------Register---------
Register = {}
function Register.Item(tblItem)
	GM.DataBase.Items[tblItem.Name] = tblItem
end
function Register.Slot(tblItem)
	GM.DataBase.Slots[tblItem.Name] = tblItem
end
local intStatIndex = 1
function Register.Stat(tblItem)
	GM.DataBase.Stats[tblItem.Name] = tblItem
	GM.DataBase.Stats[tblItem.Name].Index = intStatIndex
	intStatIndex = intStatIndex + 1
end
function Register.NPC(tblItem)
	GM.DataBase.NPCs[tblItem.Name] = tblItem
end
-------------------------
function GM:BuildModel(tblModelTable)
	local tblLoopTable = tblModelTable
	if type(tblModelTable) == "string" then
		tblLoopTable = {}
		tblLoopTable[1] = {Model = tblModelTable, Position = Vector(0, 0, 0), Angle = Angle(0, 0, 0)}
	end
	local entReturnEnt = nil
	local entNewPart = nil
	for key, modelinfo in pairs(tblLoopTable) do
		entNewPart = ents.Create("prop_physics")
		entNewPart:SetModel(modelinfo.Model)
		if entReturnEnt then entNewPart:SetAngles(entReturnEnt:GetAngles()) end
		if entReturnEnt then entNewPart:SetAngles(entNewPart:LocalToWorldAngles(modelinfo.Angle)) end
		if !entReturnEnt then entNewPart:SetAngles(modelinfo.Angle) end
		if entReturnEnt then entNewPart:SetPos(entReturnEnt:GetPos()) end
		if entReturnEnt then entNewPart:SetPos(entNewPart:LocalToWorld(modelinfo.Position)) end
		if !entReturnEnt then entNewPart:SetPos(modelinfo.Position) end
		entNewPart:SetParent(entReturnEnt)
		entNewPart:Spawn()
		entNewPart:SetCollisionGroup(GROUP_NONE)
		if entReturnEnt then
			entReturnEnt.Children = entReturnEnt.Children or {}
			table.insert(entReturnEnt.Children, entNewPart)
		end
		if !entReturnEnt then entReturnEnt = entNewPart end
	end
	return entReturnEnt
end

--Polkm: Example NPCs
local NPC = {}
NPC.Name = "citezen"
NPC.Gender = "random"
NPC.Wander = true
function NPC:GenerateInv(npc)
	npc.Inventory = {}
	npc.Inventory["money"] = math.random(5,25)
end
Register.NPC(NPC)

local NPC = {}
NPC.Name = "cop"
NPC.Gender = "random"
NPC.Wander = true
NPC.Cop = true
function NPC:GenerateInv(npc)
	npc.Inventory = {}
	npc.Inventory["money"] = math.random(5,50)
	npc.Inventory["pistol"] = 1
end
Register.NPC(NPC)



local SLOT = {}
SLOT.Name = "slot_necklace"
SLOT.PrintName = "Necklace"
SLOT.Desc = "Goes over your head"
SLOT.Position = Vector(75, 15, 0)
SLOT.Attachment = "anim_attachment_head"
Register.Slot(SLOT)

local SLOT = {}
SLOT.Name = "slot_helm"
SLOT.PrintName = "Helmet/Hat"
SLOT.Desc = "Goes on your head"
SLOT.Position = Vector(50, 15, 0)
SLOT.Attachment = "eyes"
Register.Slot(SLOT)

local SLOT = {}
SLOT.Name = "slot_chest"
SLOT.PrintName = "Chest Piece"
SLOT.Desc = "Goes on your chest"
SLOT.Position = Vector(50, 40, 0)
SLOT.Attachment = "chest"
Register.Slot(SLOT)

local SLOT = {}
SLOT.Name = "slot_primaryweapon"
SLOT.PrintName = "Primary Weapon"
SLOT.Desc = "Your main weapon"
SLOT.Position = Vector(25, 40, 0)
SLOT.Attachment = "anim_attachment_RH"
function SLOT:ShouldClear(ply, tblItemTable)
	local tblPrimaryWeapon = GAMEMODE.DataBase.Items[ply.Data.Paperdoll["slot_primaryweapon"]]
	local tblSheild = GAMEMODE.DataBase.Items[ply.Data.Paperdoll["slot_offhand"]]
	if !tblSheild or (tblSheild and tblPrimaryWeapon.HoldType and tblPrimaryWeapon.HoldType == "melee") then
		return false
	end
	return true
end
Register.Slot(SLOT)

local SLOT = {}
SLOT.Name = "slot_offhand"
SLOT.PrintName = "Off Hand"
SLOT.Desc = "A off hand object for melee weapons"
SLOT.Position = Vector(75, 40, 0)
SLOT.Attachment = "anim_attachment_LH"
function SLOT:ShouldClear(ply, tblItemTable)
	local tblPrimaryWeapon = GAMEMODE.DataBase.Items[ply.Data.Paperdoll["slot_primaryweapon"]]
	if !tblPrimaryWeapon or (tblPrimaryWeapon and tblPrimaryWeapon.HoldType and tblPrimaryWeapon.HoldType == "melee") then
		return false
	end
	return true
end
Register.Slot(SLOT)










