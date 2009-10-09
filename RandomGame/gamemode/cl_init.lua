include( 'shared.lua' )
include( 'cl_hud.lua' )
include( 'cl_menus.lua' )

require("datastream")

function RecieveDataFromServer(handler,id,encoded,decoded)
	Locker = decoded.Upg
end  
datastream.Hook("LockerTransfer",RecieveDataFromServer)