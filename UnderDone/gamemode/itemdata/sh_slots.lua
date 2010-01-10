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
	local tblPrimaryWeapon = ItemTable(ply:GetSlot("slot_primaryweapon"))
	local tblSheild = ItemTable(ply:GetSlot("slot_offhand"))
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
	local tblPrimaryWeapon = ItemTable(ply:GetSlot("slot_primaryweapon"))
	if !tblPrimaryWeapon or (tblPrimaryWeapon and tblPrimaryWeapon.HoldType and tblPrimaryWeapon.HoldType == "melee") then
		return false
	end
	return true
end
Register.Slot(SLOT)
