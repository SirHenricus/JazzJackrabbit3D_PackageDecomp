//=============================================================================
// ExplosionRipple.
//=============================================================================
class ExplosionRipple expands JazzEffects;
var	rotator	RandRot;
var	float	ScaleMult;

function PostBeginPlay()
{
	RandRot.Yaw = rand(65536);
	RandRot.Roll = -1000+rand(2000);
	RandRot.Pitch = -1000+rand(2000);
	
	ScaleMult = 30+rand(70);
}

simulated event Tick(float DeltaTime)
{		
	ScaleGlow -= DeltaTime*2;
	DrawScale += DeltaTime*ScaleMult;
	
	if ( ScaleGlow <= 0 )
	{ Destroy(); }
	
	SetRotation(RandRot);
}

defaultproperties
{
     bTravel=True
     AnimSequence=expring
     AnimFrame=5.000000
     Rotation=(Pitch=256)
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'JazzObjectoids.Skins.Jexpring_01'
     Mesh=LodMesh'JazzObjectoids.expring'
     bUnlit=True
     bAlwaysRelevant=False
}
