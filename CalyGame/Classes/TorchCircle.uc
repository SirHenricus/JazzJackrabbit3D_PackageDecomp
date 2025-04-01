//=============================================================================
// TorchCircle.
//=============================================================================
class TorchCircle expands JazzEffects;

var float ZVel;
var float Spread;
var float Cycle;
var vector LastOwnerLocation;
var vector Realative;
var float MaxLifeSpan;
var float CurLife;
var float MaxDrawScale;

//
// Simpler torch effect
//
function PreBeginPlay()
{
}

simulated event Tick (float DeltaTime)
{
	DrawScale = CurLife/MaxLifeSpan*MaxDrawScale;
	
	CurLife -= DeltaTime;
		
	Velocity.X -= Velocity.X >> 2;	// Velocity.X /= 1.2;
	Velocity.Y -= Velocity.Y >> 2;  // Velocity.Y /= 1.2;
	
	Realative += Velocity*DeltaTime;

	SetLocation(LastOwnerLocation + Realative);
}

//
// Assume maxlifespan always != 0
// Assume we will always have owner	
// Assume owner never changes location or has velocity
// LastOwnerLoc points to the owner location
//

simulated function Reset()
{
	SetLocation(LastOwnerLocation);
	Velocity = VRand() * Spread;
	
	Realative = vect(0,0,0);
	
	Velocity.Z = ZVel;
	MaxLifeSpan = Cycle + (0.1*FRand() - 0.2);
	CurLife = MaxLifeSpan;
}

defaultproperties
{
     Style=STY_Translucent
     Texture=Texture'JazzArt.Particles.JazzP13'
     DrawScale=0.180000
     ScaleGlow=0.900000
}
