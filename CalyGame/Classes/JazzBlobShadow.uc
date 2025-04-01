//=============================================================================
// JazzBlobShadow.
//=============================================================================
class JazzBlobShadow expands Decal;
/// This is a new type of effect created by the Patcher. ///

var vector HitLocation, HitNormal;
var float Diff;
var float Size;
var float Blackness;
var float Noscale;

simulated event BeginPlay()
{
	AttachDecal(1000,vect(1,1,1));	// trace 100 units ahead in direction of current rotation
}

simulated event Tick(float DeltaTime)
{
	if (Blackness == 3)
	{ Texture = Texture'JazzArt.Shadow.BlobShadowHigh'; }
	else if (Blackness == 2)
	{ Texture = Texture'JazzArt.Shadow.BlobShadowMediu'; }
	else
	{ Texture = Texture'JazzArt.Shadow.BlobShadowLow'; }

	DetachDecal();
	SetRotation(rot(16384,0,0));
	
	SetLocation(Owner.Location);
	
	Trace(HitLocation,HitNormal,Location+vect(0,0,-1000),,false);
	
	if (Noscale != 1)
	{
		Diff = Location.Z - HitLocation.Z;
		DrawScale = Size+5/(Diff/5);
		if(DrawScale > 0.5)
		{ DrawScale = 0.5; }
	}
	else
	{ DrawScale = Size; }
	
	AttachDecal(1000, vect(1,1,1));
	
	if (Owner == None)
	{ Destroyed(); }
}

defaultproperties
{
     Texture=Texture'JazzArt.Shadow.BlobShadowLow'
}
