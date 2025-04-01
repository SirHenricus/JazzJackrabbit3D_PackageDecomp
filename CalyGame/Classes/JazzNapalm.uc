//=============================================================================
// JazzNapalm.
//=============================================================================
class JazzNapalm expands JazzProjectile;

var() sound	WaterFizzleSound;
var bool Fizzling;

simulated function DamageTarget ( actor Other, vector HitLocation )
{
	Super.DamageTarget(Other,HitLocation);

	//Log("Burn Target) "$Other);
	// Set target on fire
	//	
	if (JazzPawn(Other) != None)
	{
		JazzPawn(Other).Burn();
	}
	else
	if (JazzPlayer(Other) != None)
	{
		JazzPlayer(Other).Burn();
	}
}


simulated function ZoneChange( ZoneInfo NewZone )
{
	local JazzSmokeGenerator S;
	if (NewZone.bWaterZone)
	{
		S = spawn(class'JazzSmokeGenerator');
		S.TotalNumPuffs = 5;
		S.RisingVelocity = 50;
		S.GenerationType = class'JazzSmoke';
		S.Trigger(None,None);
			
		PlaySound(WaterFizzleSound);
		Fizzling = true;
		//GotoState('Fizzling');
	}
}

simulated event Tick(float DeltaTime)
{
	local JazzSmokeGenerator S;
	local vector NewLocation;
	
	if (Fizzling == true)
	{
		Velocity *= 0.98;
		if (FRand()-(sqrt(abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z))/250) < 0.05)
		{
			NewLocation = Location + VRand()*FRand()*25;
			spawn(class'WaterBubble',,,NewLocation);
		}
		if (sqrt(abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z)) <= 0.5)
		{
			S = spawn(class'JazzSmokeGenerator');
			S.TotalNumPuffs = 5;
			S.RisingVelocity = 50;
			S.GenerationType = class'JazzSmoke';
			S.Trigger(None,None);
			Destroy();
		}
	}
}
	
/*function GenerateBubbles ( float DeltaTime )
{
	local vector NewLocation;
	if (FRand()-(sqrt(abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z))/250) < 0.05)
	{
		NewLocation = Location + VRand()*FRand()*50;
		spawn(class'WaterBubble',,,NewLocation);
	}
}
	
	
simulated state Fizzling
{
	Begin:
	bHidden = true;
	Sleep(2);
	Destroy();
}*/

defaultproperties
{
     WaterFizzleSound=Sound'JazzSounds.Weapons.Fire2'
     InitialVelocity=1000.000000
     ImpactDamage=29
     ImpactDamageType=Fire
     RadialDamage=10
     RadialDamageType=Fire
     RadialDamageRadius=100.000000
     ExplosionWhenHit=Class'CalyGame.JazzNapalmExplosion'
     ForceExplosionSound=Sound'JazzSounds.Interface.menuhit'
     ProjectileTrail=Class'CalyGame.CopyTrail'
     SpawnSound=Sound'JazzSounds.Weapons.Fire1'
     ImpactSound=Sound'JazzSounds.Weapons.bigfire'
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'JazzArt.Particles.JazzP12'
     DrawScale=0.300000
     LightType=LT_Steady
     LightBrightness=255
     LightHue=45
     LightRadius=10
}
