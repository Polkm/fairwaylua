function GM:PlayerInitialSpawn(ply)
	//ply:SetModel("models/gmodcart/regular_cart.mdl")
end

function GM:PlayerSpawn(ply)
	if ply:GetNWEntity("Cart"):IsValid() then ply:GetNWEntity("Cart"):Remove() end
	local cart = ents.Create("player_cart")
	local box = ents.Create("item_box")
	box:SetPos(Vector(0, 0, 40))
	box:Spawn()
	cart:SetPos(ply:GetPos())
	cart:Spawn()
	cart:SetOwner(ply)
	ply:SetNWEntity("Cart", cart)
	ply:SetNWInt("CheckPoint", 1)
	ply:SetNWInt("Lap", 1)
	ply:SetNWInt("Place",1)
	ply:SetNWString("item","item_koopashell_green")
	ply.CanJump = true
	ply:SetNWEntity("activeitem", "none")
	GAMEMODE:SetPlayerSpeed(ply,0,0)
	cart:SetPos(ply:GetPos())
	cart:SetAngles(ply:GetAngles())
end

function GM:SetPlayerColor(ply, strColor)
	if GAMEMODE.PosibleColors[strColor] then
		ply:GetNWEntity("Cart").BodyFrame:SetMaterial(GAMEMODE.PosibleColors[strColor])
	end
end
concommand.Add("mk_changeCarColor", function(ply, command, args)
	GAMEMODE:SetPlayerColor(ply, args[1])
end)

function GM:FireItem(ply)
	local item = ply:GetNWString("item")
	print("ran")
	if ply:GetNWEntity("activeitem") == "none" && item != "none" then
	print("ran")
		ply:SetNWEntity("activeitem",GAMEMODE.mk_Items[item].UseFunction(ply))
		ply:SetNWString("item", "none")
		return
	elseif ply:GetNWEntity("activeitem") != "none" then
		ply:GetNWEntity("activeitem"):UseItem()
		ply:SetNWEntity("activeitem", nil)
		return
	end
end
concommand.Add("mk_FireItem", function(ply, command, args)
	GAMEMODE:FireItem(ply)
end)