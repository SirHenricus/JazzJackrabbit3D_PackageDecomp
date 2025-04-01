//=============================================================================
// JazzLizardDead.
//=============================================================================
class JazzLizardDead expands JazzEffects;
// Patch change - This is a new object that the Lizards spawn when they explode.
// This is basically a curled turtle that bounces all over the place until it fades out.

var float Life;
var ParticleLizardExplosion 	ExPart;
var JazzTurtleBlood 	BloodPart;
var float PTime;
var vector randoSpin;

function BeginPlay ()
{
	local int i;
	
	ExPart = Spawn(class'ParticleLizardExplosion',Self);

	randoSpin = VRand()*400;
	Life = 0.6;
	//Velocity = VRand()*100;
	Velocity.Z = 200+rand(200);
	
	for(i = 5+rand(10); i > 0; i--)
	{
		BloodPart = Spawn(class'JazzTurtleBlood',Self);
		BloodPart.Velocity = VRand()*100;
		BloodPart.Velocity.Z = 400+rand(400);
		BloodPart.DrawScale = 1+rand(2);
		BloodPart.MultiSkins[1] = Texture'Jazzytextures2.goldrefl1';
	}
	
	//F = Spawn(class'FireParticleGen',Self);
	//F.LifeTime = Life;
	//F.SetOwner(self);
}

/*function Touch( actor Other )
{
	if (other.isA('JazzPlayer') || other.isA('JazzPawnAI') )
	{
		velocity.X += ((Other.Location.X-Location.X)*0.2+Other.Velocity.X)*0.2;
		velocity.Y += ((Other.Location.Y-Location.Y)*0.2+Other.Velocity.Y)*0.2;
		velocity.Z += ((Other.Location.Z-Location.Z)*0.2+Other.Velocity.Z+10)*0.2;
	}
}*/

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
     LODBias=2.000000
     DrawType=DT_Mesh
     Skin=Texture'JazzObjectoids.Skins.JLizard_01'
     Mesh=LodMesh'JazzObjectoids.LizardDead'
     DrawScale=2.000000
     bShadowCast=True
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     bCollideWorld=True
     bBounce=True
}
