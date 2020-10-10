if SERVER then
    AddCSLuaFile("shared.lua")
    resource.AddWorkshop("2252533416")
end

SWEP.PrintName				= "Yeet"
SWEP.Author					= "Kim Jong Tiramisus"
SWEP.Instructions			= "This Weapon will yeet your enemy into heaven. \nYou got two shots"
SWEP.Spawnable              = true
SWEP.AdminOnly              = true

SWEP.Base                   = "weapon_tttbase"
SWEP.Kind                   = WEAPON_EQUIP1
SWEP.CanBuy                 = { ROLE_TRAITOR }
SWEP.Slot                   = 6
SWEP.InLoadoutFor           = nil
SWEP.LimitedStock           = true

SWEP.AllowDrop              = true
SWEP.IsSilent               = false
SWEP.NoSights               = false
SWEP.AutoSpawnable          = false
SWEP.HoldType               = "pistol"
SWEP.UseHands               = true

SWEP.Primary.ClipSize		= 2
SWEP.Primary.DefaultClip	= 2
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Spread         = 0.1
SWEP.Primary.Recoil         = 0.2
SWEP.Primary.Delay          = 0.1
SWEP.Primary.Force          = 100
SWEP.Primary.NumberofShots  = 1
SWEP.Primary.Damage         = 1
SWEP.Primary.TakeAmmo       = 1

SWEP.Weight					= 7
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false

SWEP.ViewModel				= "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel				= "models/weapons/w_pist_fiveseven.mdl"
SWEP.ViewModelFlip          = false

if CLIENT then
    SWEP.Icon = "vgui/ttt/icon_ttt_yeet.png"
    SWEP.EquipMenuData = {
        type = "weapon",
        desc = "This Weapon will yeet your enemy into heaven. \nYou got two shots"
    };
end

local ShootSound = Sound("Weapon_Pistol.Single")
sound.Add ( {
    name = "yeet",
    channel = CHAN_STATIC,
    volume = 1,
    level = 80,
    pitch = 100,
    sound = "yeet-sound-effect.wav"
})



function SWEP:Initialize()
    util.PrecacheSound(ShootSound) 
    self:SetWeaponHoldType( self.HoldType )

end 

function SWEP:PrimaryAttack()
 
    if ( !self:CanPrimaryAttack() ) then return end
    local bullet = {} 
    bullet.Num = self.Primary.NumberofShots 
    bullet.Src = self.Owner:GetShootPos() 
    bullet.Dir = self.Owner:GetAimVector() 
    bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
    bullet.Tracer = 1
    bullet.Force = self.Primary.Force 
    bullet.Damage = self.Primary.Damage 
    bullet.AmmoType = self.Primary.Ammo 

    bullet.Callback = function(att, tr)
                            if SERVER || (CLIENT and IsFirstTimePredicted()) then
                                local ent = tr.Entity
                                if IsValid(ent) then
                                    print(ent:GetClass())
                                    if ent:IsPlayer() then
                                        self.Owner:EmitSound("yeet")
                                        ent:SetVelocity(Vector(0, 0, 10000))
                                    end
                                end
                            end
                        end
     
    local rnda = self.Primary.Recoil * -1 
    local rndb = self.Primary.Recoil * math.random(-1, 1) 
     
    self:ShootEffects()
     
    self.Owner:FireBullets( bullet ) 
    self:EmitSound(ShootSound)
    self.Owner:ViewPunch( Angle( rnda,rndb,rnda ) ) 
    self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
     
    self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 

    if self.Weapon:Clip1() <= 0 && SERVER then
        self:Remove()
    end

end

