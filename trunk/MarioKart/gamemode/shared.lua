GM.Name 		= "Shell Shocked game"
GM.Author 		= "Shell Shocked"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= true

GM.PosibleColors = {}
GM.PosibleColors["red"] = "models/gmodcart/CartBody_red"
GM.PosibleColors["green"] = "models/gmodcart/CartBody_green"
GM.PosibleColors["darkgreen"] = "models/gmodcart/CartBody_darkgreen"
GM.PosibleColors["orange"] = "models/gmodcart/CartBody_brown"
GM.PosibleColors["yellow"] = "models/gmodcart/CartBody_yellow"
GM.PosibleColors["darkyellow"] = "models/gmodcart/CartBody_darkyellow"
GM.PosibleColors["purple"] = "models/gmodcart/CartBody_purple"
GM.PosibleColors["pink"] = "models/gmodcart/CartBody_pink"

GM.mk_Items = {}
local tblNewItem = {}
tblNewItem.Name = "Green Shell"
tblNewItem.Model = "models/gmodcart/items/koopashell.mdl"
tblNewItem.Skin = 0
tblNewItem.Material = "gmodcart/items/mk_greenshell"
tblNewItem.SpawnFunction = function(ply)
	local Itemtype = ply:GetNWString("item")
	local item = ents.Create("ent_projectile")
	local cart = ply:GetNWEntity("Cart")
	item.class = Itemtype
	item:SetPos(cart:GetPos() + cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
	item:SetModel("models/gmodcart/items/koopashell.mdl")
	item:SetOwner(ply)
	item:Spawn()
	item:SetParent(cart)
	item:PhysicsInit(SOLID_VPHYSICS)
	item:GetPhysicsObject():SetMaterial("gmod_ice")
	item:GetOwner():SetNWEntity("activeitem",item)
end
tblNewItem.UseFunction = function(self)
		local cart = self:GetOwner():GetNWEntity("Cart")
		self:SetParent(nil)
		self.Entity:PhysicsInitSphere( 8.1, "metal_bouncy" )
		self.Entity:GetPhysicsObject():Wake()
		constraint.NoCollide(self.Entity,cart,0,0)
		self:SetAngles(cart:GetAngles())
		self:SetPos(cart:GetPos() - cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
		self.Entity:GetPhysicsObject():ApplyForceCenter(cart:GetAngles():Forward() + cart:GetAngles():Forward() * 1200)
		self:GetOwner():SetNWEntity("activeitem","none")
		self.Activated = true
		timer.Simple(1, function()
		constraint.RemoveAll(self.Entity)
		timer.Simple(30,function() if self:IsValid() then self:Remove() end end)
		end)
	end
tblNewItem.WipeOutType = "Explode"
GM.mk_Items["item_koopashell_green"] = tblNewItem

-----------------
GM.mk_Items["item_koopashell_red"] = {
Name = "Red Shell",
Model = "models/gmodcart/items/koopashell.mdl",
Skin = 1,
Material = "gmodcart/items/mk_redshell",
SpawnFunction = function(ply)
	local Itemtype = ply:GetNWString("item")
	local item = ents.Create("ent_projectile")
	local cart = ply:GetNWEntity("Cart")
	item.class = Itemtype
	item:SetPos(cart:GetPos() + cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
	item:SetModel("models/gmodcart/items/koopashell.mdl")
	item:SetOwner(ply)
	item:SetSkin(1)
	item:Spawn()
	item:SetParent(cart)
	item:PhysicsInit(SOLID_VPHYSICS)
	item:GetPhysicsObject():SetMaterial("gmod_ice")
	item:GetOwner():SetNWEntity("activeitem",item)
end,
UseFunction = function(self)
		local cart = self:GetOwner():GetNWEntity("Cart")
		self:SetParent(nil)
		self.Entity:PhysicsInitSphere( 8.1, "metal_bouncy" )
		self.Entity:GetPhysicsObject():Wake()
		constraint.NoCollide(self.Entity,cart,0,0)
		self:SetAngles(cart:GetAngles())
		self.target = self
		self:SetPos(cart:GetPos() - cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
		for k,v in pairs(player.GetAll()) do
			for a,b in pairs(player.GetAll()) do
				if v:GetNWEntity("Cart"):GetPos():Distance(cart:GetPos()) <= b:GetNWEntity("Cart"):GetPos():Distance(cart:GetPos()) && v:GetNWEntity("Cart") != cart  then
					print(v:GetNWEntity("Cart"))
					self.target = v:GetNWEntity("Cart")
				end
			end
		end
		print(self.target)
		self.Activated = true 
		self:SetGravity(0)
		self:GetOwner():SetNWEntity("activeitem","none")
		timer.Simple(1, function()
		constraint.RemoveAll(self.Entity)
		timer.Simple(30,function() if self:IsValid() then self:Remove() end end)
		end)
	end,
WipeOutType = "Explode",
}
-----------------
/*GM.mk_Items["item_koopashell_blue"] = {
Name = "Blue Shell",
Model = "models/gmodcart/items/koopashell.mdl",
Skin = 2,
Material = "gmodcart/items/mk_blueshells",
SpawnFunction = function(ply)
	local Itemtype = ply:GetNWString("item")
	local item = ents.Create("ent_projectile")
	local cart = ply:GetNWEntity("Cart")
	item.class = Itemtype
	item:SetPos(cart:GetPos() + cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
	item:SetModel("models/gmodcart/items/koopashell.mdl")
	item:SetOwner(ply)
	item:Spawn()
	item:SetParent(cart)
	item:PhysicsInit(SOLID_VPHYSICS)
	item:GetPhysicsObject():SetMaterial("gmod_ice")
	item:GetOwner():SetNWEntity("activeitem",item)
end,
UseFunction = function(self)
		local cart = self:GetOwner():GetNWEntity("Cart")
		self:SetParent(nil)
		self.Entity:PhysicsInitSphere( 8.1, "metal_bouncy" )
		self.Entity:GetPhysicsObject():Wake()
		constraint.NoCollide(self.Entity,cart,0,0)
		self:SetAngles(cart:GetAngles())
		self:SetPos(cart:GetPos() - cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
		self.Entity:GetPhysicsObject():ApplyForceCenter(cart:GetAngles():Forward() + cart:GetAngles():Forward() * 1200)
		self:GetOwner():SetNWEntity("activeitem","none")
		self.Activated = true
		timer.Simple(1, function()
		constraint.RemoveAll(self.Entity)
		timer.Simple(30,function() if self:IsValid() then self:Remove() end end)
		end)
	end,
WipeOutType = "Explode",
}*/
-----------------
GM.mk_Items["item_banana"] = {
Name = "Banana",
Model = "models/props/cs_italy/bananna.mdl",
Skin = 1,
Material = "gmodcart/items/mk_banana",
SpawnFunction = function(ply)
	local Itemtype = ply:GetNWString("item")
	local item = ents.Create("ent_projectile")
	local cart = ply:GetNWEntity("Cart")
	item.class = Itemtype
	item:SetPos(cart:GetPos() + cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
	item:SetModel("models/props/cs_italy/bananna.mdl")
	item:SetOwner(ply)
	item:Spawn()
	item:SetParent(cart)
	item:PhysicsInit(SOLID_VPHYSICS)
	item.Activated = true
	item:GetOwner():SetNWEntity("activeitem",item)
end,
UseFunction = function(self)
		local cart = self:GetOwner():GetNWEntity("Cart")
		self:SetParent(nil)
		self.Entity:GetPhysicsObject():Wake()
		self:SetAngles(cart:GetAngles())
		self:SetPos(cart:GetPos() + cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
		self:GetOwner():SetNWEntity("activeitem","none")
	end,
WipeOutType = "Spin",

}
---------------------------
GM.mk_Items["item_star"] = {
Name = "Star Power",
Material = "gmodcart/items/mk_star",
SpawnFunction = function(ply)
	ply.CanSlowDown = false
	ply.Forward = ply.Forward * 1.25
	timer.Simple(2, function() ply.CanSlowDown = true ply.Forward = (ply.Forward - ply.Forward * 0.25)  end)
	ply:GetOwner():SetNWEntity("activeitem","none")
end,
WipeOutType = "Explode",

}
---------------------------
GM.mk_Items["item_mushroom"] = {
Material = "gmodcart/items/mk_mushroom",
SpawnFunction = function(ply)
	ply.CanSlowDown = false
	ply.Forward = ply.Forward * 2
	timer.Simple(2, function() ply.CanSlowDown = true ply.Forward = ply.Forward / 2 end)
	ply:GetOwner():SetNWEntity("activeitem","none")
end,
}
---------------------------