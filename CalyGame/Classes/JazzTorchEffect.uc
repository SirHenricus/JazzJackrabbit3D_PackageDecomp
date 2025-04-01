//=============================================================================
// JazzTorchEffect.
//=============================================================================
class JazzTorchEffect expands JazzFireEffect;

simulated event Timer()
{
	local vector NewVel;
	local TorchCircle Fire;
	local int x;
	
	CurCycle -= 0.1;
	
	if (JazzPawn(Owner) != None && !bStationary)
	{
	  if (JazzPawn(Owner).Health<=0)
	  Destroy();
	}
		
	for(x=Intensity; x > 0; x--)
	{
		NewVel = VRand() * Spread;

		if(bFollow)
		{
		    if (Owner==NONE) destroy();
			//NewVel += Owner.Velocity;
		}
		
		NewVel.Z = ZVel;

		Fire = TorchCircle(spawn(FireEffect,None));
		Fire.Velocity = NewVel;
		Fire.MaxLifeSpan = Cycle + (0.4*FRand() - 0.2);
		Fire.SetTimer(Fire.MaxLifeSpan, false);
		Fire.MaxDrawScale = InitalDraw;
		Fire.LastOwnerLocation = Location;
		Fire.ZVel = ZVel;
		Fire.Spread = Spread;
		Fire.Cycle = Cycle;
	}
	
	if(CurCycle <= 0)
	{
		SetTimer(-1.0,false);
		Destroy();
	}
}

defaultproperties
{
     FireEffect=Class'CalyGame.TorchCircle'
     Spread=75.000000
     ZVel=70.000000
     DrawScale=0.250000
}
