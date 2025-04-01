//=============================================================================
// LockPlayer.
//=============================================================================
class LockPlayer expands Triggers;

// Patch change - this is a new actor that can both hide and lock the player object entirely!
// Don't forget to set it off by changing the On/Off varialbe!

var()	bool	Unlock;
var()	bool	Hide;

function Touch( actor Other )
{
	local JazzPlayer	A;
	local JazzHUD		HUD;
	
	if (other.isA('JazzPlayer'))
	{	
		foreach AllActors( class 'JazzPlayer', A )
		{
			if (Unlock == True)
			{
				A.ReturnToNormalState();
				A.bHidden = False;
				foreach AllActors( class 'JazzHUD', HUD )
				{ HUD.bHidden = False; }
			}
			else
			{
				A.GotoState('Locked');
				A.Velocity = vect(0,0,0);
				if (Hide == True)
				{
					A.bHidden = True;
					foreach AllActors( class 'JazzHUD', HUD )
					{ HUD.bHidden = True; }
				}
			}
		}
	}
}

defaultproperties
{
     Texture=Texture'Engine.S_Trigger'
}
