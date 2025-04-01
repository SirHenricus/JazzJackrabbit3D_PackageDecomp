//=============================================================================
// JazzGemTrigger.
//=============================================================================
class JazzGemTrigger expands JazzGameObjects;

//
// If a player touches this, check how much money or whatnot they have and determine if they can 
// pass.
//
//
function Touch( actor Other )
{
	local Actor A;

	//Log("LevelGem) Check for Gem : "$Other$" "$JazzPlayer(Other).LevelGems);

	// Check if player
	if (JazzPlayer(Other) != None)
	{
		// Check for LevelGem
		if (JazzPlayer(Other).LevelGems > 0)
		{
			// Have Gem - Do Trigger
			JazzPlayer(Other).LevelGems -= 1;

			//Log("LevelGem) Start");
			
			// Do Trigger
			if( Event != '' )
			{
				foreach AllActors( class 'Actor', A, Event )
				{		
					//Log("LevelGem) Actor "$A);
					A.Trigger( Other, Other.Instigator );
				}
			}
					
			Destroy();
		}
		else
		{	
			// No Gem - Do Tutorial
			JazzPlayer(Other).TutorialCheck(TutorialLevelGem);
		}
	}
}

defaultproperties
{
     bHidden=True
     Event=LevelGem
     Style=STY_Translucent
     Texture=Texture'JazzArt.Interface.Team2'
     DrawScale=0.200000
     bCollideActors=True
     LightType=LT_Pulse
     LightEffect=LE_Cylinder
     LightBrightness=255
     LightHue=51
     LightRadius=3
     LightPeriod=102
}
