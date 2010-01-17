local Player = FindMetaTable("Player")

----------------------------------------------------------------
--------------------------USER COMMANDS-------------------------
----------------------------------------------------------------
function Player:UseItem(strItem)
	local tblItemTable = ItemTable(strItem)
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
	local tblItemTable = ItemTable(strItem)
	if self:HasItem(strItem, intAmount) && tblItemTable.Dropable then
		entDropedItem = CreateWorldItem(strItem, intAmount)
		entDropedItem:SetPos(self:EyePos() + (self:GetAimVector() * 25))
		local trace = self:GetEyeTrace()
		if trace.HitPos:Distance(self:GetPos()) < 80 then 
			entDropedItem:SetPos(trace.HitPos)
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
	Target:CreateNotification(self:Nick() .. " Gave you " .. tostring(intAmount) .. " " .. tblItemTable.PrintName)
end
concommand.Add("UD_GiveItem", function(ply, command, args) ply:GiveItem(args[1], args[2], tonumber(args[3])) end)

function Player:BuyItem(strItem)
	local tblNPCTable = NPCTable(self.UseTarget:GetNWString("npc"))
	if tblNPCTable && tblNPCTable.Shop && tblNPCTable.Shop[strItem] then
		local tblItemInfo = tblNPCTable.Shop[strItem]
		if self:HasItem("money", tblItemInfo.Price) && self:AddItem(strItem, 1) then
			self:RemoveItem("money", tblItemInfo.Price)
		end
	end
end
concommand.Add("UD_BuyItem", function(ply, command, args) ply:BuyItem(args[1]) end)

function Player:SellItem(strItem)
	local tblNPCTable = NPCTable(self.UseTarget:GetNWString("npc"))
	if tblNPCTable && tblNPCTable.Shop && self:HasItem(strItem, 1) then
		local tblItemTable = ItemTable(strItem)
		if tblItemTable.SellPrice > 0 && self:RemoveItem(strItem, 1) then
			self:AddItem("money", tblItemTable.SellPrice)
		end
	end
end
concommand.Add("UD_SellItem", function(ply, command, args) ply:SellItem(args[1]) end)

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




