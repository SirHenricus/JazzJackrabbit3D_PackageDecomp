//=============================================================================
// WavingFlagTwo.
//=============================================================================
class WavingFlagTwo expands WavingFlag;

function PreBeginPlay()
{
	LoopAnim('DiamondFlag');
}

defaultproperties
{
     AnimSequence=DiamondFlag
     Mesh=LodMesh'JazzObjectoids.DiamondFlag'
}
