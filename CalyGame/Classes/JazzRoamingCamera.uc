//=============================================================================
// JazzRoamingCamera.
//=============================================================================
class JazzRoamingCamera expands JazzFixedCamera;

var()	float	RoamingDistance;	// Maximum distance the camera roams
var()	vector	StartLocation;
var()   vector MyLocation;

/*function BeginPlay()
{
	SetTimer(0.05,true);
	StartLocation = Location;
	MyLocation = Location;
}

event Timer ()
{
	SetLocation( MyLocation + 
	
				vect(0,0,1)*sin(Level.TimeSeconds/2)*RoamingDistance + 
				vect(1,0,0)*cos(Level.TimeSeconds/2)*RoamingDistance*1.03 +
				vect(0,1,0)*sin(Level.TimeSeconds/2)*RoamingDistance*1.09
				);
}*/

defaultproperties
{
}
