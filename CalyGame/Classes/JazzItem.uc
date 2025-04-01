//=============================================================================
// JazzItem.
//=============================================================================
class JazzItem expands Pickup;

// Basic values
// 
var(JazzItem) int	ItemScoreValue;
var(JazzItem) name  PickupEventSet;		// Set game level event when this is picked up?
var(JazzItem) bool	LevelSpecialItem;	// This is an item that belongs to a level.
var(JazzItem) name	LevelName;			// Set this to the name of the level to be used in.

var(JazzItem) bool	Unique;				// Set this to true in the rare case that an item should be unique.
var(JazzItem) name	UniqueName;			// Each item needs a unique name to check if it should be killed.

var(JazzItem) bool  NoNewDisplay;		// Do not do a new inventory display on the HUD

var(JazzItem) class<actor> PickupSpecialEffect;	// Special effect when item is picked up

var(JazzItem) bool		Bobbing; 	// Patch change - the new bobbing effect for making the items look even cooler!
var 		  float		BobDir; 	// Same as above - needed;
var			  vector 	Bob; 		// Same as above - needed;
var			  vector	OrigLoc;

//var(JazzItem) bool  Tutorial;			// Display the tutorial text
//var(JazzItem) string[200] TutorialText;	// Text to display when item found.

function BeginPlay()
{
	if (Bobbing == True)
	{ OrigLoc = location;
	BobDir = rand(65536); }
}

// Add ItemScoreValue to a pawn's scores
//
function AddScore ( pawn Other )
{
	if (JazzPlayer(Other) != None)
	{
		JazzPlayer(Other).AddScore(ItemScoreValue);
	}
	else
	if (JazzPawn(Other) != None)
	{
		JazzPawn(Other).PlayerReplicationInfo.Score += ItemScoreValue;	// 220 Version
	}
}

//
// Advanced function which lets existing items in a pawn's inventory
// prevent the pawn from picking something up. Return true to abort pickup
// or if item handles the pickup
//
function bool HandlePickupQuery( inventory Item )
{
	if (item.class == class) 
	{
		if (bCanHaveMultipleCopies) 
		{   // for items like Artifact
			NumCopies++;
			Item.PlaySound (Item.PickupSound,,2.0);
			Item.SetRespawn();
		}
		else if ( bDisplayableInv ) 
		{		
			if ( Charge<Item.Charge )	
				Charge= Item.Charge;
			Item.PlaySound (PickupSound,,2.0);
			Item.SetReSpawn();
		}
		return true;				
	}
	if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}


function PickupFunction( pawn Other )
{
	// Add Event?
	if (PickupSpecialEffect != None)
	{
		Spawn(PickupSpecialEffect);
	}
	
	// Unique Check
	if (Unique == true)
	{
		if (JazzPlayer(Other) != None)
			JazzPlayer(Other).AddEventDone(UniqueName);		
	}
	
	//
	if (PickupEventSet != '')
	{
		if (JazzPlayer(Other) != None)
			JazzPlayer(Other).AddEventDone(PickupEventSet);
	}
	
	// New Inventory Display?
	if (NoNewDisplay==false)
	{
		if (JazzPlayer(Other) != None)
		NewInventory( Other );
	}
}

function NewInventory ( actor Other )
{
	JazzHUD(JazzPlayer(Other).myHUD).NewItemStart(Self,PickupMessage);
}

defaultproperties
{
}
