//=============================================================================
// FireParticleHazard.
//=============================================================================
class FireParticleHazard expands JazzEffects;

var float PTime;

simulated event Tick (float DeltaTime)
{
	local FireParticle Part;
	local vector PartLocation;
	
	PTime += DeltaTime*40;
	if (PTime > 1)
	{
		PartLocation = VRand()*40;
		Part = spawn(class'FireParticle');
		Part.SetLocation(Location+PartLocation);
		PTime = 0;
	}
}

defaultproperties
{
     bHidden=True
     Sprite=Texture'Engine.S_Corpse'
     Texture=Texture'Engine.S_Corpse'
}
