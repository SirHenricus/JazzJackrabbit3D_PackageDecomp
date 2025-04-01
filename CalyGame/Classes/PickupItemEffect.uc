//=============================================================================
// PickupItemEffect.
//=============================================================================
class PickupItemEffect expands JazzEffects;

// USAGE
// An interesting item has just been picked up and we want to reward the player visually.
//

// Patch change - this object has been modified for the new pickup effect

var() class<actor>	SparkleClass;
var() int		SparkleNumber;
//var	  int		CurSparkles;
var() float		FloatAcceleration;		// Downward acceleration of sparkles
var() float		TimeBetweenSparkles;
var() float		SparkleRadius;

//var	  Actor		Sparkles[10];
var 	PickupParticle		Sparkles;

function BeginPlay()
{
	local int i;
	for(i = SparkleNumber; i > 0; i--)
	{
		Sparkles=Spawn(class'PickupParticle',self);
		Sparkles.NewLocation = Location;
		Sparkles.SetOwner(Owner);
	}

	/*local int x;

	if (SparkleNumber>9) SparkleNumber=9;
	
	SetTimer(TimeBetweenSparkles,true);
	
	CurSparkles = 0;*/
}

/*event Timer ( )
{
	local vector NewLocation;

	if (CurSparkles < SparkleNumber)
	{
		CurSparkles++;
		Sparkles[CurSparkles]=spawn(SparkleClass,,,Location+VRand()*SparkleRadius*FRand());
		Sparkles[CurSparkles].SetPhysics(PHYS_Projectile);
	}
	else
	SetTimer(999,false);
}

event Destroyed()
{
	local int x;
	for (x=0; x<=CurSparkles; x++)
	{
		if (Sparkles[x] != None)
		Sparkles[x].Destroy();
	}
}*/

defaultproperties
{
     bHidden=True
     LifeSpan=5.000000
     bParticles=True
     VisibilityRadius=5.000000
     VisibilityHeight=5.000000
}
