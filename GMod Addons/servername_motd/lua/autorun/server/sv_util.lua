include("../../servernamemotd/sv_config.lua")
--##############################
--###MADE BY APERTURE-HOSTING###
--###www.Aperture-Hosting.de####
--##############################

local i = 0
--Changing Function .. Pls Do Not Change unless you know what you do
function ChangeName(num,method,SNtable,prefix)
	local SNM = {}
	SNM.table = SNtable
	SNM.Prefix = prefix
	timer.Simple(num, function()
		print("[ServerNameMotd] Changing Server name!")
		local TBLLenght = table.Count( SNtable )
		if(method=="random")then
			local randomNumber = math.random(1,TBLLenght)
			RunConsoleCommand( "hostname", (SNM.Prefix.."["..SNM.table[randomNumber].."]") )
		elseif(method=="arimethic")then
			RunConsoleCommand( "hostname", (SNM.Prefix.."["..SNM.table[randomNumber].."]") )
			if(i<TBLLenght)then
				i = i+1
			else
				i = 0
			end
		end
	ChangeName(num,method,SNtable,prefix)
	end)
end
if(IsFirstTimePredicted())then
	ChangeName(ServerNameMOTD.Interval, ServerNameMOTD.Method, ServerNameMOTD.Motd, ServerNameMOTD.Prefix)
	print("[ServerNameMotd] Running Namechanger")
end