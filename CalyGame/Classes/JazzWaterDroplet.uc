//=============================================================================
// JazzWaterDroplet.
//=============================================================================
class JazzWaterDroplet expands JazzEffects;


simulated function HitWall (vector HitNormal, actor Wall)
{	
	Destroy();
}

simulated function Touch (actor Other)
{
	Destroy();
}

simulated event ZoneChange(ZoneInfo NewZone)
{
	if(NewZone.bWaterZone)
	{
		Destroy();
	}
}

defaultproperties
{
     Physics=PHYS_Falling
     LifeSpan=60.000000
     Style=STY_Translucent
     Sprite=Texture'JazzArt.Particles.Droplet'
     Texture=Texture'JazzArt.Particles.Droplet'
     Skin=Texture'JazzArt.Particles.Droplet'
     DrawScale=0.050000
}
