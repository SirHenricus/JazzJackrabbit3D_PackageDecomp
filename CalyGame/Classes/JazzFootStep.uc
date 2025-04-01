//=============================================================================
// JazzFootstep.
//=============================================================================
class JazzFootstep expands Decal;

var vector HitLocation, HitNormal;
var bool Left;

var float Life;

simulated event BeginPlay()
{
	AttachDecal(1000,vect(1,1,1));	// trace 100 units ahead in direction of current rotation

	DetachDecal();
	SetRotation(rot(16384,0,0));
	
	SetLocation(Owner.Location);
	Trace(HitLocation,HitNormal,Location+vect(0,0,-1000),,false);
	
	AttachDecal(1000, vect(1,1,1));
}

simulated event Tick(float DeltaTime)
{
	Life += DeltaTime;
	
	if (Left == True)
	{ Texture = Texture'JazzArt.Decal.FootPrintLeft'; }
	else
	{ Texture = Texture'JazzArt.Decal.FootPrintRight'; }
	
	if(Life >= 10)
	{
		DrawScale -= DeltaTime*200;
		if (Fatness <= 0)
		{ Destroy(); }
	}
}


// Old Code - stuff has now been simplified due to need to finish this all as quickly as possible
/*var float Life;

simulated event BeginPlay()
{
	local vector Dir;
	
	Life = 0;
	
	Dir = vector(Rotation);
	
	Dir.z = -1;
	
	if(!AttachDecal(100,dir)) // trace 100 units ahead in direction of current rotation
		Destroy();
}

simulated event Tick(float DeltaTime)
{
	Life += DeltaTime;
	
	if(Life >= 10)
	{
		DrawScale -= DeltaTime*200;
		if (Fatness <= 0)
		{ Destroy(); }
	}
}
*/

defaultproperties
{
     Style=STY_Translucent
     Texture=Texture'JazzArt.Decal.FootPrintRight'
     DrawScale=0.130000
     bUnlit=True
}
