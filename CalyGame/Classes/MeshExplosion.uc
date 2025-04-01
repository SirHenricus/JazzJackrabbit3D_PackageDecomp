//=============================================================================
// MeshExplosion.
//=============================================================================
class MeshExplosion expands JazzEffects;
// Patch change - A new explosion effect. This model was already in the game, I just decided to give it some sort of use.

var float life;

simulated event PostBeginPlay()
{
	life = 1;
	PlayAnim('Explode',1);
}

simulated event Tick(float DeltaTime)
{	
	life -= DeltaTime;
	if ( life < 0 )
	{ Destroy(); }
}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=LodMesh'JazzObjectoids.Explode'
     MultiSkins(0)=Texture'JazzObjectoids.Skins.Jexplode_01'
     MultiSkins(1)=Texture'JazzObjectoids.Skins.Jexplode_02'
     MultiSkins(2)=Texture'JazzObjectoids.Skins.Jexplode_03'
}
