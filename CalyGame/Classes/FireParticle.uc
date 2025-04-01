//=============================================================================
// FireParticle.
//=============================================================================
class FireParticle expands JazzEffects;

var float ZVel;
var float OrigZ;
var float Zoffset;

function BeginPlay()
{
	Velocity.X = -10 + Rand(20);
	Velocity.X = -10 + Rand(20);
	ZVel = 0.5+Rand(0.5);
	OrigZ = Location.Z;
	DrawScale = 0.2+Rand(0.2);
}

simulated event Tick (float DeltaTime)
{
	local vector RiseLocation;
	
	RiseLocation.X = Location.X;
	RiseLocation.Y = Location.Y;
	RiseLocation.Z = OrigZ+Zoffset;
	Zoffset += ZVel;
	SetLocation(RiseLocation);
	
	DrawScale -= DeltaTime*0.25;
	Velocity.X *= 0.9;
	Velocity.Y *= 0.9;
	Velocity.Z = ZVel;
	
	if (DrawScale < 0)
	{ Destroy(); }
}

defaultproperties
{
     Style=STY_Translucent
     Sprite=Texture'JazzArt.Particles.Jazzp15'
     Texture=Texture'JazzArt.Particles.Jazzp15'
     bParticles=True
     VisibilityRadius=5.000000
     VisibilityHeight=5.000000
}
