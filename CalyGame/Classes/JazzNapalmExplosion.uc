//=============================================================================
// JazzNapalmExplosion.
//=============================================================================
class JazzNapalmExplosion expands JazzWeaponEffects;

function BeginPlay()
{
	//local ParticleExplosion P;
	local JazzNapalmSmall Chunk;
	local int X;

	// 1. Napalm Explosion
	spawn(class'ParticleExplosion');
	//P.Texture = texture'JazzP7';
	
	// 2. Napalm Burst Fireballs
	for (X=0; X<4; X++)
	{
		Chunk = spawn(class'JazzNapalmSmall',,,Location);
		Chunk.Velocity = VRand() * 500;
	}
	
	Destroy();
}

defaultproperties
{
}
