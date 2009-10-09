include( 'shared.lua' )
include( 'cl_hud.lua' )
include( 'cl_menus.lua' )

require("datastream")
Locker = {}
function RecieveDataFromServer(handler,id,encoded,decoded)
	Locker = decoded.Upg
	print("recieved")
	PrintTable(Locker)
end  
datastream.Hook("LockerTransfer",RecieveDataFromServer)