//=============================================================================
// HuntGem.
//=============================================================================
class HuntGem expands JazzPickupItem;

var() int GemValue;

var JemSparkle Sparks[10];

//
// NOTE:
// Base Gem worth 50 pts
//

simulated function PostBeginPlay()
{
	if(TreasureHunt(Level.Game) == None)
	{
		Self.Destroy();
	}
}

function DoPickupEffect( pawn Other )
{
	THPlayerReplicationInfo(JazzPlayer(Other).PlayerReplicationInfo).GemNumber += GemValue;
	Self.Destroy();

	Super.DoPickupEffect(Other);
}

////////////////////////////////////////////////////////////////////////////////////////
// Desirability of the Item
////////////////////////////////////////////////////////////////////////////////////////
//
// See JazzPawnAI for Details
//
function float BotDesireability( pawn Bot )
{
	// For now let's give the desiHealth Desirability
	//
	return (10);
}

defaultproperties
{
     GemValue=50
     ItemScoreValue=100
     Bobbing=True
     PlayerViewMesh=LodMesh'JazzObjectoids.gem'
     PickupViewMesh=LodMesh'JazzObjectoids.gem'
     PickupViewScale=0.500000
     bCollideWhenPlacing=True
     Style=STY_Translucent
     Texture=Texture'JazzSpecial.gem1_01'
     Mesh=LodMesh'JazzObjectoids.gem'
     DrawScale=0.400000
}
