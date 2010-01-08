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
