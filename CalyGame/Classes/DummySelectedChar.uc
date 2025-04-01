//=============================================================================
// DummySelectedChar.
//=============================================================================
class DummySelectedChar expands JazzPlainObjects;

// Patch change - a new object intended to be used specifically for 
// the character selection screen at the main menu.
// It's pretty much the same as DummyWaitingJazz, but I decided to have a specific object for this.

function PreBeginPlay()
{ LoopAnim('JazzRun'); }

defaultproperties
{
     Physics=PHYS_Rotating
     AnimSequence=jazzrun
     AnimRate=1.000000
     Rotation=(Yaw=-40)
     bDirectional=True
     DrawType=DT_Mesh
     Texture=Texture'Jazz3.jazz_green_rb'
     Mesh=LodMesh'Jazz3.Jazz'
     CollisionHeight=44.000000
     bFixedRotationDir=True
     RotationRate=(Yaw=30000)
}
