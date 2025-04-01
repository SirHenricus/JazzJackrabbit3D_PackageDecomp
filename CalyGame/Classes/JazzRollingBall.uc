//=============================================================================
// JazzRollingBall.
//=============================================================================
class JazzRollingBall expands JazzMotionObjects;

defaultproperties
{
     bPushable=True
     Physics=PHYS_Rolling
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.rock1'
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     RotationRate=(Pitch=100)
}
