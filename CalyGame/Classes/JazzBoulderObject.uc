//=============================================================================
// JazzBoulderObject.
//=============================================================================
class JazzBoulderObject expands JazzGameObjects;

defaultproperties
{
     Health=30
     Destroyable=True
     DestroySound=Sound'JazzSounds.Weapons.rockbreak'
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.Jplatform_01'
     Mesh=LodMesh'JazzObjectoids.rock1'
     CollisionRadius=30.000000
     CollisionHeight=30.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
