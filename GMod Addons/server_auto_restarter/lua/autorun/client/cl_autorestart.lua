local AutoRestart = AutoRestart or {}
AutoRestart.VGUI = AutoRestart.VGUI or {}

net.Receive("AutoRestartChatPrint", function( len, ply )
	chat.AddText(Color(255,255,255),"[",Color(255,236,56),"Server",Color(255,255,255),"]: "..net.ReadString())
end)

net.Receive("AutoRestartOpenMenu", function( len, ply )
	AutoRestart.DrawMenu()
end)

function AutoRestart.ARCommand(text)
	net.Start("AutoRestartCommand")
		net.WriteString(text)
	net.SendToServer()
end

--VGUI

function AutoRestart.DrawMenu()
	AutoRestart.VGUI.Main = vgui.Create( "DFrame" )
	AutoRestart.VGUI.Main:SetSize( 300, 250 )
	AutoRestart.VGUI.Main:Center()
	AutoRestart.VGUI.Main:MakePopup()

	AutoRestart.VGUI.Restart = vgui.Create( "DButton", AutoRestart.VGUI.Main )
	AutoRestart.VGUI.Restart:SetText( "Restart" )	
	AutoRestart.VGUI.Restart:SetPos( 25, 50 )		
	AutoRestart.VGUI.Restart:SetSize( 250, 30 )	
	AutoRestart.VGUI.Restart.DoClick = function()	
		AutoRestart.ARCommand("restart")	
	end

	AutoRestart.VGUI.EAutoRestart = vgui.Create( "DButton", AutoRestart.VGUI.Main )
	AutoRestart.VGUI.EAutoRestart:SetText( "Enable Auto Restart" )	
	AutoRestart.VGUI.EAutoRestart:SetPos( 25, 90 )		
	AutoRestart.VGUI.EAutoRestart:SetSize( 250, 30 )	
	AutoRestart.VGUI.EAutoRestart.DoClick = function()	
		AutoRestart.ARCommand("autorestart")	
	end

	AutoRestart.VGUI.DAutoRestart = vgui.Create( "DButton", AutoRestart.VGUI.Main )
	AutoRestart.VGUI.DAutoRestart:SetText( "Disable Auto Restart" )	
	AutoRestart.VGUI.DAutoRestart:SetPos( 25, 130 )		
	AutoRestart.VGUI.DAutoRestart:SetSize( 250, 30 )	
	AutoRestart.VGUI.DAutoRestart.DoClick = function()	
		AutoRestart.ARCommand("abort")	
	end
end