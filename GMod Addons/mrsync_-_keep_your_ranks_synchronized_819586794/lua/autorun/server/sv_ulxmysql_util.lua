CreateConVar( "ulxsync_host", "", {FCVAR_PROTECTED}, "Set the ULX Rank MySQL Server's IP" )
CreateConVar( "ulxsync_port", 0, {FCVAR_PROTECTED}, "Set the ULX Rank MySQL Servers Port" )
CreateConVar( "ulxsync_database", "", {FCVAR_PROTECTED}, "Set the ULX Rank MySQL Servers Database Name" )
CreateConVar( "ulxsync_username", "", {FCVAR_PROTECTED}, "Set the ULX Rank MySQL Servers Username to Log In" )
CreateConVar( "ulxsync_password", "", {FCVAR_PROTECTED}, "Set the ULX Rank MySQL Servers Password to Log In" )
CreateConVar( "ulxsync_servergroup", "", {FCVAR_PROTECTED}, "Set the ULX Rank Servergroup" )

include( "mysqllua/mysql_main.lua" )