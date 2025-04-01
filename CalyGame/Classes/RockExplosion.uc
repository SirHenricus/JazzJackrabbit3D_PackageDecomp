//=============================================================================
// RockExplosion.
//=============================================================================
class RockExplosion expands JazzSmoke;

function BeginPlay()
{
	PlaySound(sound'RockBreak');
}

defaultproperties
{
     DrawScale=3.000000
     bParticles=True
}
