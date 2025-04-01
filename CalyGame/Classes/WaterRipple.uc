//=============================================================================
// WaterRipple.
//=============================================================================
class WaterRipple expands JazzEffects;

var float life;

simulated event PostBeginPlay()
{
	life = 0;
	PlayAnim(AnimSequence,AnimRate);
}

simulated event Tick(float DeltaTime)
{
	local float ndraw;
	
	// Patch change - Disappear only after they fade out
	
	ScaleGlow -= deltatime*2;
	
	if ( ScaleGlow < 0 )
	{ Destroy(); }

}

defaultproperties
{
     bMovable=False
     bNetTemporary=True
     bNetOptional=True
     LifeSpan=0.600000
     AnimSequence=splash1
     AnimRate=1.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=LodMesh'JazzObjectoids.splash1'
     bMeshCurvy=True
}
