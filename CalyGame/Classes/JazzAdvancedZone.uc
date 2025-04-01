//=============================================================================
// JazzAdvancedZone.
//=============================================================================
class JazzAdvancedZone expands ZoneInfo;

//
// Contains additions to the ZoneInfo for certain Jazz features.
//

var() bool	NoLedgeGrab;		// Cannot use ledge grab in this zone

var(FootSteps) sound JazzFootStep;		// leave 'none' if default is to be used

defaultproperties
{
}
