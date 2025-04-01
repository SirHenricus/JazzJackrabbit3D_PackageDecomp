//=============================================================================
// TurtleExplosion.
//=============================================================================
class TurtleExplosion expands JazzAnimations;

defaultproperties
{
     AnimSequence=TurtleUnhide
     DrawType=DT_Mesh
     Texture=Texture'JazzEnemy.Skins.Jturtle_01'
     Mesh=LodMesh'JazzEnemy.Turtle1'
     CollisionRadius=4.000000
     CollisionHeight=4.000000
     bCollideActors=True
     bCollideWorld=True
     bBounce=True
     RotationRate=(Pitch=65536,Yaw=65536,Roll=65536)
}
