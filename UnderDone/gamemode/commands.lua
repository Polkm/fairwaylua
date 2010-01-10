local Player = FindMetaTable("Player")

----------------------------------------------------------------
--------------------------USER COMMANDS-------------------------
----------------------------------------------------------------
function Player:UseItem(strItem)
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	if tblItemTable && tblItemTable.Use && self:HasItem(strItem) then
		tblItemTable:Use(self, tblItemTable)
		return true
	end
	return false
end
concommand.Add("UD_UseItem", function(ply, command, args)
	ply:UseItem(tostring(args[1]))
end)

function Player:DropItem(strItem, intAmount)
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	if self:HasItem(strItem, intAmount) && tblItemTable.Dropable then
		local entDropEnt = GAMEMODE:BuildModel(tblItemTable.Model)
		entDropEnt:SetPos(self:EyePos() + (self:GetAimVector() * 25))
		local trace = self:GetEyeTrace()
		if trace.HitPos:Distance(self:GetPos()) < 80 then 
			entDropEnt:SetPos(trace.HitPos)
		end
		entDropEnt.Item = strItem
		entDropEnt.Amount = intAmount
		entDropEnt:Spawn()
		if !util.IsValidProp(entDropEnt:GetModel()) then
			local entCan = ents.Create("prop_physics")
			entCan:SetModel("models/props_junk/cardboard_box004a.mdl")
			entCan:SetPos(entDropEnt:GetPos())
			entCan:SetAngles(entDropEnt:GetAngles())
			entCan:SetCollisionGroup(COLLISION_GROUP_WORLD)
			entCan:SetColor(0, 0, 0, 0)
			entCan:Spawn()
			entDropEnt:SetParent(entCan)
		end
		self:AddItem(strItem, -intAmount)
		return true
	end
	return false
end
concommand.Add("UD_DropItem", function(ply, command, args) 
	local amount = math.Clamp(tonumber(args[2]), 1, ply.Data.Inventory[args[1]]) or 1
	ply:DropItem(args[1], amount) 
end)

function Player:GiveItem(strItem, intAmount, plyTarget)
	local Target = player.GetByID(plyTarget)
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	Target:TransferItem(self, strItem, intAmount)
	Target:ConCommand("UD_AddNotification " .. self:Nick() .. " Gave you " .. tostring(intAmount) .. " " .. tblItemTable.PrintName) 
end
concommand.Add("UD_GiveItem", function(ply, command, args) ply:GiveItem(args[1], args[2], tonumber(args[3])) end)

function Player:TakeItem(strItem, intAmount)
	--[[if self.Muggie && self.Muggie.Inventory && self.Muggie.Inventory[strItem] >= intAmount then
		TransferItem(self, self.Muggie, strItem, intAmount)
	end]]
end
concommand.Add("UD_TakeItem", function(ply, command, args) ply:TakeItem(args[1], args[2]) end)

----------------------------------------------------------------
-------------------------ADMIN COMMANDS-------------------------
----------------------------------------------------------------
function AdminKick(plyOffender, strReason)
	if !plyOffender:IsPlayer() then return end
	if strReason == "" then strReason = nil end
	strReason = strReason or "Don't do that again"
	plyOffender:Kick(Reason)
end
concommand.Add("UD_Admin_Kick", function(ply, command, args)
	if !ply:IsAdmin() or !ply:IsPlayer() then return end
	AdminKick(player.GetByID(tonumber(args[1])), tostring(args[2]))
end)




