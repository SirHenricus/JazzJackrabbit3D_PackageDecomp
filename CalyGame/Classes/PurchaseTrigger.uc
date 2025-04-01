//=============================================================================
// PurchaseTrigger.
//=============================================================================
class PurchaseTrigger expands GlowingPurchaseObject;

//-----
// This special type of purchase sends the 'event' trigger to all other actors in the level.
//-----


// What to do to the player when a purchase is done
function PurchaseFunction( actor Other )
{
	local actor A;
	
	// Broadcast the Trigger message to all matching actors.
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Other, Other.Instigator );
}

defaultproperties
{
}
