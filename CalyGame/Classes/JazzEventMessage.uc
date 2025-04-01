//=============================================================================
// JazzEventMessage.
//=============================================================================
class JazzEventMessage expands Triggers;

var() string		EventMessage;			// Message to display.

//
// Display message when triggered.
//
function Trigger( actor Other, pawn EventInstigator )
{
	local JazzPlayer A;

	if (EventMessage != "")
	{
		// Display message for all JazzPlayers in level.
		//
		foreach AllActors( class 'JazzPlayer', A )
			A.ScreenMessage(EventMessage);
	}
}

defaultproperties
{
}
