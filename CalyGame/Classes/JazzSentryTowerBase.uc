//=============================================================================
// JazzSentryTowerBase.
//=============================================================================
class JazzSentryTowerBase expands JazzPlainObjects;

defaultproperties
{
     ObjectMaterial=OBJ_Metal
     ObjectType=OBJ_HighTech
     ObjectDanger=OBJ_Dangerous
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.SentryBase'
     CollisionHeight=30.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
