//=============================================================================
// JazzIce.
//=============================================================================
class JazzIce expands JazzProjectile;

var() sound FreezeSound;

simulated function PostBeginPlay()
{
	local ParticleTrails P;

	Super.PostBeginPlay();
	Velocity = (Vector(Rotation) * 1000.0);
	
	SetLocation( Location + vect(0,0,30) /*- (Velocity/7)*/ );	// - Velocity offsets initial start location error in Unreal
	
	// Arrow Trail
	P = Spawn(class'SparkTrail',Self);
	P.TrailActor = class'SpritePoofieSmallBlue';
	P.TrailRandomRadius = 10;
	P.Activate(0.05,99999);
}

auto simulated state Flying
{
}

simulated function ProcessTouch(actor Other, vector HitLocation)
{
	// Make sure we don't hit ourself?
	if ( ValidHit(Other) )
	{
		if(JazzPlayer(Other) != None)
		{
			JazzPlayer(Other).Freeze();
			Other.PlaySound(FreezeSound);
			Destroy();
		}
		else
		if(JazzPawn(Other) != None)
		{
			JazzPawn(Other).Freeze();
			Destroy();
		}
		else if(JazzDecoration(Other) != None)
		{
			//JazzDecoration(Other).Freeze();
			Destroy();
		}
	}
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	MakeNoise(0.3);
  	SetPhysics(PHYS_None);
	SetCollision(false,false,false);
	RemoteRole = ROLE_None;
	//Mesh = mesh'Burst';	// TODO: New Mesh
	SetRotation( RotRand() );
	PlayAnim   ( 'Explo', 0.9 );
	GotoState('Exploding');
}

simulated state Exploding
{
	Begin:
		FinishAnim();
		Destroy();
}

defaultproperties
{
     FreezeSound=Sound'JazzSounds.Weapons.freeze'
     InitialVelocity=900.000000
     ImpactDamage=3
     ImpactDamageType=Cold
     ExplosionWhenHit=Class'CalyGame.JazzShotRicochetIce'
     SpawnSound=Sound'JazzSounds.Weapons.iceshot2'
     ImpactSound=Sound'JazzSounds.Weapons.richochet1'
     Mesh=LodMesh'JazzObjectoids.iceshard'
     bUnlit=False
     CollisionRadius=5.000000
     CollisionHeight=5.000000
}
