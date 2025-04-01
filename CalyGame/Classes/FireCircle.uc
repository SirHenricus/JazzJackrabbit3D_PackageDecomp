//=============================================================================
// FireCircle.
//=============================================================================
class FireCircle expands RedCircle;

var vector Realative;
var vector MoveVel;
var float CurLife;
var bool bReverse;
var vector LastOwnerLoc;

simulated event Tick (float DeltaTime)
{
	if (MaxLifeSpan>0)
	{
		DrawScale = (MaxLifeSpan - CurLife)/MaxLifeSpan*MaxDrawScale;
	}
	
	CurLife += DeltaTime;
		
	//Velocity.X -= Velocity.X >> 3;	// Velocity.X /= 1.2;
	//Velocity.Y -= Velocity.Y >> 3;  // Velocity.Y /= 1.2;	
	
	Velocity.X -= Owner.Velocity.X;
	Velocity.Y -= Owner.Velocity.Y;
	Velocity.Z -= Owner.Velocity.Z;
	
	MoveVel /= 1.3;
	
	Realative += (Velocity+MoveVel)*DeltaTime;
	
	if (Owner==None)
	{
		SetLocation(LastOwnerLoc + Realative);
	}
	else
	{
		LastOwnerLoc = Owner.Location;
		SetLocation(Owner.Location + Realative);
	}
}

simulated function float ReduceZVel(vector Velocity)
{
	Velocity.Z = 0;
	return VSize(Velocity)/2;
}

simulated function Reset()
{
	if (Owner==None) Destroy();
	
	CurLife = 0;
	SetLocation(Owner.Location);
	Velocity = VRand() * JazzFireEffect(Owner).Spread;
	
	bReverse = FALSE;
	Realative = vect(0,0,0);
	MoveVel = vect(0,0,0);
	
	if(JazzFireEffect(Owner).bFollow)
	{
		MoveVel -= JazzFireEffect(Owner).Owner.Velocity;
		if(VSize(MoveVel) > 300)
		{
			MoveVel = Normal(MoveVel);
			MoveVel *= 300;
		}
	}
	
	Velocity.Z = JazzFireEffect(Owner).ZVel; 
	MaxLifeSpan = JazzFireEffect(Owner).Cycle + (0.1*FRand() - 0.2);
}

simulated function Timer()
{
	Reset();
	SetTimer(MaxLifeSpan, false);
}

defaultproperties
{
     Physics=PHYS_Projectile
     LifeSpan=0.000000
     Sprite=Texture'JazzArt.Particles.Jazzp15'
     Texture=Texture'JazzArt.Particles.Jazzp15'
     DrawScale=0.180000
     bNoSmooth=True
     bParticles=True
     VisibilityRadius=5.000000
     VisibilityHeight=5.000000
     bAlwaysRelevant=False
     bGameRelevant=True
}
