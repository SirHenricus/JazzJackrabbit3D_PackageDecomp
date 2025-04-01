//=============================================================================
// JazzSentryBallDead.
//=============================================================================
class JazzSentryBallDead expands JazzEffects;
// Patch change - This is a new object that the Sentry Turrets spawn when they explode.
// This is basically the same model that bounces all over the place until it explodes

var float Life;
var ParticleExplosion 	ExPart;
var FireParticle		F;
var float PTime;
var vector randoSpin;

function BeginPlay ()
{
	ExPart = Spawn(class'ParticleExplosion',Self);
	
	randoSpin = VRand()*500;
	Life = 5;
	Velocity = VRand()*100;
	Velocity.Z = 200+rand(200);
	
	//F = Spawn(class'FireParticleGen',Self);
	//F.LifeTime = Life;
	//F.SetOwner(self);
}

function Touch( actor Other )
{
	if (other.isA('JazzPlayer') || other.isA('JazzPawnAI') )
	{
		velocity.X += ((Other.Location.X-Location.X)*0.2+Other.Velocity.X)*0.2;
		velocity.Y += ((Other.Location.Y-Location.Y)*0.2+Other.Velocity.Y)*0.2;
		velocity.Z += ((Other.Location.Z-Location.Z)*0.2+Other.Velocity.Z+10)*0.2;
	}
}

function Tick( float DeltaTime )
{
	local vector PartLocation;
	local rotator NewRotation;

	PTime += DeltaTime*20;
	if (PTime > 1)
	{
		PartLocation.X = Location.X-20+Rand(40);
		PartLocation.Y = Location.Y-20+Rand(40);
		PartLocation.Z = Location.Z-20+Rand(40);
		
		F = spawn(class'FireParticle');
		F.SetLocation(PartLocation);
		PTime = 0;
	}

	Life -= DeltaTime;
	
	if ( Life <= 0 )
	{
		ExPart = Spawn(class'ParticleExplosion',Self);
		Destroy();
	}
	
	NewRotation = Rotation;
	NewRotation.Yaw += randoSpin.Z;
	NewRotation.Pitch += randoSpin.Y;
	NewRotation.Roll += randoSpin.X;
	
	SetRotation(NewRotation);
}

// Bounce
simulated function HitWall( vector HitNormal, actor Wall )
{
	local float spinRate;
	
	//RandSpin(100000);
	//randoSpin = RotRand()*65536;
	
	randoSpin = VRand()*500;

	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
}

defaultproperties
{
     Physics=PHYS_Falling
     AnimSequence=spoot
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.SentryTurret'
     CollisionRadius=6.000000
     CollisionHeight=6.000000
     bCollideActors=True
     bCollideWorld=True
     bBounce=True
     RotationRate=(Pitch=65536,Yaw=65536,Roll=65536)
}
