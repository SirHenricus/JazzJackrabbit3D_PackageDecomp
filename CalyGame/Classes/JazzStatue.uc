//=============================================================================
// JazzStatue.
//=============================================================================
class JazzStatue expands JazzPlainObjects;

//
// Statue of a bunny!
//

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.BunnyStatue'
     CollisionHeight=66.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
