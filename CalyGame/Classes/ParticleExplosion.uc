//=============================================================================
// ParticleExplosion.
//=============================================================================
class ParticleExplosion expands JazzParticles;

function BeginPlay()
{
	PlaySound(sound'explosion', SLOT_None, 2.5);	
}

defaultproperties
{
     DisappearWhenAnimationDone=True
     FadeWhileAnimating=True
     FadeWhenAnimationDone=False
     FloatDownWhenAnimationDone=True
     AnimSequence=exball
     Sprite=Texture'JazzArt.Particles.JazzP12'
     Texture=Texture'JazzArt.Particles.JazzP12'
     Mesh=LodMesh'JazzObjectoids.exball'
     bAlwaysRelevant=False
}
