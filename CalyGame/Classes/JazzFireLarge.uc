//=============================================================================
// JazzFireLarge.
//=============================================================================
class JazzFireLarge expands JazzFire;

var bool Fizzling;

simulated function PostBeginPlay()
{
	local CopyTrail P;
	
	//Super.PostBeginPlay();

	Velocity = (Vector(Rotation) * 1000.0) - vect(0,0,100);

/*	Acceleration = vect(0,0,0);
	SetLocation( Location + vect(0,0,30) /*- (Velocity/7)*/ );	// - Velocity offsets initial start location error in Unreal
	PlaySound(SpawnSound);*/
		
	// Arrow Trail
	P = Spawn(class'CopyTrail',Self);
	//P.TrailActor = class'SpritePoofieFireSpark';
	P.Activate(0.1,99999);

	// Play shot spawn sound
	PlaySound(SpawnSound, SLOT_Misc, 2.0);		
}


simulated function HitWall( vector HitNormal, actor Wall )
{
	local ParticleExplosion S;
	
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	speed = VSize(Velocity);
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
	if (sqrt(abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z)) > 50)
	{
		PlaySound(ImpactSound, SLOT_Misc, FMax(0.3, speed/1500) );
		Spawn(Class'ParticleExplosion',self);
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
		if (FRand()-(sqrt(abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z))/150) < 0.05)
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

defaultproperties
{
     WaterFizzleSound=None
     InitialVelocity=0.000000
     ImpactDamage=30
     RadialDamage=5
     RadialDamageRadius=50.000000
     ExplosionWhenHit=Class'CalyGame.JazzNapalmExplosion'
     Live=False
     SpawnSound=Sound'JazzSounds.Weapons.Fire2'
     DrawScale=0.300000
}
