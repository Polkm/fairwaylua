function AddItemToInv(objTarget, strItem, intAmount)
	local intAmountToAdd = tonumber(intAmount) or 1
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	if tblItemTable then
		local tblDataTable = objTarget
		if objTarget:GetClass() == "player" then tblDataTable = objTarget.Data end 
		if tblItemTable.Weight > 0 then
			if !objTarget.Weight then objTarget.Weight = 0 end
			intAmountToAdd = math.Clamp(math.floor((MaxWeight - objTarget.Weight) / tblItemTable.Weight), 0, intAmountToAdd)
		end
		if intAmountToAdd > 0 then
			if !tblDataTable.Inventory then tblDataTable.Inventory = {} end
			if tblDataTable.Inventory[strItem] then
				tblDataTable.Inventory[strItem] = tblDataTable.Inventory[strItem] + intAmountToAdd
			else
				tblDataTable.Inventory[strItem] = intAmountToAdd
			end
			objTarget.Weight = objTarget.Weight + (tblItemTable.Weight * intAmountToAdd)
			if tblItemTable.AddedToInv then tblItemTable:AddedToInv(objTarget) end
			if objTarget:GetClass() == "player" then
				umsg.Start("UD_UpdateItem", objTarget)
				umsg.String(strItem)
				umsg.Long(intAmountToAdd)
				umsg.End()
			end
			return true
		end
	end
	return false
end

function RemoveItemFromInv(objTarget, strItem, intAmount)
	local intAmountToRemove = tonumber(intAmount) or 1
	local tblItemTable = GAMEMODE.DataBase.Items[strItem]
	if tblItemTable && HasItem(objTarget, strItem, intAmountToRemove) then
		local tblDataTable = objTarget
		if objTarget:GetClass() == "player" then
			tblDataTable = objTarget.Data
			if tblDataTable.Paperdoll && table.HasValue(tblDataTable.Paperdoll, strItem) && tblDataTable.Inventory[strItem] == 1 then
				objTarget:EquiptItem(tblItemTable)
			end
		end
		tblDataTable.Inventory[strItem] = tblDataTable.Inventory[strItem] - intAmountToRemove
		if tblItemTable.RemovedFromInv then tblItemTable:RemovedFromInv(objTarget) end
		objTarget.Weight = objTarget.Weight - (tblItemTable.Weight * intAmountToRemove)
		if objTarget:GetClass() == "player" then
			umsg.Start("UD_UpdateItem", objTarget)
			umsg.String(strItem)
			umsg.Long(-intAmountToRemove)
			umsg.End()
		end
		return true
	end
	return false
end

function TransferItem(objTarget1, objTarget2, strItem1, intAmount1, strItem2, intAmount2)
	--Object 1
	local Inventory1 = {}
	if objTarget1:GetClass() == "player" then Inventory1 = objTarget1.Data.Inventory
	else Inventory1 = objTarget1.Inventory end
	local Item1 = tostring(strItem1) or "money"
	local Amount1 = tonumber(intAmount1) or 1
	--Object 2
	local Inventory2 = {}
	if objTarget2:GetClass() == "player" then Inventory2 = objTarget2.Data.Inventory 
	else Inventory2 = objTarget2.Inventory end
	local Item2 = nil
	if strItem2 then Item2 = tostring(strItem2) end
	local Amount2 = tonumber(intAmount2) or 0
	--Checking validity
	if Item1 then if !HasItem(objTarget2, Item1, Amount1) then return false end end
	if Item2 then if !HasItem(objTarget1, Item2, Amount2) then return false end end
	--Adding and removing
	if Item1 then if AddItemToInv(objTarget1, Item1, Amount1) then RemoveItemFromInv(objTarget2, Item1, Amount1) end end
	if Item2 then if AddItemToInv(objTarget2, Item2, Amount2) then RemoveItemFromInv(objTarget1, Item2, Amount2) end end
end

function HasItem(objTarget, strItem, intAmount)
	local Item = "money"
	if strItem then Item = tostring(strItem) end
	local Amount = tonumber(intAmount) or 1
	local DataTable = objTarget
	if objTarget:GetClass() == "player" then DataTable = objTarget.Data end
	if !DataTable.Inventory then return false end
	if DataTable.Inventory[Item] then
		if DataTable.Inventory[Item] - Amount >= 0 then
			return true
		end
	end
	return false
end