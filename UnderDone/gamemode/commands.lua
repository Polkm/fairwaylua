local Player = FindMetaTable("Player")

----------------------------------------------------------------
--------------------------USER COMMANDS-------------------------
----------------------------------------------------------------
function Player:UseItem(strItem)
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	if tblItemTable && tblItemTable.Use && HasItem(self, strItem) then
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
	if HasItem(self, strItem, intAmount) && tblItemTable.Dropable then
		local dropeditem = ents.Create("prop_physics")
		dropeditem:SetModel(tblItemTable.Model)
		dropeditem:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		dropeditem:SetPos(self:EyePos() + (self:GetAimVector() * 25))
		local trace = self:GetEyeTrace()
		if trace.HitPos:Distance(self:GetPos()) < 80 then 
			dropeditem:SetPos(trace.HitPos)
		end
		dropeditem.Item = strItem
		dropeditem.Amount = intAmount
		dropeditem:Spawn()
		RemoveItemFromInv(self, strItem, intAmount)
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
	TransferItem(Target, self, strItem, intAmount)
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
	local Reason = strReason or "Don't do that again"
	plyOffender:Kick(Reason)
end
concommand.Add("UD_Admin_Kick", function(ply, command, args)
	if !ply:IsAdmin() or !ply:IsPlayer() then return end
	AdminKick(player.GetByID(tonumber(args[1])), tostring(args[2]))
end)




