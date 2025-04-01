//=============================================================================
// HealthCarrot.
//=============================================================================
class HealthCarrot expands JazzCarrotBase;

// Orange Carrot		Common
// -------------
//
// Increases Player's Health
// +8 HP
//
var(JazzCarrot) int	HealingAmount;

function DoPickupEffect( pawn Other )
{
	// Is a player?
	if (JazzPlayer(Other)!=None)
	{	
		JazzPlayer(Other).AddHealth(HealingAmount);
		JazzPlayer(Other).EatFood(false);
	}
	else
	if (JazzPawnAI(Other)!=None)
	{
		JazzPawnAI(Other).Health += HealingAmount;
		if (JazzPawnAI(Other).Health > JazzPawnAI(Other).Default.Health)
		JazzPawnAI(Other).Health = JazzPawnAI(Other).Default.Health;
	}
}

// Validate touch, and if valid trigger event.
auto state Pickup
{
	function Touch( actor Other )
	{
		if (JazzPlayer(Other) != None)
		{
			if (!JazzPlayer(Other).NeedHealth())
			return;
		}
		
		if ( ValidTouch(Other) ) 
		{
			if (PickupDelay<=0)
			{
			DoPickupEffect(Pawn(Other));
			PickupFunction(Pawn(Other));
			
			SetRespawn();
			}
		}
	}
}



	
////////////////////////////////////////////////////////////////////////////////////////
// Desirability of the Item
////////////////////////////////////////////////////////////////////////////////////////
//
// See JazzPawnAI for Details
//
function float BotDesireability( pawn Bot )
{
	// Health Desirability
	if (Bot.Default.Health<=0)							// Bot has no health
	return (-1);
	else
	return ((1-float(Bot.Health) / float(Bot.Default.Health))*150);	// Bot 0-150 Desirability
}

defaultproperties
{
     HealingAmount=8
     ItemName="Carrot"
     PlayerViewMesh=LodMesh'JazzObjectoids.Carrot'
     PlayerViewScale=3.000000
     PickupViewMesh=LodMesh'JazzObjectoids.Carrot'
     PickupViewScale=1.500000
     PickupSound=Sound'JazzSounds.Items.carrotmunch'
     Physics=PHYS_Rotating
     Texture=None
     Mesh=LodMesh'JazzObjectoids.Carrot'
     DrawScale=1.500000
     CollisionHeight=60.000000
     RotationRate=(Yaw=40000)
}
