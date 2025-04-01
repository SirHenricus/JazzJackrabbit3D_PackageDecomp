//=============================================================================
// HidePlayer.
//=============================================================================
class HidePlayer expands Triggers;

function Trigger( actor Other, pawn EventInstigator )
{
	Log("HidePlayer) "$EventInstigator);

	EventInstigator.bHidden = !EventInstigator.bHidden;
}

defaultproperties
{
}
