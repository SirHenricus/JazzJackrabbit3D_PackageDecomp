//=============================================================================
// JazzCharge3.
//=============================================================================
class JazzCharge3 expands JazzNormal;

defaultproperties
{
     InitialVelocity=700.000000
     ImpactDamage=50
     ExplosionWhenHit=Class'CalyGame.YellowCircleTiny'
     ProjectileTrail=Class'CalyGame.YellowCircle'
     TrackingAmount=4.000000
     TrackingPingTime=0.500000
     SpawnSound=Sound'JazzSounds.Weapons.supergun'
     DrawType=DT_Mesh
     Sprite=Texture'JazzArt.Particles.NormCh1'
     Texture=Texture'JazzArt.Particles.NormCh1'
     Mesh=LodMesh'JazzObjectoids.wcell'
     CollisionRadius=30.000000
     CollisionHeight=50.000000
     LightBrightness=153
     LightHue=51
     LightSaturation=102
     LightRadius=7
}
