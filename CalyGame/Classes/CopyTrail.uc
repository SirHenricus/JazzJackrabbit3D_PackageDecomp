//=============================================================================
// CopyTrail.
//=============================================================================
class CopyTrail expands ParticleTrails;

// EffectFreqency overrides TrailFrequency
//
function Activate	(optional float EffectFrequency, optional float Duration)
{
	if (EffectFrequency > 0)
	{
		TrailFrequency = EffectFrequency;
	}
	else
		TrailFrequency = Default.TrailFrequency;
			
	if (Duration > 0)
	{
		LifeSpan = Duration;
	}
		
	GotoState('TrailOn');
}

auto state TrailOn
{
	// Draw Effect Again
	//
	function CopyEffect()
	{
		local Actor Image;

		if ((Owner == None) || (Owner.Name == 'None'))
		Destroy();

		Image = spawn(class<actor>(TrailActor),Owner);

		Image.DrawScale 	= Owner.DrawScale;
		Image.DrawType 		= Owner.DrawType;
		Image.AnimSequence 	= Owner.AnimSequence;
		Image.AnimRate 		= Owner.AnimRate;
		Image.AnimFrame 	= Owner.AnimFrame;
		Image.Skin 			= Owner.Skin;
		Image.Sprite 		= Owner.Sprite;
		Image.Texture 		= Owner.Texture;
		Image.Mesh 			= Owner.Mesh;
		Image.LifeSpan		= 1;
		Image.SetLocation( Owner.Location );
		
		if (RandomizeTrailActorFacing)
		{
			Image.SetRotation(RotRand(true));
		}
	}

	event Timer()
	{
		local int x;
		for (x=0; x<=TrailAmount; x++)
		CopyEffect();
	}
}

defaultproperties
{
     TrailFrequency=0.100000
     TrailActor=Class'CalyGame.JazzPlayerTrailImage'
}
