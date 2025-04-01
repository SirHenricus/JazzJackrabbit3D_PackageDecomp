//=============================================================================
// JTargeting.
//=============================================================================
class JTargeting expands JazzEffects;

simulated function Target()
{
	local vector HitLocation, HitNormal, End;
	local actor Hit;
	
	End = Owner.Location + (vect(2000,0,0) >> JazzPlayer(Owner).MyCameraRotation)+vect(0,0,200);
	
	Hit = Trace(HitLocation, HitNormal,End,Owner.Location+vect(0,0,200), true);
	
	if(Hit == None)
	{
		SetLocation(End);
	}
	else
	{
		SetLocation(HitLocation);
	}
}
// ?? This seems to have been taken out
//
simulated function Tick(float DealtTime)
{
	local vector HitLocation, HitNormal, End;
	local actor Hit;
	
	if ((Owner==None) || (PlayerPawn(Owner)==None))
	{
		if(Owner==None)
		{
			Destroy();
		}
		return;
	}
		
	// If the owner is hidden, we don't want to see the targeting dot.	
	bHidden = Owner.bHidden;
	
	End = Owner.Location + (vect(2000,0,0) >> JazzPlayer(Owner).MyCameraRotation)+vect(0,0,200);
	
	Hit = Trace(HitLocation, HitNormal,End,Owner.Location+vect(0,0,100), true);
	
	if(Hit == None)
	{ SetLocation(End);	}
	else
	{ SetLocation(HitLocation);	}

	// Patch change - Let's change the draw scale all the time, so the crosshair looks the same size at all times
	DrawScale = 1+VSize(Owner.Location-HitLocation)*0.001;
}

defaultproperties
{
     bNetOptional=True
     RemoteRole=ROLE_SimulatedProxy
     Style=STY_Translucent
     Texture=None
     DrawScale=0.200000
     bOnlyOwnerSee=True
}
