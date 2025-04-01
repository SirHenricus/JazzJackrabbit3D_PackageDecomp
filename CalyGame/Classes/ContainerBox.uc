//=============================================================================
// ContainerBox.
//=============================================================================
class ContainerBox expands ItemContainer;

defaultproperties
{
     Items(0)=Class'CalyGame.JazzItemLevel1'
     Items(1)=Class'CalyGame.JazzItemLevel1'
     Items(2)=Class'CalyGame.JazzItemLevel1'
     Items(3)=Class'CalyGame.JazzItemLevel1'
     Health=20
     HitFlash=True
     floatAnimation=True
     bPushable=True
     FallOffEdge=True
     SpinOnSides=True
     AlignToFloor=True
     bDirectional=True
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.JChest1_01'
     Mesh=LodMesh'JazzObjectoids.Chest1'
     DrawScale=2.000000
     CollisionRadius=44.000000
     CollisionHeight=44.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     Buoyancy=90.000000
}
