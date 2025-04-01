//=============================================================================
// RocketShoes.
//=============================================================================
class RocketShoes expands JazzVehicle;

function AcceptPlayerRotation( rotator NewRotation )
{
	NewRotation.Yaw += 16384;
	Super.AcceptPlayerRotation(NewRotation);
}

defaultproperties
{
     AnimSequence=Open
     DrawScale=0.500000
}
