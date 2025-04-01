//=============================================================================
// ParticleLizardExplosion.
//=============================================================================
class ParticleLizardExplosion expands JazzParticles;

function BeginPlay()
{
	PlaySound(sound'enemyexpl');
}

defaultproperties
{
     DisappearWhenAnimationDone=True
     FadeWhileAnimating=True
     FadeWhenAnimationDone=False
     FloatDownWhenAnimationDone=True
     FadeTime=0.500000
     AnimSequence=exball
     Sprite=Texture'JazzArt.Particles.JazzP10'
     Texture=Texture'JazzArt.Particles.JazzP10'
     Mesh=LodMesh'JazzObjectoids.exball'
}
