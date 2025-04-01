//=============================================================================
// JazzFootstepDecal.
//=============================================================================
class JazzFootstepDecal expands Decal;

var float Life;

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
	
	//ScaleGlow = (10-Life)/10;
	
	if(Life >= 10)
	{
		Fatness -= DeltaTime*200;
		if (Fatness <= 0)
		{ Destroy(); }
	}
}

defaultproperties
{
     Style=STY_Translucent
     Texture=Texture'JazzArt.Decal.FootPrintRight'
     DrawScale=0.130000
     bUnlit=True
}
