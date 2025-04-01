//=============================================================================
// JazzWarpZoneInfo.
//=============================================================================
class JazzWarpZoneInfo expands WarpZoneInfo;

//
// Fix for weird turning after teleporting
//

simulated function ActorEntered( actor Other )
{
	Super.ActorEntered(Other);
	
	if (JazzPlayer(Other) != None)
	{
		JazzPlayer(Other).ViewRotation.Yaw = JazzPlayer(Other).ViewRotation.Yaw & 65535;
		JazzPlayer(Other).CameraHistory.Yaw = JazzPlayer(Other).ViewRotation.Yaw;
		JazzPlayer(Other).SetRotation(JazzPlayer(Other).ViewRotation);
	}
}

defaultproperties
{
}
