//=============================================================================
// JazzCoin.
//=============================================================================
class JazzCoin expands JazzPickupItem;

var(JazzItem) int	ItemMoneyValue;
//var() 		actor 	OldOwner;


// Override for specific carrot effect on player/pickupperson as 'Other'
//
// Pickup sound is in (Inventory) section of the actor properties.
//
function DoPickupEffect( pawn Other )
{
	//local 	PurpleItemEffect		PickupEffecty;
	local int i;
	local 	PickupParticle		Sparkles;
	
	PlaySound (PickupSound,,2.5);
	
	//PickupEffecty=Spawn(Class'PurpleItemEffect',self);
	//PickupEffecty.SetOwner(Other);

	for(i = 9; i > 0; i--)
	{
		Sparkles=Spawn(class'PickupParticle',self);
		Sparkles.NewLocation = Location;
		if ( ItemMoneyValue == 10 )
		{ Sparkles.texture = Texture'JazzArt.Particles.Jazzp14'; }
		else if ( ItemMoneyValue == 5 )
		{ Sparkles.texture = Texture'JazzArt.Particles.JazzP3'; }
		else if ( ItemMoneyValue == 1 )
		{ Sparkles.texture = Texture'JazzArt.Particles.JazzP10'; }
	}
	
	if (JazzPlayer(Other) != None || JazzThinker(Other) != None)
	{
	
	if(TreasureHunt(Level.Game) != None)
	{
		THPlayerReplicationInfo(Other.PlayerReplicationInfo).GemNumber += ItemMoneyValue;
	}
	else
	{
		JazzPlayer(Other).AddScore(ItemScoreValue);
		JazzPlayer(Other).Carrots += ItemMoneyValue;
		JazzPlayer(Other).UpdateCarrot();
	}
	
	}
	else
	{
		Other.PlayerReplicationInfo.Score += ItemScoreValue;	// 220 Version

		if (JazzPawnAI(Other) != None)
		{
			JazzPawnAI(Other).Carrots += ItemMoneyValue;
		}
	}
	
	if(TreasureHunt(Level.Game) == None)
	{
		SetRespawn();
	}
	else
	{
		Self.Destroy();
	}
}

////////////////////////////////////////////////////////////////////////////////////////
// Base function that determines the desirability of an item for a 'bot' (Thinker)
////////////////////////////////////////////////////////////////////////////////////////
//
// See JazzPawnAI for Details
//
function float BotDesireability( pawn Bot )
{
	return (2);	// Coins aren't really very desirable for thinkers right now - just enough to think about getting one
}

defaultproperties
{
     ItemMoneyValue=1
     ItemScoreValue=10
     NoNewDisplay=True
     Bobbing=True
     ItemName="Coin"
     PlayerViewMesh=LodMesh'JazzObjectoids.coin'
     PlayerViewScale=0.400000
     PickupViewMesh=LodMesh'JazzObjectoids.coin'
     PickupViewScale=0.400000
     PickupSound=Sound'JazzSounds.Items.coingrab'
     Physics=PHYS_Rotating
     LODBias=7.000000
     bDirectional=True
     Texture=Texture'JazzObjectoids.Skins.Jcoin_01'
     Mesh=LodMesh'JazzObjectoids.coin'
     DrawScale=0.400000
     RotationRate=(Yaw=20000)
}
