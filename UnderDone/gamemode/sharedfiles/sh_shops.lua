local Shop = {}
Shop.Name = "shop_general"
Shop.PrintName = "Shop General"
Shop.Inventory = {}
Shop.Inventory["can"] = {Price = 15}
Shop.Inventory["small_ammo"] = {Price = 10}
Shop.Inventory["health_kit"] = {Price = 80}
Register.Shop(Shop)

if SERVER then
	local Player = FindMetaTable("Player")
	function Player:BuyItem(strItem)
		local tblNPCTable = NPCTable(self.UseTarget:GetNWString("npc"))
		local tblShopTable = ShopTable(tblNPCTable.Shop)
		if tblNPCTable && tblShopTable && tblShopTable.Inventory[strItem] then
			local tblItemInfo = tblShopTable.Inventory[strItem]
			if self:HasItem("money", tblItemInfo.Price) && self:AddItem(strItem, 1) then
				self:RemoveItem("money", tblItemInfo.Price)
			end
		end
	end
	concommand.Add("UD_BuyItem", function(ply, command, args) ply:BuyItem(args[1]) end)

	function Player:SellItem(strItem, intAmount)
		intAmount = intAmount or 1
		local tblNPCTable = NPCTable(self.UseTarget:GetNWString("npc"))
		if tblNPCTable && tblNPCTable.Shop && self:HasItem(strItem, intAmount) then
			local tblItemTable = ItemTable(strItem)
			if tblItemTable.SellPrice > 0 && self:RemoveItem(strItem, intAmount) then
				self:AddItem("money", tblItemTable.SellPrice * intAmount)
			end
		end
	end
	concommand.Add("UD_SellItem", function(ply, command, args) ply:SellItem(args[1], tonumber(args[2])) end)
end