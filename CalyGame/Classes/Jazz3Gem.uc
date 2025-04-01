//=============================================================================
// Jazz3Gem.
//=============================================================================
class Jazz3Gem expands JazzPickupItem;

var JemSparkle Sparks[10];

//
// Secret Gem!
//

// Override for specific carrot effect on player/pickupperson as 'Other'
//
// Pickup sound is in (Inventory) section of the actor properties.
//

simulated function PostBeginPlay()
{
	local int x;

	Super.PostBeginPlay();
	
	for(x = 0; x < 10; x++)
	{
		Sparks[x] = Spawn(class'JemSparkle',Self);
		Sparks[x].SetLocation(Location + VRand()*10);
	}	
}

function DoPickupEffect( pawn Other )
{
	local int x;

	Super.DoPickupEffect(Other);
	
	JazzPlayer(Other).LevelGems++;
	
	for(x=0;x<10;x++)
	{
		Sparks[x].Destroy();
	}
}

defaultproperties
{
     ItemScoreValue=100
     Bobbing=True
     PickupMessage="Secret Gem"
     ItemName="Secret Gem"
     PlayerViewScale=0.500000
     PickupViewMesh=LodMesh'JazzObjectoids.gem'
     PickupViewScale=0.500000
     ThirdPersonScale=0.500000
     PickupSound=Sound'JazzSounds.Items.item1'
     Physics=PHYS_Rotating
     Sprite=Texture'Engine.S_Pickup'
     Texture=Texture'Jazzytextures2.goldrefl1b'
     Mesh=LodMesh'JazzObjectoids.gem'
     DrawScale=0.500000
     bMeshEnviroMap=True
     LightType=LT_Steady
     LightBrightness=255
     LightHue=153
     LightSaturation=102
     LightRadius=2
}
