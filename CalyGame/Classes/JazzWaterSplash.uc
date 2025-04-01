//=============================================================================
// JazzWaterSplash.
//=============================================================================
class JazzWaterSplash expands JazzEffects;

var int particles;

simulated function Begin()
{
	local int x;
	local vector vec;
	local JazzWaterDroplet drop;
	
	for (x = 0; x < particles; x++)
	{
		vec = VRand();
		vec.z = 0;
		vec *= VSize(velocity)/3;
		vec.z = -velocity.z/(FRand()*1 + 1.5);
		
		drop = spawn(class'JazzWaterDroplet',self,,location+(vect(0,0,1)*(-1)*velocity.z/20));
		drop.velocity = vec;
	}

}

defaultproperties
{
     bHidden=True
     DrawType=DT_None
}
