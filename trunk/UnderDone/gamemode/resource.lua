local ClientResources = 0
local function ProcessFolder(strLocation)
	for _, fileName in pairs(file.Find(strLocation .. '*')) do
		if !string.find(strLocation, ".svn") then
			if file.IsDir(strLocation .. fileName) then
				ProcessFolder(strLocation .. fileName .. '/')
			else
				local strOurLocation = string.gsub(strLocation .. fileName, '../gamemodes/UnderDone/content/', '')
				if !string.find(strLocation, '.db') then			
					ClientResources = ClientResources + 1
					resource.AddFile(strOurLocation)
				end
			end
		end
	end
end

if !SinglePlayer() then
	ProcessFolder('../gamemodes/UnderDone/content/materials/')
end