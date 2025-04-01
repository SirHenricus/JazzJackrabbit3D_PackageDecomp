//=============================================================================
// JazzBlueGrenade.
//=============================================================================
class JazzBlueGrenade expands JazzProjectile;

// Bounce
simulated function HitWall( vector HitNormal, actor Wall )
{
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	RandSpin(100000);
	speed = VSize(Velocity);
	if ( Level.NetMode != NM_DedicatedServer )
		PlaySound(ImpactSound, SLOT_Misc, FMax(0.3, speed/1500) );
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
	else if ( speed < 20 ) 
	{
		bBounce = False;
		SetPhysics(PHYS_None);
		Explode(Location,HitNormal);
	}
}

event Destroyed()
{
	super.Destroyed();
	
	if (Live == true)
	PlayHitExplosion();
}

defaultproperties
{
     InitialVelocity=899.000000
     ImpactDamage=20
     ImpactDamageType=Energy
     RadialDamageRadius=10.000000
     ExplosionWhenHit=Class'CalyGame.ParticleExplosion'
     ForceExplosionSound=Sound'JazzSounds.Weapons.bigfire'
     Live=True
     SpawnSound=Sound'JazzSounds.Weapons.gizmo2'
     ImpactSound=Sound'JazzSounds.Weapons.richochet1'
     Physics=PHYS_Falling
     LifeSpan=10.000000
     Texture=None
     Mesh=LodMesh'JazzObjectoids.BounceBomb'
     DrawScale=0.300000
     AmbientGlow=255
     bBounce=True
}
