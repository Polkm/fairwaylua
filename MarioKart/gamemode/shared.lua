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

GM.PositionItemTables = {}
GM.PositionItemTables[1] = {
				"item_mushroom",
				"item_koopashell_green",
				"item_koopashell_green",
				"item_banana",
				"item_banana",
				"item_banana",
				}
GM.PositionItemTables[2] = {
				"item_mushroom",
				"item_koopashell_red",
				"item_koopashell_green",
				"item_koopashell_green",
				"item_koopashell_green",
				"item_banana",
				"item_banana",
				"item_banana",
				}
GM.PositionItemTables[3] = {
				"item_mushroom",
				"item_mushroom",
				"item_boo",
				"item_koopashell_red",
				"item_koopashell_red",
				"item_koopashell_green",
				"item_koopashell_green",
				"item_koopashell_green",
				"item_koopashell_green",
				"item_banana",
				"item_banana",
				"item_banana",
				}
GM.PositionItemTables[4] = {
				"item_mushroom",
				"item_mushroom",
				"item_mushroom",
				"item_star",
				"item_koopashell_red",
				"item_koopashell_red",
				"item_koopashell_red",
				"item_koopashell_green",
				"item_koopashell_green",
				"item_koopashell_green",
				"item_banana",
				"item_banana",
				"item_banana",
				"item_boo",
				}
GM.PositionItemTables[5] = {
				"item_mushroom",
				"item_boo",
				"item_boo",
				"item_star",
				"item_koopashell_red",
				"item_koopashell_red",
				"item_koopashell_green",
				"item_koopashell_green",
				"item_banana",
				}				
GM.PositionItemTables[6] = {
				"item_mushroom",
				"item_star",
				"item_koopashell_red",
				"item_koopashell_red",
				"item_koopashell_red",
				"item_koopashell_green",
				"item_koopashell_green",
				"item_lightning",
				"item_boo",
				"item_boo",
				}
GM.PositionItemTables[7] = {
				"item_mushroom",
				"item_mushroom",
				"item_mushroom",
				"item_star",
				"item_star",
				"item_koopashell_red",
				"item_koopashell_red",
				"item_koopashell_red",
				"item_koopashell_green",
				"item_koopashell_blue",
				"item_lightning",
				"item_lightning",
				"item_boo",
				}				
GM.PositionItemTables[8] = {
				"item_mushroom",
				"item_mushroom",
				"item_mushroom",
				"item_star",
				"item_star",
				"item_star",
				"item_koopashell_red",
				"item_koopashell_red",
				"item_koopashell_blue",
				"item_lightning",
				"item_lightning",
				"item_lightning",
				}				
GM.PositionItemTables[9] = {
				"item_mushroom",
				"item_star",
				"item_koopashell_red",
				"item_koopashell_green",
				"item_banana",
				"item_lightning",
				"item_koopashell_blue",
				}		
				
