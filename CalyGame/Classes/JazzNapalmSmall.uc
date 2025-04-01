//=============================================================================
// JazzNapalmSmall.
//=============================================================================
class JazzNapalmSmall expands JazzProjectile;

function Tick ( float DeltaTime )
{
	ScaleGlow = (LifeSpan/6);
	DrawScale = (LifeSpan/6)*0.15;
	
	Super.Tick(DeltaTime);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
}

// Bounce
// Patch change - shamelessly copied the code from JazzBlueGranade... it works though.
simulated function HitWall( vector HitNormal, actor Wall )
{
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	RandSpin(100000);
	speed = VSize(Velocity);
	if ( Level.NetMode != NM_DedicatedServer )
		PlaySound(ImpactSound, SLOT_Misc, FMax(0.3, speed/1500) );
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
	else if ( speed < 20 ) 
	{
		bBounce = False;
		SetPhysics(PHYS_None);
		Explode(Location,HitNormal);
	}
}
/*simulated function HitWall( vector HitNormal, actor Wall )
{
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	RandSpin(100000);
	speed = VSize(Velocity);
/*	if ( Level.NetMode != NM_DedicatedServer )
		PlaySound(ImpactSound, SLOT_Misc, FMax(0.5, speed/800) );*/
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
	else if ( speed < 20 ) 
	{
		bBounce = False;
		SetPhysics(PHYS_None);
	}
}*/

defaultproperties
{
     InitialVelocity=300.000000
     ImpactDamage=5
     ImpactDamageType=Fire
     SpawnSound=Sound'JazzSounds.Weapons.fireshot'
     Physics=PHYS_Falling
     LifeSpan=6.000000
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'JazzArt.Particles.JazzP12'
     DrawScale=0.150000
     LightType=LT_Steady
     LightBrightness=255
     LightHue=45
     LightRadius=6
     bBounce=True
}
