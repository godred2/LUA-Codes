--Script Fixed by: Aperture-Hosting
-- Web: www.Aperture-Hosting.de
-- Contact: webmaster@aperture-hosting.de
--original Script by: [MK] Servers
 
 
require("mysqloo")
--SQL Server's Host IP
local ULX_HOST = "127.0.0.1"
--SQL Server's Host Port
local ULX_PORT = 3306
--SQL Server's Database Name
local ULX_DATABASE = ""
--SQL Server's Username
local ULX_USERNAME = ""
--SQL Server's Password
local ULX_PASSWORD = ""
 
local ULXDB = mysqloo.connect(ULX_HOST, ULX_USERNAME, ULX_PASSWORD, ULX_DATABASE, ULX_PORT)
ULXDB.onConnected = checkTable
ULXDB.onConnectionFailed = DBError
ULXDB:connect()
 
function ULXDB:onConnected()
        Msg("[ULXSync] Connected to database\n")
        checkTable(ULXDB)
end
 
function ULXDB:onConnectionFailed()
        Msg("[ULXSync] Connected to Failed\n")
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
        print("Connected")
        local Qc  = server:query( "CREATE TABLE IF NOT EXISTS `ulxmysql` (`steam` varchar(20) NOT NULL, `groups` varchar(30) NOT NULL)" )
        Qc.onError = function(Q,Err) print("[ULXSync] Failed to Create Table: " .. Err) end
        Qc:start()
end
 
 
 
function LoadRank(ply)
	print("[ULXSync] Loading Player Rank...")
        local queryQ = ULXDB:query("SELECT * FROM `ulxmysql` WHERE steam = '" .. ply:SteamID() .. "'")
        queryQ.onData = function(Q,D)
                queryQ.onSuccess = function(q)
                    if checkQuery(q) then
						print("[ULXSync] "..ply:GetName().." Status: "..tostring(ply:IsUserGroup(D.groups)))
						if( ply:IsUserGroup(D.groups) )then
							print("[ULXSync] User "..ply:GetName().." is already in his Group!")
						else
							print("[ULXSync] Adding "..ply:GetName().." to Group "..D.groups)
							RunConsoleCommand( 'ulx', 'adduserid', ply:SteamID(),D.groups )
						end
                    end
                end
        end
        queryQ.onError = function(Q,E) print("Q1") print(E) end
        queryQ:start()

end
 
function SaveRank(ply)
	print("[ULXSync] Saving Player Rank...")
        if !(ply:IsUserGroup("user")) then
                local deleteQ = ULXDB:query("DELETE FROM `ulxmysql` WHERE `steam` = '" .. ply:SteamID() .. "'")
                deleteQ.onSuccess = function(q)
                        if checkQuery(q) then
                                print ("[ULXSync] User "..ply:GetName().." is already created")
                        end
                end
                deleteQ:start()
        end
               
        if !(ply:IsUserGroup("user")) then
                local InsertQ = ULXDB:query("INSERT INTO `ulxmysql` (`steam`, `groups`) VALUES ('"..ply:SteamID().."', '"..ply:GetUserGroup().."')")
                InsertQ.onError = DBError
                InsertQ:start()
        end

end
 
function SaveAllRanks()
	print("[ULXSync] Saving Player Ranks...")
        for k,v in pairs(player.GetAll()) do
                if !(v:IsUserGroup("user")) then
                        local deleteQ = ULXDB:query("DELETE FROM `ulxmysql` WHERE `steam` = '" .. v:SteamID() .. "'")
                        deleteQ.onSuccess = function(q)
                                if checkQuery(q) then
                                        print("[ULXSync] Saving Users...")
                                end
                        end
                        deleteQ:start()
                end
                       
                if !(v:IsUserGroup("user")) then
                        local InsertQ = ULXDB:query("INSERT INTO `ulxmysql` (`steam`, `groups`) VALUES ('"..v:SteamID().."', '"..v:GetUserGroup().."')")
                        InsertQ.onError = DBError
                        InsertQ:start()
                end
        end

end
 
hook.Add("PlayerInitialSpawn", "PlaceUserToTheirGroup", LoadRank)
hook.Add("PlayerDisconnected", "AddUserToTheirGroup", SaveRank)
hook.Add("ShutDown", "AddAUserToTheirGroup", SaveAllRanks)