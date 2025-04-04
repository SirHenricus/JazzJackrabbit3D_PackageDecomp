//=============================================================================
// JazzSmokeGenerator.
//=============================================================================
class JazzSmokeGenerator expands JazzEffects;

var() float SmokeDelay;		// pause between drips
var() float SizeVariance;		// how different each drip is 
var() float BasePuffSize;
var() int TotalNumPuffs;
var() float RisingVelocity;
var() class<JazzEffects> GenerationType;
var() bool bRepeating;

var int i;

Auto State Active
{

function Timer()
{
	local JazzEffects d;
	
	d = Spawn(GenerationType);
	d.DrawScale = BasePuffSize+FRand()*SizeVariance;	
	if (JazzSmoke(d)!=None) JazzSmoke(d).RisingRate = RisingVelocity;	
	i++;
	if (i>TotalNumPuffs && TotalNumPuffs!=0)
	{
		if ( bRepeating )
			SetTimer(0.0, false);
		else
			Destroy();
	}
}


function Trigger( actor Other, pawn EventInstigator )
{
	SetTimer(SmokeDelay+FRand()*SmokeDelay,True);
	i=0;
}


function UnTrigger( actor Other, pawn EventInstigator )
{
	i=0;
	if (TotalNumPuffs==0)
	{
		if ( bRepeating )
			SetTimer(0.0, false);
		else
			Destroy();
	}

}

}

defaultproperties
{
     SmokeDelay=0.150000
     SizeVariance=1.000000
     BasePuffSize=1.750000
     TotalNumPuffs=200
     RisingVelocity=75.000000
     GenerationType=Class'CalyGame.JazzSmoke'
     bHidden=True
}
