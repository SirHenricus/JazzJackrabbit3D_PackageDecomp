//=============================================================================
// JazzTorch.
//=============================================================================
class JazzTorch expands JazzPlainObjects;

var () int Intensity;
var () float Cycle;
var () float Spread;
var () float ZVel;
var () float InitalDraw;
var float CurCycle;

simulated function PreBeginPlay()
{
	local JazzFireEffect neff;
	local vector offset;
	
	offset = vect(7,0,15);
	
	offset = offset >> rotation;
	
	neff = spawn(class'JazzFireEffect',self,,self.location+offset);
	neff.Activate(Intensity, Cycle, Spread, ZVel, false, InitalDraw);
}

defaultproperties
{
     Intensity=2
     Cycle=1.000000
     Spread=5.000000
     ZVel=20.000000
     InitalDraw=0.050000
     bMovable=False
     bNetOptional=True
     bDirectional=True
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzDecoration.torch1'
}
