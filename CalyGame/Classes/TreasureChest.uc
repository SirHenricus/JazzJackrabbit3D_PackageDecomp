//=============================================================================
// TreasureChest.
//=============================================================================
class TreasureChest expands ItemContainer;

// Item Container opened by trigger
//
function OpenTrigger ()
{
	if (!Open)
	{
		ReleaseAll();
	
		// Open animation
		//
		PlaySound(sound'ChestCreak');
		PlayAnim('ChestOpen');
		AnimRate = 0.6;
		Open = true;
		ActivationObject = False; // Patch change - No longer display the activation icon if the chest is open
	}
}

// Item Container opened by shooting/attacking
//
function OpenDestroy ()
{
	OpenTrigger();
}

defaultproperties
{
     Health=20
     Release=REL_Left
     ActivationObject=True
     floatAnimation=True
     bPushable=True
     PushSound=Sound'JazzSounds.Event.elevloop2'
     SpinOnSides=True
     AlignToFloor=True
     LODBias=5.000000
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.JChest1_01'
     Mesh=LodMesh'JazzObjectoids.Chest1'
     DrawScale=1.500000
     CollisionRadius=40.000000
     CollisionHeight=31.500000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     Buoyancy=90.000000
}
