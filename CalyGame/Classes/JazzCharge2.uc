//=============================================================================
// JazzCharge2.
//=============================================================================
class JazzCharge2 expands JazzNormal;

defaultproperties
{
     InitialVelocity=1000.000000
     ImpactDamage=30
     ProjectileTrail=Class'CalyGame.YellowCircle'
     TrackingAmount=2.000000
     TrackingPingTime=1.000000
     SpawnSound=Sound'JazzSounds.Weapons.supergun'
     DrawType=DT_Mesh
     Texture=Texture'JazzArt.Particles.NormCh1'
     Skin=Texture'JazzArt.Particles.NormCh1'
     Mesh=LodMesh'JazzObjectoids.wcell'
     DrawScale=0.150000
     AmbientGlow=255
     bUnlit=True
     CollisionRadius=30.000000
     CollisionHeight=40.000000
     LightBrightness=153
     LightHue=51
     LightSaturation=204
     LightRadius=7
     RotationRate=(Yaw=10000)
}
