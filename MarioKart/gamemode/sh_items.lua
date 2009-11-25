GM.mk_Items = {}
function GM:CreateBaseProjectile(ply, tblItemTable)
	local intInitSkin = tblItemTable.Skin or 0
	local entCart = ply:GetNWEntity("Cart")
	local entProjectile = ents.Create("ent_projectile")
	entProjectile.class = tblItemTable.Class
	entProjectile:SetPos(entCart:GetPos() + (entCart:GetAngles():Forward() * -30) + (entCart:GetAngles():Up() * 20))
	entProjectile:SetModel(tblItemTable.Model)
	entProjectile:SetSkin(intInitSkin)
	entProjectile:SetParent(entCart)
	entProjectile:SetOwner(ply)
	entProjectile:Spawn()
	entProjectile:GetOwner():SetNWEntity("activeitem", entProjectile)
	return entProjectile
end
function GM:DisingageProjectile(entProjectile)
	local entCart = entProjectile:GetOwner():GetNWEntity("Cart")
	entProjectile:SetParent(nil)
	entProjectile:SetPos(entCart:GetPos() + (entCart:GetAngles():Forward() * -30) + (entCart:GetAngles():Up() * 20))
	entProjectile:SetAngles(entCart:GetAngles())
	entProjectile.Activated = true
	entProjectile:GetOwner():SetNWEntity("activeitem", "none")
	entProjectile:GetPhysicsObject():Wake()
end

--=====Green Shell=====--
local tblNewItem = {}
tblNewItem.Name = "Green Shell"
tblNewItem.Class = "item_koopashell_green"
tblNewItem.Model = "models/gmodcart/items/koopashell.mdl"
tblNewItem.Skin = 0
tblNewItem.Material = "gmodcart/items/mk_greenshell"
tblNewItem.WipeOutType = "Explode"
tblNewItem.SpawnFunction = function(ply)
	GAMEMODE:CreateBaseProjectile(ply, tblNewItem)
end
tblNewItem.UseFunction = function(self)
	local entCart = self:GetOwner():GetNWEntity("Cart")
	GAMEMODE:DisingageProjectile(self)
	self:PhysicsInitSphere(8.1, "metal_bouncy")
	constraint.NoCollide(self, entCart, 0, 0)
	self:GetPhysicsObject():ApplyForceCenter(entCart:GetAngles():Forward() + entCart:GetAngles():Forward() * 1500)
	timer.Simple(1, function() constraint.RemoveAll(self) end)
	timer.Simple(30, function() if self && self:IsValid() then self:Remove() end end)
end
GM.mk_Items["item_koopashell_green"] = tblNewItem

--=====Red Shell=====--
local tblNewItem = {}
tblNewItem.Name = "Red Shell"
tblNewItem.Class = "item_koopashell_red"
tblNewItem.Model = "models/gmodcart/items/koopashell.mdl"
tblNewItem.Skin = 1
tblNewItem.Material = "gmodcart/items/mk_redshell"
tblNewItem.WipeOutType = "Explode"
tblNewItem.SpawnFunction = function(ply)
	GAMEMODE:CreateBaseProjectile(ply, tblNewItem)
end
tblNewItem.UseFunction = function(self)
	GAMEMODE:DisingageProjectile(self)
	self:SetGravity(0) --Polkm: Not sure why this is here?
	self:PhysicsInitSphere(8.1, "metal_bouncy")
	constraint.NoCollide(self, entCart, 0, 0)
	self.target = self
	local intMaxPlayers = table.Count(player.GetAll())
	for _, ply in pairs(player.GetAll()) do
		if ply:GetNWInt("Place") == self:GetOwner():GetNWInt("Place") - 1 then
			self.target = ply:GetNWEntity("Cart")
		elseif self:GetOwner():GetNWInt("Place") - 1 <= 0 && ply:GetNWInt("Place") == intMaxPlayers then
			self.target = ply:GetNWEntity("Cart")
		end
	end 
	timer.Simple(1, function() constraint.RemoveAll(self) end)
	timer.Simple(30, function() if self && self:IsValid() then self:Remove() end end)
end
GM.mk_Items["item_koopashell_red"] = tblNewItem

--=====Blue Shell=====--
local tblNewItem = {}
tblNewItem.Name = "Blue Shell"
tblNewItem.Class = "item_koopashell_blue"
tblNewItem.Model = "models/gmodcart/items/koopashell.mdl"
tblNewItem.Skin = 2
tblNewItem.Material = "gmodcart/items/mk_blueshells"
tblNewItem.WipeOutType = "Explode"
tblNewItem.SpawnFunction = function(ply)
	GAMEMODE:CreateBaseProjectile(ply, tblNewItem)
end
tblNewItem.UseFunction = function(self)
	GAMEMODE:DisingageProjectile(self)
	self:SetGravity(0)
	self:PhysicsInitSphere(8.1, "metal_bouncy")
	constraint.NoCollide(self, entCart, 0, 0)
	self.target = self
	for _, ply in pairs(player.GetAll()) do
		if ply:GetNWInt("place") == 1 then
			self.target = v:GetNWEntity("Cart")
		end
	end
	timer.Simple(1, function() constraint.RemoveAll(self) end)
	timer.Simple(30, function() if self && self:IsValid() then self:Remove() end end)
end
GM.mk_Items["item_koopashell_blue"] = tblNewItem

--=====Banana=====--
local tblNewItem = {}
tblNewItem.Name = "Banana"
tblNewItem.Class = "item_banana"
tblNewItem.Model = "models/props/cs_italy/bananna.mdl"
tblNewItem.Skin = 1
tblNewItem.Material = "gmodcart/items/mk_banana"
tblNewItem.WipeOutType = "Spin"
tblNewItem.EffectTime = 2
tblNewItem.SpawnFunction = function(ply)
	local entBanana = GAMEMODE:CreateBaseProjectile(ply, tblNewItem)
	
