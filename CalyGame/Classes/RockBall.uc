//=============================================================================
// RockBall.
//=============================================================================
class RockBall expands JazzEffects;

simulated event Tick(float DeltaTime)
{
	if(Owner != None)
	{
		SetLocation(Owner.Location);
		SetRotation(Owner.Rotation);
	}
	else
	{
		Destroy();
	}
}

defaultproperties
{
     LifeSpan=140.000000
     AnimSequence=Pos3
     DrawType=DT_Mesh
     Style=STY_Translucent
     DrawScale=0.500000
}
