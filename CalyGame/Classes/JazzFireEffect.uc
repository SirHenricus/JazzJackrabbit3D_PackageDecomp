//=============================================================================
// JazzFireEffect.
//=============================================================================
class JazzFireEffect expands JazzEffects;

var () class<JazzEffects> FireEffect;
var () int Intensity;
var () float Cycle;
var () float Spread;
var () float ZVel;
var () bool bStationary;
var () float InitalDraw;
var float CurCycle;
var bool bFollow;

simulated function PostBeginPlay()
{
	if(bStationary)
	{
		SetTimer(0.1,true);
		CurCycle = Cycle;
	}
}

simulated function Activate(int iIntensity, float iCycle, float iSpread, float iZVel, bool ibFollow, float iInitalDraw)
{
	Intensity = iIntensity;
	Cycle = iCycle;
	Spread = iSpread;
	ZVel = iZVel;
	bFollow = ibFollow;
	InitalDraw = iInitalDraw;
	
	SetTimer(0.1,true);
	CurCycle = Cycle;	
}

simulated event Timer()
{
	local SingleSparklies Fire;
	local int x;
	local vector NewVel;
	
	CurCycle -= 0.1;
	
	if (JazzPawn(Owner) != None && !bStationary)
	{
		//Velocity = (JazzPawn(Owner).Velocity);
		//NewVel = Owner.Velocity;		
	  	if (JazzPawn(Owner).Health<=0)
	  	{ Destroy(); }
	}
		
	for(x=Intensity; x > 0; x--)
	{
		NewVel = VRand() * Spread;

		if(bFollow)
		{
		    if (Owner==NONE) destroy();
			NewVel.X -= Owner.Velocity.X;
			NewVel.Y -= Owner.Velocity.Y;
		}
		
		NewVel.Z = ZVel;

		Fire = SingleSparklies(spawn(FireEffect,Self));
		Fire.Velocity = NewVel;
		Fire.MaxLifeSpan = Cycle + (0.4*FRand() - 0.2);
		Fire.SetTimer(Fire.MaxLifeSpan, true);
		Fire.MaxDrawScale = InitalDraw;
	}
	
	if(CurCycle <= 0)
	{
		SetTimer(-1.0,false);
	}
}

defaultproperties
{
     FireEffect=Class'CalyGame.FireCircle'
     Intensity=3
     Cycle=1.000000
     Spread=10.000000
     ZVel=30.000000
     InitalDraw=0.300000
     Physics=PHYS_Projectile
     DrawType=DT_None
     Style=STY_Translucent
     Sprite=Texture'JazzArt.Particles.JazzP13'
     Texture=Texture'JazzArt.Particles.JazzP13'
     DrawScale=0.010000
     LightBrightness=75
     LightRadius=5
     VolumeBrightness=75
}
