GM.Name 		= "Shell Shocked game"
GM.Author 		= "Shell Shocked"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= true

Weapons = {}
Weapons["weapon_pistol"] = {
	Weapon = "weapon_pistol",
	CanSilence = false,
	ChangableFireRate = false,
	CanGrenade = false,
	UpGrades = {
		Power = {{Price = 600, Level = 17},
				{Price = 1500, Level = 20},
				{Price = 2500, Level = 23},
				{Price = 4000, Level = 25},}
		Accuracy = {{Price = 600, Level = 0.08},
				{Price = 1500, Level = 0.07},
				{Price = 3000, Level = 0.06},
				{Price = 4000, Level = 0.05},}
		ClipSize = {{Price = 800, Level = 15},
				{Price = 1300, Level = 25},
				{Price = 2000, Level = 35},
				{Price = 2600, Level = 50},}
		FiringSpeed = {{Price = 1000, Level = 0.2},
				{Price = 1400, Level = 0.15},
				{Price = 2200, Level = 0.1},
				{Price = 3100, Level = 0.08},}
		ReloadSpeed = {{Price = 400, Level = 1.2},}
	}
}