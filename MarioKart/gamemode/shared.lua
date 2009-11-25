GM.Name 		= "Shell Shocked game"
GM.Author 		= "Shell Shocked"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= true
GM.WinLaps = 3
GM.PrepTime = 15
GM.CatchUpTime = 30

GM.PlaceTranslation = {}
GM.PlaceTranslation[1] = "1st"
GM.PlaceTranslation[2] = "2nd"
GM.PlaceTranslation[3] = "3rd"
GM.PlaceTranslation[4] = "4th"
GM.PlaceTranslation[5] = "5th"
GM.PlaceTranslation[6] = "6th"
GM.PlaceTranslation[7] = "7th"
GM.PlaceTranslation[8] = "8th"
GM.PlaceTranslation[9] = "9th"
GM.PlaceTranslation[10] = "10th"
function GM:TranslatePlace(intPlace)
	return GAMEMODE.PlaceTranslation[intPlace] or intPlace
end

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
				"item_badbox",
				"item_banana",
				"item_banana",
				}
GM.PositionItemTables[2] = {
				"item_mushroom",
				"item_badbox",
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
				"item_badbox",
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
				"item_badbox",
				"item_badbox",
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
				"item_badbox",
				"item_badbox",
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
				"item_badbox",
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
				"item_badbox",
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