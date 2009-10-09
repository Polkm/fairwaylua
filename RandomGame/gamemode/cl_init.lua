include( 'shared.lua' )
include( 'cl_hud.lua' )
include( 'cl_menus.lua' )

require("datastream")

function RecieveDataFromServer(handler,id,encoded,decoded)
	Inventory = decoded.Inv 
	Upgrade = decoded.Upg
	Chest = decoded.Chest
	specialupgrades = decoded.SUpgs
	if InvOpen then
		ReLoadInvList()
		CanClose = true
			if IsUpging then
				UpgUpdate()
			end
			if IsChesting then
				ReloadChest()
			end
	end
end  
datastream.Hook("InvTransfer",RecieveDataFromServer)