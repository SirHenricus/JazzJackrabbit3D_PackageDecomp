//=============================================================================
// BendingPlant.
//=============================================================================
class BendingPlant expands JazzMotionObjects;

defaultproperties
{
     BentByPlayer=True
     Physics=PHYS_Rotating
     DrawType=DT_Mesh
     Skin=Texture'JazzDecoration.Skins.Jplant3_01'
     Mesh=LodMesh'JazzDecoration.Plant3'
     bCollideActors=True
}
