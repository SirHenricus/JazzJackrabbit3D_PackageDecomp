//=============================================================================
// JazzFire.
//=============================================================================
class JazzFire expands JazzProjectile;

var() sound	WaterFizzleSound;
var bool Fizzling;

//////////////////////////////////////////////////////////////////////////////////////
// Jazz Fire Attack
//////////////////////////////////////////////////////////////////////////////////////
//
// Level 1
//

	simulated function PostBeginPlay()
	{
		local ParticleTrails P;
	
		Super.PostBeginPlay();

		Velocity = (Vector(Rotation) * 1000.0) - vect(0,0,100);

/*		Acceleration = vect(0,0,0);
		SetLocation( Location + vect(0,0,30) /*- (Velocity/7)*/ );	// - Velocity offsets initial start location error in Unreal
		PlaySound(SpawnSound);*/
		
		// Arrow Trail
		P = Spawn(class'SparkTrail',Self);
		P.TrailActor = class'SpritePoofieFireSpark';
		P.TrailRandomRadius = 10;
		P.Activate(0.05,99999);
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

// Patch change - shamelessly copied the code from JazzBlueGranade, changed a bit so it actually works properly
// I am not sure if it was intended for these to drift up walls, but it just doesn't look right, nor is it fun... at all.
simulated function HitWall( vector HitNormal, actor Wall )
{
	//local JazzNapalmExplosion S;

	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	//RandSpin(100000);
	speed = VSize(Velocity);
	/*if (speed < 40)
	{
		PlaySound(ImpactSound, SLOT_Misc, FMax(0.3, speed/1500) );
		Spawn(Class'JazzNapalmExplosion',self);
	}*/
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
	/*else if ( speed < 20 ) 
	{
		bBounce = False;
		SetPhysics(PHYS_None);
		Explode(Location,HitNormal);
	}*/
}
/*simulated function HitWall (vector HitNormal, actor Wall)
{
	if ( (Mover(Wall) != None) && Mover(Wall).bDamageTriggered )
	{
		Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), '');
		MakeNoise(1.0);
		Explode(Location + ExploWallOut * HitNormal, HitNormal);
	}
	Velocity = vect(400,0,0) >> Rotation;
	Velocity.Z = -25;
	//Velocity.Z = -Velocity.Z
	SetLocation(Location + vect(0,0,4)); 
}*/

simulated event Tick(float DeltaTime)
{
	local JazzSmokeGenerator S;
	local vector NewLocation;
	
	if (Fizzling == true)
	{
		Velocity *= 0.98;
		if (FRand()-(sqrt(abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z))/100) < 0.05)
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

auto simulated state Flying
{
	simulated function processTouch (Actor Other, vector HitLocation)
	{
		local int hitdamage;

		if ( Other == None && Fizzling == false )			// Continue rolling
		{
			Velocity += vect(50,0,0) << Rotation;
			SetPhysics(PHYS_Falling);
		}
		else
		if ( ValidHit(Other) )
		{
			hitdamage = 10;
			Other.TakeDamage(hitdamage, instigator,Other.Location,
				(1500.0 * float(hitdamage) * Normal(Velocity)), 'Fire' );
			Explode(Location, vect(0,0,0));
		}
	}
	
	simulated function Tick ( float DeltaTime )
	{
		if (Fizzling == false)
		{ Acceleration += vect(0,0,-400)*DeltaTime; }
		//Velocity += Acceleration;
	}
	
Begin:
	Sleep(7.0);
	Explode(Location, vect(0,0,0));
}

/*simulated state Fizzling
{
	Begin:
	bHidden = true;
	Sleep(2);
	Destroy();
}*/

defaultproperties
{
     WaterFizzleSound=Sound'JazzSounds.Weapons.Fire2'
     InitialVelocity=899.000000
     ImpactDamage=20
     ImpactDamageType=Fire
     RadialDamageRadius=15.000000
     ExplosionWhenHit=Class'CalyGame.JazzBallExplosion'
     ForceExplosionSound=Sound'JazzSounds.Weapons.bigfire'
     Live=True
     Damage=30.000000
     SpawnSound=Sound'JazzSounds.Weapons.Fire1'
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'JazzArt.Particles.JazzP12'
     Skin=Texture'JazzArt.Particles.JazzP12'
     DrawScale=0.200000
     AmbientGlow=255
     bUnlit=False
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     LightType=LT_Pulse
     LightBrightness=255
     LightRadius=4
     bBounce=True
}
