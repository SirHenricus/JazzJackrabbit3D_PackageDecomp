//=============================================================================
// JazzEffects.
//=============================================================================
class JazzEffects expands Actor;

//simulated final function RandSpin(float spinRate)
function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;	
}

defaultproperties
{
     bAlwaysRelevant=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
