class Decal expands Actor
	native;

// properties
var int MultiDecalLevel;
var float LastRenderedTime;

// native stuff.
var const array<int> SurfList;

simulated native function bool AttachDecal( float TraceDistance, optional vector DecalDir ); // trace forward and attach this decal to surfaces.
simulated native function DetachDecal(); // detach this decal from all surfaces.

simulated event BeginPlay()
{
	if(!AttachDecal(100))	// trace 100 units ahead in direction of current rotation
		Destroy();
}

simulated event Destroyed()
{
	DetachDecal();
	Super.Destroyed();
}

event Update(Actor L);

defaultproperties
{
     MultiDecalLevel=4
     bHighDetail=True
     bNetTemporary=True
     bNetOptional=True
     RemoteRole=ROLE_None
     DrawType=DT_None
     bGameRelevant=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
