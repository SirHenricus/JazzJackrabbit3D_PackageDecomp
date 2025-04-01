//=============================================================================
// DummyWaitingJazz.
//=============================================================================
class DummyWaitingJazz expands JazzPlainObjects;

//
// This is an unscripted dummy Jazz who just stands there.  Intended to be used for
// displays or something - not in-game.
// 
//

//function PreBeginPlay()
//{
	//LoopAnim('JazzRun');
//}

defaultproperties
{
     AnimSequence=jazzidle1
     AnimRate=1.000000
     DrawType=DT_Mesh
     Texture=Texture'Jazz3.jazz_green_rb'
     Mesh=LodMesh'Jazz3.Jazz'
     CollisionHeight=44.000000
}
