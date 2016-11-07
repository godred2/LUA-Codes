include('shared.lua')
local searchWanted = 0

net.Receive("driverIs", function( len, ply )
	
	local driver = net.ReadEntity()

	if(searchWanted==1)then
		RunConsoleCommand("say","/wanted "..driver:Name().." [Radar] You were to Fast!")
		searchWanted=0
	end
end)

SWEP.PrintName = "Radar Pistol"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

local speed
local maxSpeed
local speedColor
local color_text
local hud_color
local I = 0

function SWEP:Setup(ply)

end

function SWEP:Initialize()
	self:Setup(self:GetOwner())
	surface.CreateFont( "RadarSpeed", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 80,
		weight = 500,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
		surface.CreateFont( "RadarMaxSpeed", {
		font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 15,
		weight = 100,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
	speed = 0
	maxSpeed = 0
	speedColor = Color( 200, 0, 0, 255 )
	hud_color = Color(0, 0, 0, 150)
	color_text = Color( 200, 200, 200, 255 )
end

function SWEP:Deploy(ply)
	self:Setup(self:GetOwner())
end

function SWEP:ViewModelDrawn()
	
end

function SWEP:DrawWorldModel()
	self.Weapon:DrawModel()
end

function SWEP:Deploy()
	speed = 0
	maxSpeed = 0
	speedColor = Color( 200, 0, 0, 255 )
end

function SWEP:PrimaryAttack()
	if(IsFirstTimePredicted())then

		self:SetNextPrimaryFire( CurTime() + 0.5)
		
		timer.Simple(2 , function()
			local ply = LocalPlayer()
			local ent = ply:GetEyeTrace().Entity
			if(!ent:IsVehicle())then
				ply:PrintMessage( HUD_PRINTTALK, "Target is not a Vehicle" )
			else
				if(ent:GetClass()=="prop_vehicle_prisoner_pod")then
					ply:PrintMessage( HUD_PRINTTALK, "Target is not a Car" )
				else
					if(ent:VC_GetSpeedKmH()<0)then
						speed = math.Round(ent:VC_GetSpeedKmH())*(-1)
					else
						speed = math.Round(ent:VC_GetSpeedKmH())
					end
					
					if(speed>maxSpeed)then
						speedColor = Color(200, 0, 0, 255)
						if(maxSpeed>0)then
							ply:EmitSound( "common/warning.wav", 75, 100)
							//datastream.StreamToServer( "GetVehicleOwner", {ent , ply})
							searchWanted = 1
							net.Start("whoIsDriver")
								net.WriteEntity(ent)
							net.SendToServer()
						end
					else
						speedColor = Color(0, 200 , 0, 255)
					end
					timer.Simple(10, function() speed = 0 speedColor = Color(200, 0, 0, 255) end)
				end
			end
		end)
	end
end

function SWEP:SecondaryAttack()
	if(IsFirstTimePredicted())then
		local ply = LocalPlayer()
		ply:EmitSound( "buttons/blip1.wav", 75, 100)
		if(maxSpeed <= 90)then
			maxSpeed = maxSpeed + 15
			ply:PrintMessage( HUD_PRINTTALK, "Maximum Speed set to:"..maxSpeed )
		else
			maxSpeed = 0
			ply:PrintMessage( HUD_PRINTTALK, "Maximum Speed set to:"..maxSpeed )
		end
	end
end

function SWEP:Reload()
	/*if(IsFirstTimePredicted())then
		I = I+1
		if(I==1)then
				hud_color = Color(0, 0, 0, 150)
				color_text = Color( 200, 200, 200, 255 )
		elseif(I==2)then
				hud_color = Color(200, 200, 200, 150)
				color_text = Color( 0, 0, 0, 255 )
		else
			I=0
		end
	end
	*/
end

function SWEP:DrawHUD()
		--print("DrawHUD")
		surface.SetDrawColor( 0, 0, 0, 150 )
		surface.DrawRect( (ScrW()-100)-50, (ScrH()/2)-50, 150, 150 )
		--color_text = Color( 200, 200, 200, 255 )
		draw.SimpleText(

			"Radar HUD",

			"Trebuchet24",

			(ScrW()-75), (ScrH()/2)-30,

			color_text,

			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER

		)
		draw.SimpleText(

			speed,

			"RadarSpeed",

			(ScrW()-75), (ScrH()/2)+20,

			speedColor,

			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER

		)
		draw.SimpleText(

			"Km/H",

			"Trebuchet24",

			(ScrW()-45), (ScrH()/2)+80,

			Color( 200, 200, 200, 255 ),

			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER

		)
		
		draw.SimpleText(

			"Max Speed",

			"RadarMaxSpeed",

			(ScrW()-115), (ScrH()/2)+65,

			Color( 200, 200, 200, 255 ),

			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER

		)
		
		draw.SimpleText(

			maxSpeed,

			"Trebuchet24",

			(ScrW()-130), (ScrH()/2)+85,

			Color( 200, 200, 0, 255 ),

			TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER

		)

end