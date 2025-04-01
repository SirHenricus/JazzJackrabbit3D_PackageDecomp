//=============================================================================
// FireCircleTorch.
//=============================================================================
class FireCircleTorch expands FireCircle;

var float ZVel;
var float Spread;
var float Cycle;

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

	//SetLocation(LastOwnerLocation + Realative);
}

//
// Assume maxlifespan always != 0
// Assume we will always have owner	
// Assume owner never changes location or has velocity
// LastOwnerLoc points to the owner location
//

simulated function Reset()
{
	//SetLocation(LastOwnerLocation);
	Velocity = VRand() * Spread;
	
	Realative = vect(0,0,0);
	
	Velocity.Z = ZVel;
	MaxLifeSpan = Cycle + (0.1*FRand() - 0.2);
	CurLife = MaxLifeSpan;
}

defaultproperties
{
     Physics=PHYS_None
     bNoSmooth=False
     bParticles=False
     VisibilityRadius=0.000000
     VisibilityHeight=0.000000
     bGameRelevant=False
}
