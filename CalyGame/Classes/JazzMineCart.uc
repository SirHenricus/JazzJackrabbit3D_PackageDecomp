//=============================================================================
// JazzMineCart.
//=============================================================================
class JazzMineCart expands JazzPlainObjects;

defaultproperties
{
     PushSound=Sound'JazzSounds.Event.elevloop2'
     SpinOnSides=True
     AlignToFloor=True
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.Jminecart_01'
     Mesh=LodMesh'JazzObjectoids.minecart'
     CollisionRadius=27.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     Buoyancy=-120.000000
}
