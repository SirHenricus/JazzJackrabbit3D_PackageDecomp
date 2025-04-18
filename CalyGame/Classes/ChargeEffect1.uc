//=============================================================================
// ChargeEffect1.
//=============================================================================
class ChargeEffect1 expands JazzChargingEffects;

defaultproperties
{
     Animation=Explosion
     ReverseAnimation=True
     ReverseReverseAnimation=True
     AnimationSpeed=0.100000
     AnimationFrames=0.100000
     RotationRoll=40000.000000
     OnSide=True
     RemoteRole=ROLE_Authority
     AnimSequence=expring
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'JazzArt.Particles.JazzP10'
     Mesh=LodMesh'JazzObjectoids.expring'
     DrawScale=0.020000
     bParticles=True
}
