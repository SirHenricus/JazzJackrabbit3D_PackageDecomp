//=============================================================================
// CreateItem.
//=============================================================================
class CreateItem expands Triggers;

var() class	ItemToCreate;

// Create object here when triggered.
//
function Trigger( actor Other, pawn EventInstigator )
{
	if (ItemToCreate != None)
	{
	GotoState('Spawning');
	}
}

state Spawning
{
	Begin:

	Sleep(frand()*3);
	
	// Create item on spot
	Spawn(class<actor>(ItemToCreate),,,Location);
		
	// Teleport in visual effect
	Spawn(class'SpritePoofiePurple',,,Location);
	PlaySound(sound'item1',,,,,Frand()*1.0+0.4);
}

defaultproperties
{
     Texture=Texture'JazzArt.Interface.JazzGem'
}
