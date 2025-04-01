//=============================================================================
// JazzDecalShadow.
//=============================================================================
class JazzDecalShadow expands Decal;

var vector HitLocation, HitNormal;
var float Diff;

simulated event BeginPlay()
{
	AttachDecal(1000,vect(1,1,1));	// trace 100 units ahead in direction of current rotation
}

simulated event Tick(float DeltaTime)
{
	DetachDecal();
	SetRotation(rot(16384,0,0));
	
	SetLocation(Owner.Location);
	bHidden = owner.bHidden;
	
	Trace(HitLocation,HitNormal,Location+vect(0,0,-1000),,false);
	
	Diff = Location.Z - HitLocation.Z;
	
	DrawScale = 5/(Diff/10);
	
	if(DrawScale > 0.25)
	{
		DrawScale = 0.25;
	}
	
	AttachDecal(1000, vect(1,1,1));
}

defaultproperties
{
     Style=STY_Modulated
     Texture=Texture'JazzArt.Shadow.Jazzshadow'
     DrawScale=0.300000
}
