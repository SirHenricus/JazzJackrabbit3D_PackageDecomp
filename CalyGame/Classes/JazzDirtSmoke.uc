//=============================================================================
// JazzDirtSmoke.
//=============================================================================
class JazzDirtSmoke expands JazzEffects;

var vector NewLocation;
var float RollDom;
var bool Free;

function BeginPlay()
{
	Velocity = VRand()*0.5;
	if ( Velocity.Z < 0 ) { Velocity.Z *= -1; }
	RollDom = Rand(256);
	DrawScale = 0.1+Rand(0.2);
}

simulated event Tick (float DeltaTime)
{
	local rotator NewRot;
	
	NewRot = Rotation;
	NewRot.Roll = RollDom;

	DrawScale += DeltaTime*0.25;
	ScaleGlow -= DeltaTime*0.5;
	
	if ( Free == False )
	{
		Velocity.X *= 0.95;
		Velocity.Y *= 0.95;
		Velocity.Z -= DeltaTime;
	}
	
	NewLocation += Velocity;
	
	SetLocation(NewLocation);
	SetRotation(NewRot);
	
	if (ScaleGlow <= 0)
	{ Destroy(); }
}

defaultproperties
{
     Style=STY_Translucent
     Sprite=Texture'JazzArt.Particles.SmokeParticle'
     Texture=Texture'JazzArt.Particles.SmokeParticle'
     ScaleGlow=0.200000
     bParticles=True
     VisibilityRadius=5.000000
     VisibilityHeight=5.000000
}
