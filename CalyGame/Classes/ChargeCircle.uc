//=============================================================================
// ChargeCircle.
//=============================================================================
class ChargeCircle expands SpritePoofie;

var float  MaxRadius;
var vector Realative;
var() float  ParticleSize;

simulated function Reset()
{
	local float Vel;
	
	if (JazzChargeEffect(Owner) != None)
	{
		if(JazzChargeEffect(Owner).bActive == FALSE)
		{
			End();
			return;
		}

		// CALYCHANGE
		// Start radius from owner - used for size calculation
		MaxRadius = JazzChargeEffect(Owner).AffectRadius;
		
		Realative = VRand() * JazzChargeEffect(Owner).AffectRadius;	
		
		Vel = (JazzChargeEffect(Owner).CurVel - (FRand()*(JazzChargeEffect(Owner).CurVel/4) - (JazzChargeEffect(Owner).CurVel/2)));
		
		if(Vel < JazzChargeEffect(Owner).InitPartVel)
		{
			Vel = JazzChargeEffect(Owner).InitPartVel;
		}
	}
		
	Velocity = -1 * Normal(Realative) * Vel;
	
	self.DrawType = DT_Sprite;
	
	SetTimer(VSize(Realative)/VSize(Velocity),false);
}

simulated event Tick(float DeltaTime)
{
	if(DrawType == DT_None)
	{
		return;
	}
	
	Realative += Velocity*DeltaTime;
	
	if (JazzChargeEffect(Owner) != None)
	{
		if(JazzChargeEffect(Owner).bActive == FALSE)
		{
			End();
		}
	
		SetLocation(JazzChargeEffect(Owner).Location + Realative);
	}
	
	// CALYCHANGE
	// Make particle grow larger as it comes closer to the owner
	DrawScale = ParticleSize * (Default.DrawScale*(1-VSize(Realative)/MaxRadius));
}

simulated event Timer()
{
	Reset();
}

simulated function End()
{
	bHidden = true;
	DrawType = DT_None;
	Velocity = vect(0,0,0);
}

defaultproperties
{
     ParticleSize=1.000000
     LifeSpan=0.000000
     DrawType=DT_None
     DrawScale=0.100000
}
