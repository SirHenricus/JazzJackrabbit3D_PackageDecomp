//=============================================================================
// GlowingPurchaseObject.
//=============================================================================
class GlowingPurchaseObject expands JazzGameObjects;

var() class<inventory>	AddInventory;
var() bool				InventoryUnique;	// Can't buy two
var() int				CostInCoins;
var() string			NameOfItem;

// 
// Purchase objects should detect when a player is within a certain
// range and display the price of the object.
//
// When moving in close and pressing the main (attack) button, the object is purchased.
//

//----
// Using Purchase Objects
//----
//
// Place the GlowingPurchaseObject actor in the location that you want.  There are a few provided object types
// which you may choose from already, such as for carrots or the missile launcher.
//
// The actor will take care of itself, though you need to tell it a few things in the GlowingPurchaseObject
// group of the parameters for the actor.
//
// AddInventory - Inventory class to add to the player
//    In cases like the carrot, the purchase function is overridden to simply add more health.
//
// InventoryUnique - Is this a unique item?  If so, it won't let you buy another one.
//
// CostInCoins - Number of coins to spend to purchase item.
//
// NameOfItem - Text Name for the item.  This can be anything you want, just don't make it too long.
//
// Display Properties - The mesh and textures should be set to how the object will appear when rotating around.
//
//-----


function bool ValidPurchase ( actor Other )
{
	// Check cost against player amounts
	//
	if (JazzPlayer(Other).Carrots<CostInCoins)
	return(false);
	else
	return(true);
}

function DoPurchase( actor Other )
{
	local inventory I;

	// Check if unable to purchase
	if (ValidPurchase(Other)==false)
	{
		PlaySound(sound'menuweird');
		return;
	}

	// Remove object from sale?
	//
	
	
	// Check if Player Already has item?
	// 
	if (InventoryUnique)
	if (Pawn(Other) != None)
	{
		if (Pawn(Other).FindInventoryType(AddInventory) != None)
		{
			PlaySound(sound'menuweird');
			return;	
		}
	}
		
	// Add Item to Player
	//
	if (AddInventory != None)
	{
		I = spawn(AddInventory);
		I.GiveTo(Pawn(Other));
	}
	
	// Purchase Function
	//
	PurchaseFunction(Other);

	// Decrease cost
	// 
	JazzPlayer(Other).Carrots -= CostInCoins;

	// Do Special Effect
	//
	spawn(class'SpritePoofiePurple');
	//PlaySound(sound'item1');
	PlaySound(sound'purchase');
}

// What to do to the player when a purchase is done
function PurchaseFunction( actor Other )
{
}

// Begin purchase
event Touch( Actor Other )
{
	if (JazzPlayer(Other) != None)
	{
		PlaySound(sound'onpurchase');
		JazzHud(JazzPlayer(Other).MyHud).StartPurchase(Self);
	}
}

// End purchase
event UnTouch( Actor Other )
{
	if (JazzPlayer(Other) != None)
	{
		JazzHud(JazzPlayer(Other).MyHud).PurchaseEnd();
	}
}

defaultproperties
{
     bCollideActors=True
     LightType=LT_Steady
     LightBrightness=153
     LightHue=153
     LightSaturation=51
     LightRadius=5
     VolumeBrightness=23
     VolumeRadius=2
     VolumeFog=21
}