end
tblNewItem.UseFunction = function(self)
	GAMEMODE:DisingageProjectile(self)
end
GM.mk_Items["item_banana"] = tblNewItem

--=====Bad Box=====--
local tblNewItem = {}
tblNewItem.Name = "Bad Box"
tblNewItem.Class = "item_badbox"
tblNewItem.WipeOutType = "Spin"
tblNewItem.Model = "models/gmodcart/mk_block.mdl"
tblNewItem.Skin = 1
tblNewItem.Material = "gmodcart/items/mk_redcube"
tblNewItem.SpawnFunction = function(ply)
	local entBox = GAMEMODE:CreateBaseProjectile(ply, tblNewItem)
	entBox:SetColor(255, 255, 255, 175)
end
tblNewItem.UseFunction = function(self)
	GAMEMODE:DisingageProjectile(self)
	self.QuestionMark = ents.Create("player_wheel")
	self.QuestionMark:SetModel("models/gmodcart/mk_question.mdl")
	self.QuestionMark:SetPos(self:GetPos())
	self.QuestionMark:SetColor(255, 0, 0, 255)
	self.QuestionMark:SetAngles(Angle(-180, 0, 0))
	self.QuestionMark:SetParent(self)
	self.QuestionMark:Spawn()
end
GM.mk_Items["item_badbox"] = tblNewItem

--=====Boo=====--
local tblNewItem = {}
tblNewItem.Name = "Boo"
tblNewItem.Class = "item_boo"
tblNewItem.Material = "gmodcart/items/mk_boo"
tblNewItem.EffectTime = 8
tblNewItem.SpawnFunction = function(ply)
	local entCart = ply:GetNWEntity("Cart")
	entCart:SetCartColor(Color(255, 255, 255, 25))
	ply.CanSlowDown = false
	timer.Simple(tblNewItem.EffectTime / 5, function()
		for _, trgplay in pairs(player.GetAll()) do 
			if trgplay != ply && trgplay:GetNWString("item") != "empty" then
				ply:SetNWString("item", trgplay:GetNWString("item"))
				trgplay:SetNWString("item", "empty")
				break
			end
		end
	end)
	timer.Simple(tblNewItem.EffectTime, function() 
		entCart:SetCartColor(Color(255, 255, 255, 255))
		ply.CanSlowDown = true
	end)
end
GM.mk_Items["item_boo"] = tblNewItem

--=====Star Power=====--
local tblNewItem = {}
tblNewItem.Name = "Star Power"
tblNewItem.Class = "item_star"
tblNewItem.Material = "gmodcart/items/mk_star"
tblNewItem.WipeOutType = "Explode"
tblNewItem.EffectTime = 15
tblNewItem.SpawnFunction = function(ply)
	local entCart = ply:GetNWEntity("Cart")
	ply.CanSlowDown = false
	ply.Forward = GAMEMODE.Characters[ply.Character].MaxSpeed * 1.25
	ply.StarPower = true
	ply:ConCommand("mk_Sound Star")
	timer.Create(ply:Nick() .. "StarTimer", 0.25, 60, function()
		entCart:SetCartColor(Color(math.random(0, 255), math.random(0, 255), math.random(0, 255), 255))
	end)
	timer.Simple(15, function()
		timer.Destroy(ply:Nick() .. "StarTimer")
		ply.CanSlowDown = true
		ply.Forward = GAMEMODE.Characters[ply.Character].MaxSpeed
		ply.StarPower = false
		ply:ConCommand("mk_Sound BackGround")
		entCart:SetCartColor(Color(255, 255, 255, 255))
	end)
	ply:SetNWEntity("activeitem", "none")
end
GM.mk_Items["item_star"] = tblNewItem

--=====Mushroom=====--
local tblNewItem = {}
tblNewItem.Name = "Mushroom"
tblNewItem.Class = "item_mushroom"
tblNewItem.Material = "gmodcart/items/mk_mushroom"
tblNewItem.EffectTime = 2
tblNewItem.SpawnFunction = function(ply)
	local intOriginalMaxSpeed = GAMEMODE.Characters[ply.Character].MaxSpeed
	ply.CanSlowDown = false
	ply.Forward = intOriginalMaxSpeed * 2
	timer.Simple(tblNewItem.EffectTime, function()
		ply.CanSlowDown = true
		ply.Forward = intOriginalMaxSpeed
	end)
	ply:SetNWEntity("activeitem", "none")
end
GM.mk_Items["item_mushroom"] = tblNewItem

--=====Lightning=====--
local tblNewItem = {}
tblNewItem.Name = "Lightning"
tblNewItem.Class = "item_lightning"
tblNewItem.Material = "gmodcart/items/mk_lightning"
tblNewItem.EffectTime = 8
tblNewItem.SpawnFunction = function(ply)
	for _, trgplay in pairs(player.GetAll()) do
		if trgplay != ply then
			trgplay.CanUse = false
			trgplay:GetNWEntity("Cart"):Wipeout("Spin")
			trgplay.Forward = GAMEMODE.Characters[ply.Character].MaxSpeed * .25
		end
	end
	timer.Simple(tblNewItem.EffectTime, function() 
		for _, trgplay in pairs(player.GetAll()) do
			if trgplay != ply then
				trgplay.CanUse = true
				trgplay.Forward = GAMEMODE.Characters[trgplay.Character].MaxSpeed 
			end
		end
	end)
	ply:SetNWEntity("activeitem","none")
end
GM.mk_Items["item_lightning"] = tblNewItem
