//=============================================================================
// JazzTurtleDead.
//=============================================================================
class JazzTurtleDead expands JazzEffects;
// Patch change - This is a new object that the Turtles spawn when they explode.
// This is basically an empty turtle shell, that bounces all over the place until it fades out.

var float Life;
var ParticleTurtleExplosion 	ExPart;
var JazzTurtleBlood 	BloodPart;

function BeginPlay ()
{
	local int i;
	
	for(i = 5+rand(5); i > 0; i--)
	{
		BloodPart = Spawn(class'JazzTurtleBlood',Self);
		BloodPart.Velocity = VRand()*100;
		BloodPart.Velocity.Z = 300+rand(300);
		BloodPart.DrawScale = 1+rand(3);
	}
	
	ExPart = Spawn(class'ParticleTurtleExplosion',Self);
	Life = 4;
}

function Tick( float DeltaTime )
{
	local rotator NewRotation;
	NewRotation = Rotation;
	NewRotation.Pitch = 0;
	NewRotation.Roll = 0;
	
	Life -= DeltaTime;
	if ( Life <= 0 )
	{
		Style = STY_Translucent;
		ScaleGlow -= DeltaTime;
		if ( ScaleGlow < 0 )
		{ Destroy(); }
	}
	
	SetRotation(NewRotation);
}

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzEnemy.Skins.TurtleGreenDead'
     Mesh=LodMesh'JazzObjectoids.TurtleDead'
     CollisionRadius=31.000000
     CollisionHeight=31.000000
     bCollideWorld=True
     RotationRate=(Pitch=65536,Yaw=65536,Roll=65536)
}
