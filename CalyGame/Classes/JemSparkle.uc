//=============================================================================
// JemSparkle.
//=============================================================================
class JemSparkle expands JazzEffects;

simulated function HitWall (vector HitNormal, actor Wall)
{	
	Landed(HitNormal);
}

function Landed (vector HitNormal)
{	
	local vector offset;
	local float Temp;
	
	velocity = vect(0,0,0);				// Reset velocity
	
	DrawScale = FRand()*0.05+0.03;		// Randomize Size
	
	offset = VRand()*10;
	offset.z = 8+FRand()*3;
	SetLocation(Owner.Location+offset);	// Randomize location
	SetPhysics(PHYS_Projectile);
	
	Temp = -20-FRand()*20;				// Randomize acceleration down (hacked gravity)
	offset = vect(0,0,0);
	offset.z = Temp;
	acceleration = offset;
}

simulated function Touch (actor Other)
{
	Landed(vect(0,0,0));
}
simulated function Bump (actor Other)
{
	Landed(vect(0,0,0));
}

defaultproperties
{
     bCanTeleport=True
     bTravel=True
     bNetOptional=True
     Physics=PHYS_Falling
     Style=STY_Translucent
     Sprite=Texture'JazzAnimated.sparkanim1a'
     Texture=Texture'JazzAnimated.sparkanim1a'
     DrawScale=0.050000
     bAlwaysRelevant=False
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     bCollideWorld=True
}
