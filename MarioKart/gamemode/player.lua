function GM:PlayerInitialSpawn(ply)
	//ply:SetModel("models/gmodcart/regular_cart.mdl")
end

function GM:PlayerSpawn(ply)
	if ply:GetNWEntity("Cart"):IsValid() then ply:GetNWEntity("Cart"):Remove() end
	local cart = ents.Create("player_cart")
	cart:SetPos(ply:GetPos())
	cart:Spawn()
	cart:SetOwner(ply)
	ply:SetNWEntity("Cart", cart)
	ply:SetNWInt("CheckPoint", 1)
	ply:SetNWInt("Lap", 1)
	ply:SetNWInt("Place",1)
	--ply:SetNWString("item","item_koopashell_red")
	ply:SetNWString("item","item_banana")
	ply.CanJump = true
	ply:SetNWEntity("activeitem", "none")
	GAMEMODE:SetPlayerSpeed(ply,0,0)
	cart:SetPos(ply:GetPos())
	cart:SetAngles(ply:GetAngles())
	ply.wipeout = false
	ply:SetNoDraw(true)
	ply:SetPos(Vector(0,0,0))
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
	if ply:GetNWEntity("activeitem") == "none" && item != "empty" then
		ply:SetNWEntity("activeitem",GAMEMODE.mk_Items[item].SpawnFunction(ply))
		ply:GetNWEntity("activeitem").class = item
		ply:SetNWString("item", "empty")
		return
	elseif ply:GetNWEntity("activeitem") != "none" then
		GAMEMODE.mk_Items[ply:GetNWEntity("activeitem").class].UseFunction(ply:GetNWEntity("activeitem"))
		return
	end
end
concommand.Add("mk_FireItem", function(ply, command, args)
	GAMEMODE:FireItem(ply)
end)

