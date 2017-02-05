--#############################################
--##This Script was made by Aperture Hosting!##
--##It is only for Instant-Roleplay############
--#############################################

local AutoRestart = AutoRestart or {}

--#########
--Functions
--#########
function AutoRestart.PrintToAll(text)
	net.Start("AutoRestartChatPrint")
		net.WriteString(text)
	net.Broadcast()
end

function AutoRestart.Print(ply,text)
	net.Start("AutoRestartChatPrint")
		net.WriteString(text)
	net.Send(ply)
end
function AutoRestart.OpenMenu(ply)
	net.Start("AutoRestartOpenMenu")
	net.Send(ply)
end

function AutoRestart.CheckTime()

	AutoRestart.Time = os.date( "%H:%M", os.time() )
	
	if(AutoRestart.Time=="02:00")then
	
		AutoRestart.PrintToAll("Server Restart in 1 Hour")
		
	elseif(AutoRestart.Time=="02:30")then
	
		AutoRestart.PrintToAll("Server Restart in 30 Minutes")
		
	elseif(AutoRestart.Time=="02:45")then
	
		AutoRestart.PrintToAll("Server Restart in 15 Minutes")
		
	elseif(AutoRestart.Time=="02:50")then
	
		AutoRestart.PrintToAll("Server Restart in 10 Minutes")
		
	elseif(AutoRestart.Time=="02:55")then
	
		AutoRestart.PrintToAll("Server Restart in 5 Minutes")
		
	elseif(AutoRestart.Time=="02:56")then
	
		AutoRestart.PrintToAll("Server Restart in 4 Minutes")
		
	elseif(AutoRestart.Time=="02:57")then
	
		AutoRestart.PrintToAll("Server Restart in 3 Minutes")
		
	elseif(AutoRestart.Time=="02:58")then
	
		AutoRestart.PrintToAll("Server Restart in 2 Minutes")
		
	elseif(AutoRestart.Time=="02:59")then
	
		AutoRestart.PrintToAll("Server Restart in 1 Minutes")
		
	elseif(AutoRestart.Time=="03:00")then
	
		AutoRestart.PrintToAll("Server restart Now!")
		for k, v in pairs( player.GetAll() ) do
			v:Kick( "Server Restart! \nTry connecting in 5 Minutes! \nIf the server isn't online then \nplease contact an Admin!" )
		end
		timer.Simple(5,function() 
			RunConsoleCommand( "_restart" )
		end)
		
	end
end	

--################
--Console Commands
--################

concommand.Add( "autorestart_abort", function( ply, cmd, args ) if(AutoRestart.bool==true)then timer.Remove("AutoRestartTimer") AutoRestart.bool = false print("[Server] AutoRestarter Stopped")else print("[Server] AutoRestarter is already Stopped") end end )
concommand.Add( "autorestart_restart", function( ply, cmd, args ) if(AutoRestart.bool==false)then timer.Create( "AutoRestartTimer", 60, 0, function() AutoRestart.CheckTime() end) AutoRestart.bool = true print("[Server] AutoRestarter Restarted") else print("[Server] AutoRestarter is already Running") end end )
--#####
--Timer
--#####
timer.Create( "AutoRestartTimer", 60, 0, function() AutoRestart.CheckTime() AutoRestart.bool=true end)
print("[Server] AutoRestarter Running")

--########################
--ULib Permission Register
--########################

ULib.ucl.registerAccess("rs abort","superadmin","Permission to the '!rs abort' command","Command")
ULib.ucl.registerAccess("rs autorestart","superadmin","Permission to the '!rs autorestart' command","Command")
ULib.ucl.registerAccess("rs restart","superadmin","Permission to the '!restart' command","Command")
ULib.ucl.registerAccess("rs menu","superadmin","Permission to the '!restart' command","Command")
util.AddNetworkString("AutoRestartChatPrint")
util.AddNetworkString("AutoRestartOpenMenu")
util.AddNetworkString("AutoRestartCommand")

--#############
--Chat Commands
--#############
hook.Add( "PlayerSay", "AutoRestartChat", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	
	if ( string.sub( text, 1, 4 ) == "!rs " ) then
		ULib.ucl.query(	ply,access,hide	)
		if(string.sub( text, 5 )=="abort")then
		
			if(ULib.ucl.query(ply,"rs abort"))then
				timer.Remove("AutoRestartTimer")
				AutoRestart.PrintToAll("Auto restart disabled!")
				return ""
			else
				AutoRestart.Print(ply,"You have no access to that Command!")
				return text
			end
			
		elseif(string.sub( text, 5 )=="autorestart")then
		
			if(ULib.ucl.query(ply,"rs autorestart"))then
				timer.Create( "AutoRestartTimer", 60, 0, function() AutoRestart.CheckTime() end)
				AutoRestart.PrintToAll("Auto restart re-enabled!")
				return ""
			else
				AutoRestart.Print(ply,"You have no access to that Command!")
				return text
			end
		elseif(string.sub( text, 5 )=="menu")then
			if(ULib.ucl.query(ply,"rs menu"))then
				AutoRestart.OpenMenu(ply)
			else
				AutoRestart.Print(ply,"You have no access to that Command!")
				return text
			end	
		end
		
	elseif(text == "!restart")then
		if(ULib.ucl.query(ply,"rs restart"))then
			AutoRestart.PrintToAll("Server Restart Now!")
			for k, v in pairs( player.GetAll() ) do
				v:Kick( "Server Restart! \nTry connecting in 5 Minutes! \nIf the server isn't online then \nplease contact an Admin!" )
			end
			timer.Simple(5,function() 
				RunConsoleCommand( "_restart" )
			end)
		else
			AutoRestart.Print(ply,"You have no access to that Command!")
			return text
		end
	end
end )

net.Receive("AutoRestartCommand", function( len, ply )
	local CMD = net.ReadString()
	if(CMD=="autorestart")then
		if(ULib.ucl.query(ply,"rs autorestart"))then
			timer.Create( "AutoRestartTimer", 60, 0, function() AutoRestart.CheckTime() end)
			AutoRestart.PrintToAll("Auto restart re-enabled!")
		else
			ply:Kick("[AutoRestart] Kicked cause Exploiting")
		end
	elseif(CMD=="abort")then
		if(ULib.ucl.query(ply,"rs abort"))then
			timer.Remove("AutoRestartTimer")
			AutoRestart.PrintToAll("Auto restart disabled!")
		else
			ply:Kick("[AutoRestart] Kicked cause Exploiting")
		end
	elseif(CMD=="restart")then
		if(ULib.ucl.query(ply,"rs restart"))then
			AutoRestart.PrintToAll("Server restart now!")
			for k, v in pairs( player.GetAll() ) do
				v:Kick( "Server Restart! \nTry connecting in 5 Minutes! \nIf the server isn't online then \nplease contact an Admin!" )
			end
			timer.Simple(5,function() 
				RunConsoleCommand( "_restart" )
			end)
		else
			ply:Kick("[AutoRestart] Kicked cause Exploiting")
		end
	end
end)
