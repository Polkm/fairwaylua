GM.Name 		= "Shell Shocked game"
GM.Author 		= "Shell Shocked"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= true

GM.PosibleColors = {}
GM.PosibleColors["red"] = "models/gmodcart/CartBody_red"
GM.PosibleColors["green"] = "models/gmodcart/CartBody_green"

GM.mk_Items = {}

GM.mk_Items["item_koopashell_green"] = {
Name = "Green Shell",
Model = "models/gmodcart/items/koopashell.mdl",
Skin = 1,
Material = "",
UseFunction = function(ply)
	local item = ents.Create("ent_projectile")
	local cart = ply:GetNWEntity("Cart")
	item:SetPos(cart:GetPos() + cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
	item:SetModel("models/gmodcart/items/koopashell.mdl")
	item:SetOwner(ply)
	item:Spawn()
	item:SetParent(cart)
	item:PhysicsInit(SOLID_VPHYSICS)
	item:GetPhysicsObject():SetMaterial("gmod_ice")
	return item
end,
}
-----------------
GM.mk_Items["item_koopashell_red"] = {
Name = "Red Shell",
Model = "models/gmodcart/items/koopashell.mdl",
Skin = 2,
Material = "",
UseFunction = function(ply)

end,
}
-----------------
GM.mk_Items["item_koopashell_blue"] = {
Name = "Blue Shell",
Model = "models/gmodcart/items/koopashell.mdl",
Skin = 3,
Material = "",
UseFunction = function(ply)

end,
}
-----------------
GM.mk_Items["item_multi_koopashell_green"] = {
Name = "Blue Shell",
Model = "models/gmodcart/items/koopashell.mdl",
Skin = 1,
Material = "",
UseFunction = function(ply)

end,
}
-----------------
GM.mk_Items["item_multi_koopashell_red"] = {
Name = "Blue Shell",
Model = "models/gmodcart/items/koopashell.mdl",
Skin = 2,
Material = "",
UseFunction = function(ply)

end,
}
-----------------
GM.mk_Items["item_multi_koopashell_blue"] = {
Name = "Blue Shell",
Model = "models/gmodcart/items/koopashell.mdl",
Skin = 3,
Material = "",
UseFunction = function(ply)

end,
}
-----------------
GM.mk_Items["item_banana"] = {
Name = "Blue Shell",
Model = "models/gmodcart/items/koopashell.mdl",
Skin = 1,
UseFunction = function(ply)

end,
}
-----------------
GM.mk_Items["item_multi_banana"] = {
Name = "Blue Shell",
Model = "models/gmodcart/items/koopashell.mdl",
Skin = 1,
Material = "",
UseFunction = function(ply)

end,
}
-----------------
