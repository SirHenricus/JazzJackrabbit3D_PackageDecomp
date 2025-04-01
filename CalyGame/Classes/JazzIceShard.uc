//=============================================================================
// JazzIceShard.
//=============================================================================
class JazzIceShard expands JazzProjectile;

//
// Fires bolt of ice which hits and slows down an enemy for a short period of 
// time.  Does not freeze.
//

defaultproperties
{
     InitialVelocity=1000.000000
     ImpactDamage=15
     ImpactDamageType=Cold
     ExplosionWhenHit=Class'CalyGame.JazzShotRicochetIce'
     ForceExplosionSound=Sound'JazzSounds.Weapons.richochet1'
     ProjectileTrail=Class'CalyGame.SpritePoofieSmallBlue'
     SpawnSound=Sound'JazzSounds.Weapons.iceshot2'
     Mesh=LodMesh'JazzObjectoids.iceshard'
}
