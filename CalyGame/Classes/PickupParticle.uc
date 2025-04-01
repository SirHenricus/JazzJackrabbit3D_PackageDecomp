//=============================================================================
// PickupParticle.
//=============================================================================
class PickupParticle expands JazzEffects;

var vector 	NewVel;
var vector 	NewLocation;

function BeginPlay()
{
	NewLocation = Location;
	NewVel = VRand()*5;
	DrawScale = 0.2+Rand(0.2);
}

simulated event Tick (float DeltaTime)
{
	NewVel *= 0.9;
	NewLocation += NewVel;
	SetLocation(NewLocation);

	DrawScale -= DeltaTime*0.25;
	if (DrawScale < 0)
	{ Destroy(); }
}

defaultproperties
{
     Style=STY_Translucent
     Sprite=Texture'JazzArt.Particles.JazzP3'
     Texture=Texture'JazzArt.Particles.JazzP3'
     bParticles=True
     VisibilityRadius=5.000000
     VisibilityHeight=5.000000
}
