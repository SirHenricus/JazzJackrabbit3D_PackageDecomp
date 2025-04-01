//=============================================================================
// FireParticleGen.
//=============================================================================
class FireParticleGen expands JazzEffects;

var float PTime;
var float LifeTime;

simulated event Tick (float DeltaTime)
{
	local FireParticle Part;
	local vector PartLocation;
	
	SetLocation(Owner.Location);
	
	PTime += DeltaTime*20;
	if (PTime > 1)
	{
		PartLocation.X = Location.X-5+Rand(10);
		PartLocation.Y = Location.Y-5+Rand(10);
		PartLocation.Z = Location.Z-20+Rand(40);
		
		Part = spawn(class'FireParticle');
		Part.SetLocation(PartLocation);
		PTime = 0;
	}
	
	if (JazzPawn(Owner) != None)
	{
		
	  	if (JazzPawn(Owner).Health<=0 || JazzPawn(Owner).Physics == Phys_Swimming)
	  	{ Destroy(); }
	}
	
	lifetime -= DeltaTime;
	if (lifetime < 0)
	{ Destroy(); }
}

defaultproperties
{
     DrawType=DT_None
}
