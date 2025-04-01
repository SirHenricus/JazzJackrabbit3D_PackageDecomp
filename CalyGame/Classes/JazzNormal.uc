//=============================================================================
// JazzNormal.
//=============================================================================
class JazzNormal expands JazzProjectile;

var bool bubbles;
//////////////////////////////////////////////////////////////////////////////////////
// Base Jazz weapon projectile attack
//////////////////////////////////////////////////////////////////////////////////////
//
// Level 1
//
	simulated function PostBeginPlay()
	{
		// Projectile works for some reason when a log is here.
		
		Super.PostBeginPlay();
		Velocity = (Vector(rotation) * InitialVelocity);
		SetLocation( Location + vect(0,0,30) );	// - Velocity offsets initial start location error in Unreal
	}
	
simulated function ZoneChange( ZoneInfo NewZone )
{
	if (NewZone.bWaterZone)
	{ bubbles = true; }
}

simulated event Tick(float DeltaTime)
{
	local vector NewLocation;
	
	if (bubbles == true)
	{
		if (FRand()-(sqrt(abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z))/350) < 0.05)
		{
			NewLocation = Location + VRand()*FRand()*15;
			spawn(class'WaterBubble',,,NewLocation);
		}
	}
}

/////////////////////////////////////////////////////
auto simulated state Flying
{
	simulated function processTouch (Actor Other, vector HitLocation)
	{
		local int hitdamage;

		if ( ValidHit(Other) )
		{
			hitdamage = ImpactDamage;
			Other.TakeDamage(hitdamage, instigator,Other.Location,
				(1500.0 * float(hitdamage) * Normal(Velocity)), 'Energy' );
			Explode(Location, vect(0,0,0));
		}
	}

Begin:
	Sleep(7.0);
	Explode(Location, vect(0,0,0));
}

defaultproperties
{
     InitialVelocity=1500.000000
     ImpactDamage=10
     ImpactDamageType=Energy
     ExplosionWhenHit=Class'CalyGame.JazzShotRicochet1'
     Tracking=True
     TrackingAmount=10.000000
     SpawnSound=Sound'JazzSounds.Weapons.gun1'
     ImpactSound=Sound'JazzSounds.Interface.menuhit'
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'JazzArt.Particles.JazzP10'
     DrawScale=0.200000
     bUnlit=False
     CollisionRadius=5.000000
     CollisionHeight=5.000000
     LightType=LT_Steady
     LightBrightness=200
     LightHue=60
     LightRadius=8
}
