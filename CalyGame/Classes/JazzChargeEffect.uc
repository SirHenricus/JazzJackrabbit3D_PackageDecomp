//=============================================================================
// JazzChargeEffect.
//=============================================================================
class JazzChargeEffect expands JazzEffects;

var ChargeCircle Particles[50];
var bool bActive;
var float InitPartVel;
var float FinalPartVel;
var float CurVel;
var float ChargeTime;
var float CurLife;
var float AffectRadius;
var int StartParticles;
var int FinishParticles;
var int ActiveParticles;
var actor PlayerOwner;
var float CurrentVolume;
var float StartVolume;
var float EndVolume;
var sound ChargeSound;


simulated function Deactivate()
{
	local int x;
	for(x = 0; x < 50; x++)
	{
		if (Particles[x] != None)
			Particles[x].End();
	}
	bActive = false;
	
	PlaySound(sound'Charge3',,0);
}

// This modification spawns particles on the fly, so only as many as are needed are spawned
//
simulated function ResetParticle(int X)
{
	if (Particles[x] == None)
	{
		Particles[x] = Spawn(class'ChargeCircle', Self);
	}
	Particles[x].Reset();
}

simulated function Activate(actor Player, 
		int FinalParticles, int InitParticles, float iChargeTime, 
		float Radius, float InitVel, float FinalVel,
		float StartVol, float EndVol, sound CSound)
{
	local int x;

	PlayerOwner = Player;
	InitPartVel = InitVel;
	FinalPartVel = FinalVel;
	ChargeTime = iChargeTime;
	AffectRadius = Radius;
	StartVolume = StartVol;
	EndVolume = EndVol;
	ChargeSound = CSound;
	bActive = TRUE;
	
	for(x = 0; x < InitParticles; x++)
	{
		// Active can now be called again to modify the parameters
		if (Particles[x]==None)
		ResetParticle(x);
	}
	
	CurVel = InitPartVel;
	
	StartParticles = InitParticles;
	FinishParticles = FinalParticles;
	
	PlaySound(ChargeSound,,CurrentVolume);
}

simulated function Tick(float DeltaTime)
{
	local int x, y;
	
	if(bActive == FALSE)
	{
		return;
	}
	
	CurLife += DeltaTime;
	
	if(CurLife <= ChargeTime)
	{
		CurVel = InitPartVel + (CurLife/ChargeTime) * (FinalPartVel - InitPartVel);
			
		CurrentVolume = StartVolume + (CurLife/ChargeTime) * (EndVolume - StartVolume);
		PlayerOwner.AmbientSound=ChargeSound;
		PlayerOwner.SoundVolume = CurrentVolume;
		Log("PlaySound) "$ChargeSound$" "$CurrentVolume);
		
		x = int((CurLife/ChargeTime) * (FinishParticles - StartParticles));
	
		if(x > ActiveParticles)
		{
			for(y = StartParticles + ActiveParticles; y < StartParticles + x; y++)
			{
				ResetParticle(y);
			}
			ActiveParticles = x;
		}
	}
	else
	{
		if(ActiveParticles < (FinishParticles - StartParticles))
		{
			for(y = StartParticles + ActiveParticles; y < FinishParticles; y++)
			{
				ResetParticle(y);
			}
			ActiveParticles = FinishParticles - StartParticles;
		}
		CurVel = FinalPartVel;
	}
	
	if(CurLife >= ChargeTime * 2)
	{
		End();
	}
	
	/*if(Base != Owner)
	{
		SetBase(Owner);
	}*/
	
	if (Owner != None)
	{
		SetLocation(Owner.Location + (vect(50,0,0) >> Pawn(Owner).ViewRotation));
	}
	
}

simulated function End()
{
	bActive = FALSE;
	ActiveParticles = 0;
}

state Die
{
begin:
Deactivate();
}

defaultproperties
{
     bHidden=True
     LightEffect=LE_FastWave
     LightBrightness=150
     LightHue=140
     LightRadius=12
}
