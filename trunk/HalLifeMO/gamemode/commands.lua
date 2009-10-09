local Player = FindMetaTable("Player")

function Player:SellWeapon(strWeapon)
	if !self:HasWeapon(strWeapon) then return end
	if !WeaponData[strWeapon].Sellable then return end
	if self:RemoveWeaponFromLoadOut(strWeapon) then
		self:StripWeapon(strWeapon)
		local price = WeaponData[strWeapon].SellPrice or WeaponData["default"].SellPrice
		self:GiveCash(price)
	end
end
concommand.Add("hlmo_sellweapon",
function(ply, command, args)
	ply:SellWeapon(tostring(args[1]))
end)

function Player:BuyWeapon(strWeapon)
	if !WeaponData[strWeapon].Buyable then return end
	local intBuyCost = WeaponData[strWeapon].BuyPrice or WeaponData["default"].BuyPrice
	--print(self:GetNWInt("cash"), intBuyCost)
	if self:GetNWInt("cash") < intBuyCost then return end
	if self:AddWeaponToLoadOut(strWeapon) then
		self:Give(strWeapon)
		self:GiveCash(-intBuyCost)
	end
end
concommand.Add("hlmo_buyweapon",
function(ply, command, args)
	ply:BuyWeapon(tostring(args[1]))
end)