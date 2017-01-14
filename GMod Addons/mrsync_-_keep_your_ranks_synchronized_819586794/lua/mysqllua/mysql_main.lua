--Script Fixed by: Aperture-Hosting
-- Web: www.Aperture-Hosting.de
-- Contact: webmaster@aperture-hosting.de
--original Script by: [MK] Servers

if(file.Exists( "bin/gmsv_mysqloo_linux.dll", "LUA" ) or file.Exists( "bin/gmsv_mysqloo_win32.dll", "LUA" ))then
	local ulxsql = {}
	local ULXDB = {}
	local function connect()
		if(table.Count(ulxsql) < 6) then return end
		
		require("mysqloo")
		ULXDB = mysqloo.connect(ulxsql.ULX_HOST, ulxsql.ULX_USERNAME, ulxsql.ULX_PASSWORD, ulxsql.ULX_DATABASE, tonumber(ulxsql.ULX_PORT))
		ULXDB.onConnected = checkTable
		ULXDB.onConnectionFailed = DBError
		ULXDB:connect()
		
		ulxsql.IgnoreRankTable = {
			"owner",
			"superadmin",
			"admin"
		}		
	end
		
	cvars.AddChangeCallback( "ulxsync_host", function( convar_name, value_old, value_new )
		ulxsql.ULX_HOST = value_new
		connect()
	end )
	cvars.AddChangeCallback( "ulxsync_port", function( convar_name, value_old, value_new )
		ulxsql.ULX_PORT = value_new
		connect()
	end )
	cvars.AddChangeCallback( "ulxsync_database", function( convar_name, value_old, value_new )
		ulxsql.ULX_DATABASE = value_new
		connect()
	end )
	cvars.AddChangeCallback( "ulxsync_username", function( convar_name, value_old, value_new )
		ulxsql.ULX_USERNAME = value_new
		connect()
	end )
	cvars.AddChangeCallback( "ulxsync_password", function( convar_name, value_old, value_new )
		ulxsql.ULX_PASSWORD = value_new
		connect()
	end )
	cvars.AddChangeCallback( "ulxsync_servergroup", function( convar_name, value_old, value_new )
		ulxsql.ULX_SERVERGROUP = value_new
		connect()
	end )	
	 
	function DBError()
			Msg("[MRSync] Connected to Failed\n")
	end
	
	function checkQuery(query)
		local playerInfo = query:getData()
		if playerInfo[1] ~= nil then
					return true
		else
					return false
		end
	end
	 
	local num_rows = 0
	function checkTable(server)
			print("[MRSync] Connected to database\n")
			local Qc  = server:query( "CREATE TABLE IF NOT EXISTS `ulxmysql` (`steam` varchar(20) NOT NULL, `groups` varchar(30) NOT NULL, `servergroup` varchar(30) NOT NULL)" )
			Qc.onError = function(Q,Err) print("[MRSync] Failed to Create Table: " .. Err) end
			Qc:start()
	end
	 
	 
	 
	function LoadRank(ply)
		print("[MRSync] Loading Player Rank...")
			local queryQ = ULXDB:query("SELECT * FROM `ulxmysql` WHERE steam = '" .. ply:SteamID() .. "'")
			queryQ.onData = function(Q,D)
					queryQ.onSuccess = function(q)
						if checkQuery(q) then
							print("[MRSync] "..ply:GetName().." Status: "..tostring(ply:IsUserGroup(D.groups)))
							if( ply:IsUserGroup(D.groups) or not(D.servergroup==ulxsql.ULX_SERVERGROUP or D.servergroup=="allserver"))then
								print("[MRSync] User "..ply:GetName().." is already in his Group!")
							elseif(D.groups=="user")then
								RunConsoleCommand( 'ulx', 'removeuserid', ply:SteamID() )
								print("[MRSync] Adding "..ply:GetName().." to Group "..D.groups)
							else
								print("[MRSync] Adding "..ply:GetName().." to Group "..D.groups)
								RunConsoleCommand( 'ulx', 'adduserid', ply:SteamID(),D.groups )
							end
						end
					end
			end
			queryQ.onError = function(Q,E) print("Q1") print(E) end
			queryQ:start()

	end
	 
	function SaveRank(ply)
		print("[MRSync] Saving Player Rank...")

			local deleteQ = ULXDB:query("DELETE FROM `ulxmysql` WHERE `steam` = '" .. ply:SteamID() .. "'")
			deleteQ.onSuccess = function(q)
					if checkQuery(q) then
							print ("[MRSync] User "..ply:GetName().." is already created")
					end
			end
			deleteQ:start()

				   
			if !(table.HasValue(ulxsql.IgnoreRankTable,ply:GetUserGroup())) then
					local InsertQ = ULXDB:query("INSERT INTO `ulxmysql` (`steam`, `groups`, `servergroup`) VALUES ('"..ply:SteamID().."', '"..ply:GetUserGroup().."','"..ulxsql.ULX_SERVERGROUP.."')")
					InsertQ.onError = DBError
					InsertQ:start()
					print ("[MRSync] User "..ply:GetName().." got Saved")
			elseif(table.HasValue(ulxsql.IgnoreRankTable,ply:GetUserGroup()))then
					local InsertQ = ULXDB:query("INSERT INTO `ulxmysql` (`steam`, `groups`, `servergroup`) VALUES ('"..ply:SteamID().."', '"..ply:GetUserGroup().."','allserver')")
					InsertQ.onError = DBError
					InsertQ:start()
					print ("[MRSync] User "..ply:GetName().." SID: "..ply:SteamID().." got Saved [A]")
			end

	end
	 
	function SaveAllRanks()
		print("[MRSync] Saving Player Ranks...")
			for k,v in pairs(player.GetAll()) do

					local deleteQ = ULXDB:query("DELETE FROM `ulxmysql` WHERE `steam` = '" .. v:SteamID() .. "'")
					deleteQ.onSuccess = function(q)
							if checkQuery(q) then
									print("[MRSync] Saving Users...")
							end
					end
					deleteQ:start()

						   
					if !(table.HasValue(ulxsql.IgnoreRankTable,v:GetUserGroup())) then
							local InsertQ = ULXDB:query("INSERT INTO `ulxmysql` (`steam`, `groups`, `servergroup`) VALUES ('"..v:SteamID().."', '"..v:GetUserGroup().."','"..ulxsql.ULX_SERVERGROUP.."')")
							InsertQ.onError = DBError
							InsertQ:start()
					elseif(table.HasValue(ulxsql.IgnoreRankTable,v:GetUserGroup()))then
							local InsertQ = ULXDB:query("INSERT INTO `ulxmysql` (`steam`, `groups`, `servergroup`) VALUES ('"..v:SteamID().."', '"..v:GetUserGroup().."','allserver')")
							InsertQ.onError = DBError
							InsertQ:start()
					end
			end

	end
	 
	hook.Add("PlayerInitialSpawn", "PlaceUserToTheirGroup", LoadRank)
	hook.Add("PlayerDisconnected", "AddUserToTheirGroup", SaveRank)
	hook.Add("ShutDown", "AddAUserToTheirGroup", SaveAllRanks)
		
else
	print('[MRSync] WARNING! You need MySQloo for this Script to Run!')
	print('[MRSync] Get it from Here: http://facepunch.hatt.co/showthread.php?t=1357773')
	print('[MRSync] Here is an Install Instruction:')
	print('[MRSync] https://help.serenityservers.net/index.php?title=Garrysmod:How_to_install_mysqloo_or_tmysql')
end

		

		 

		 
		 

