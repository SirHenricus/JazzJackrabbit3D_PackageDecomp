//=============================================================================
// RainDrop.
//=============================================================================
class RainDrop expands JazzWeatherObjects;


function Touch (Actor Other)
{
	Destroy();
}

event Landed( vector HitNormal )
{
	Destroy();
}

defaultproperties
{
     bStasis=True
     Physics=PHYS_Falling
     LifeSpan=5.000000
     Velocity=(Z=200.000000)
     Style=STY_Masked
     Sprite=Texture'JazzArt.Weather.DevRain'
     Texture=Texture'JazzArt.Weather.DevRain'
     bNoSmooth=True
     bAlwaysRelevant=False
     CollisionRadius=1.000000
     CollisionHeight=10.000000
     bCollideActors=True
     bCollideWorld=True
}
