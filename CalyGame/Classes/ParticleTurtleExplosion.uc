//=============================================================================
// ParticleTurtleExplosion.
//=============================================================================
class ParticleTurtleExplosion expands JazzParticles;

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
     Sprite=Texture'Jazzytextures2.corona3'
     Texture=Texture'Jazzytextures2.corona3'
     Mesh=LodMesh'JazzObjectoids.exball'
}
