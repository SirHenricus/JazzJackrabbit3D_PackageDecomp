//=============================================================================
// JazzTurtleShell.
//=============================================================================
class JazzTurtleShell expands JazzEffects;

// Patch change - This is a new object that the Turtles spawn when they explode.
// This is basically an empty turtle shell, that bounces all over the place until it fades out.

var float Life;
var ParticleTurtleExplosion 	ExPart;
var JazzTurtleBlood 	BloodPart;
var float PTime;
var vector randoSpin;

function BeginPlay ()
{
	local int i;

	ExPart = Spawn(class'ParticleTurtleExplosion',Self);

	randoSpin = VRand()*400;
	Life = 3.5;
	//Velocity = VRand()*100;
	Velocity.Z = 200+rand(200);
	
	for(i = 5+rand(10); i > 0; i--)
	{
		BloodPart = Spawn(class'JazzTurtleBlood',Self);
		BloodPart.Velocity = VRand()*300;
		BloodPart.Velocity.Z = 400+rand(400);
		BloodPart.DrawScale = 1+rand(3);
	}
	
	//F = Spawn(class'FireParticleGen',Self);
	//F.LifeTime = Life;
	//F.SetOwner(self);
}

function Touch( actor Other )
{
	if (other.isA('JazzPlayer') || other.isA('JazzPawnAI') )
	{
		velocity.X += ((Other.Location.X-Location.X)*0.2+Other.Velocity.X)*0.4;
		velocity.Y += ((Other.Location.Y-Location.Y)*0.2+Other.Velocity.Y)*0.4;
		velocity.Z += ((Other.Location.Z-Location.Z)*0.2+Other.Velocity.Z+10)*0.4;
	}
}

function Tick( float DeltaTime )
{
	local rotator NewRotation;
	
	PlayAnim('TurtleUnhide',0);
	AnimFrame = 0;

	Life -= DeltaTime;
	
	if ( Life <= 0 )
	{
		//ExPart = Spawn(class'ParticleExplosion',Self);
		Style = STY_Translucent;
		ScaleGlow -= DeltaTime;
		if ( ScaleGlow < 0 )
		{ Destroy(); }
	}
	
	NewRotation = Rotation;
	if ( sqrt(abs(Velocity.X*Velocity.X+Velocity.Y*Velocity.Y+Velocity.Z*Velocity.Z)) > 10 )
	{
		NewRotation.Yaw += randoSpin.Z;
		NewRotation.Pitch += randoSpin.Y;
		NewRotation.Roll += randoSpin.X;
	}
	
	SetRotation(NewRotation);
}

// Bounce
simulated function HitWall( vector HitNormal, actor Wall )
{
	local float spinRate;
	
	randoSpin = VRand()*500;

	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
}

defaultproperties
{
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Skin=Texture'JazzEnemy.Skins.TurtleGreenDead'
     Mesh=LodMesh'JazzObjectoids.TurtleShell'
     CollisionRadius=15.000000
     CollisionHeight=15.000000
     bCollideActors=True
     bCollideWorld=True
     bBounce=True
}