GM.Characters = {}
GM.Characters["Donkey-Kong"] = {
	Name = "Donkey-Kong",
	Model = "models/donkeykong/dk.mdl",
	MaxSpeed = 245,
	MaxTurn = 105,
	Weight = 100,
}
GM.Characters["Mario"] = {
	Name = "Mario",
	Model = "models/marioragdoll/Super Mario Galaxy/mario/mario.mdl",
	MaxSpeed = 250,
	MaxTurn = 100,
	Weight = 100,
}
GM.Characters["Luigi"] = {
	Name = "Luigi",
	Model = "models/marioragdoll/Super Mario Galaxy/luigi/luigi.mdl",
	MaxSpeed = 250,
	MaxTurn = 100,
	Weight = 100,
}
GM.Characters["Yoshi"] = {
	Name = "Yoshi",
	Model = "models/marioragdoll/yos00/yoshi.mdl",
	MaxSpeed = 255,
	MaxTurn = 95,
	Weight = 100,
}
GM.Characters["Wario"] = {
	Name = "Wario",
	Model = "models/marioragdoll/wario/wario.mdl",
	MaxSpeed = 245,
	MaxTurn = 105,
	Weight = 100,
}
GM.Characters["Waluigi"] = {
	Name = "Waluigi",
	Model = "models/marioragdoll/waluigi/waluig.mdl",
	MaxSpeed = 255,
	MaxTurn = 95,
	Weight = 120,
}


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
		self:SetPos(cart:GetPos() + cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
		self.Entity:GetPhysicsObject():ApplyForceCenter(cart:GetAngles():Forward() + cart:GetAngles():Forward() * 1500)
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
	item:SetSkin(GAMEMODE.mk_Items[item.class].Skin)
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
		self:SetPos(cart:GetPos() + cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
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
GM.mk_Items["item_koopashell_blue"] = {
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
	item:SetSkin(GAMEMODE.mk_Items[item.class].Skin)
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
				if v:GetNWInt("place") == 1 then
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
GM.mk_Items["item_badbox"] = {
Name = "Bad Box",
Model = "models/gmodcart/mk_block.mdl",
Skin = 1,
Material = "gmodcart/items/mk_redcube",
SpawnFunction = function(ply)
	local Itemtype = ply:GetNWString("item")
	local item = ents.Create("ent_projectile")
	local cart = ply:GetNWEntity("Cart")
	item.class = Itemtype
	item:SetPos(cart:GetPos() + cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
	item:SetOwner(ply)
	item:SetColor(255,255,255,175)
	item:SetModel("models/gmodcart/mk_block.mdl")
	item:Spawn()
	item:SetParent(cart)
	item:PhysicsInit(SOLID_VPHYSICS)
	item:GetOwner():SetNWEntity("activeitem",item)
end,
UseFunction = function(self)
		local cart = self:GetOwner():GetNWEntity("Cart")
		self.QuestionMark = ents.Create("player_wheel")
		self.QuestionMark:SetModel("models/gmodcart/mk_question.mdl")
		self.QuestionMark:SetPos(self:GetPos())
		self.QuestionMark:SetColor(255,0,0,255)
		self.QuestionMark:SetAngles(Angle(-180,0,0))
		self.QuestionMark:SetParent(self)
		self.QuestionMark:Spawn()
		self:SetParent(nil)
		self.Entity:GetPhysicsObject():Wake()
		self:SetAngles(cart:GetAngles())
		self:SetPos(cart:GetPos() + cart:GetAngles():Forward() * -30 + cart:GetAngles():Up() * 20)
		self:GetOwner():SetNWEntity("activeitem","none")
		self.Activated = true
	end,
WipeOutType = "Spin",
}
---------------------------
GM.mk_Items["item_boo"] = {
Name = "Boo",
Skin = 1,
Material = "gmodcart/items/mk_boo",
SpawnFunction = function(ply)
	local cart = ply:GetNWEntity("Cart")
	cart.BodyFrame:SetColor(255,255,255,25)
	cart.Ragdoll:SetColor(255,255,255,25)
	cart.BackWheel1:SetColor(255,255,255,25)
	cart.BackWheel2:SetColor(255,255,255,25)
	cart.frontWheel1:SetColor(255,255,255,25)
	cart.frontWheel2:SetColor(255,255,255,25)
	cart.SteerWheel1:SetColor(255,255,255,25)
	ply.CanSlowDown = false
	timer.Simple(1, function()
	for k,v in pairs(player.GetAll()) do 
		if v != ply && v:GetNWString("item") != "empty" then
			ply:SetNWString("item", v:GetNWString("item"))
			v:SetNWString("item","empty")
			break
		end
	end
	end)
	timer.Simple(8, function() 
	cart.BodyFrame:SetColor(255,255,255,255) 
	cart.Ragdoll:SetColor(255,255,255,255)
	cart.BackWheel1:SetColor(255,255,255,255)
	cart.BackWheel2:SetColor(255,255,255,255)
	cart.frontWheel1:SetColor(255,255,255,255)
	cart.frontWheel2:SetColor(255,255,255,255)
	cart.SteerWheel1:SetColor(255,255,255,255)
	ply.CanSlowDown = true
	end)
end,
WipeOutType = "None",
}
---------------------------
GM.mk_Items["item_star"] = {
Name = "Star Power",
Material = "gmodcart/items/mk_star",
SpawnFunction = function(ply)
	ply.CanSlowDown = false
	ply.Forward = GAMEMODE.Characters[ply.Character].MaxSpeed * 1.25
	ply.StarPower = true
	ply:ConCommand("mk_Sound Star")
	timer.Create(ply:Nick().."StarTimer",0.25, 60,function()
		ply:GetNWEntity("Cart").BodyFrame:SetColor(math.random(0,255),math.random(0,255),math.random(0,255),255)
		ply:GetNWEntity("Cart").Ragdoll:SetColor(math.random(0,255),math.random(0,255),math.random(0,255),255)
	end)
	timer.Simple(15, function()
		timer.Destroy(ply:Nick().."StarTimer")
		ply:GetNWEntity("Cart").BodyFrame:SetColor(255,255,255,255)
		ply:GetNWEntity("Cart").Ragdoll:SetColor(255,255,255,255)
		ply.StarPower = false
		ply.CanSlowDown = true
		ply.Forward = GAMEMODE.Characters[ply.Character].MaxSpeed
		ply:ConCommand("mk_Sound BackGround")
	end)
	ply:GetOwner():SetNWEntity("activeitem","none")
end,
WipeOutType = "Explode",

}
---------------------------
GM.mk_Items["item_mushroom"] = {
Material = "gmodcart/items/mk_mushroom",
SpawnFunction = function(ply)
	ply.CanSlowDown = false
	ply.Forward = GAMEMODE.Characters[ply.Character].MaxSpeed * 2
	timer.Simple(2, function() ply.CanSlowDown = true ply.Forward = GAMEMODE.Characters[ply.Character].MaxSpeed end)
	ply:GetOwner():SetNWEntity("activeitem","none")
end,
}
---------------------------
GM.mk_Items["item_lightning"] = {
Material = "gmodcart/items/mk_lightning",
SpawnFunction = function(ply)
	for k,v in pairs(player.GetAll()) do
		if v != ply then
			v.CanUse = false
			v:GetNWEntity("Cart"):Wipeout("Spin")
			v.Forward = GAMEMODE.Characters[ply.Character].MaxSpeed * .25
		end
	end
	timer.Simple(10, function() 
	for k,v in pairs(player.GetAll()) do
		if v != ply then
			v.CanUse = true
			v.Forward = GAMEMODE.Characters[v.Character].MaxSpeed 
		end
	end
	end)
	ply:GetOwner():SetNWEntity("activeitem","none")
end,
}
---------------------------
