//=============================================================================
// JazzSign.
//=============================================================================
class JazzSign expands JazzGameObjects;

//
// Place a sign down and put this actor in or on it directly.
//
// (This could be modified for things other than signs, of course.)
//

// Patch change - Ignore the above-stated. JazzSign now is the actual sign object!
// I did it because the camera will change it's position once it is activated.
// This can easily be made invisible to do exactly the same stuff stated before, but by default this actor is visible
// as a sign mesh!

var() string	SignText;

// Activate by Trigger?
//
event Trigger ( actor Other, pawn EventInstigator )
{
	if (JazzPlayer(EventInstigator) != None)
	{
		JazzPlayer(EventInstigator).NewTutorial(SignText,"",true);
	}
}

defaultproperties
{
     ActivationObject=True
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.sign'
     DrawScale=3.000000
     CollisionRadius=30.000000
     CollisionHeight=30.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
