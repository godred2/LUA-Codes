AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
util.AddNetworkString( "whoIsDriver" )
util.AddNetworkString( "driverIs" )
	
net.Receive("whoIsDriver", function( len, ply )
	
	local car = net.ReadEntity()

	if(car:IsVehicle())then
		net.Start("driverIs")
			net.WriteEntity(car:GetDriver())
		net.Send(ply)
	end

end)

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

function SWEP:Initialize()
	
end

function SWEP:Equip( newOwner )

end

function SWEP:PrimaryAttack()
	--print("Scheint zu Funktionieren :D")
	self:SetNextPrimaryFire( CurTime() + 0.5)
end

function SWEP:SecondaryAttack()
	--print("Scheint zu Funktionieren :D")
end

function SWEP:Think()
	if(Self)then
	
	end
end