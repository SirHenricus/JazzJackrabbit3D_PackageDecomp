//=============================================================================
// RocketExplosion.
//=============================================================================
class RocketExplosion expands JazzEffects;
var		ExplosionRipple		ExploRing;
var		ParticleExplosion	ExploPart;

simulated event BeginPlay()
{
	local int i;

	for(i = 3; i > 0; i--)
	{ ExploRing = Spawn(class'ExplosionRipple',self); }

	ExploPart = Spawn(class'ParticleExplosion',self);
	Destroy();
}

defaultproperties
{
}
