//=============================================================================
// JazzWaterZone.
//=============================================================================
class JazzWaterZone expands ZoneInfo;

simulated event ActorEntered( actor Other )
{
	local JazzWaterSplash water;
	local WaterRipple Ripple;
	local float x;
	
	super.ActorEntered(other);
	
	if(pawn(other) != None)
	{
		// Particle splash
		water = spawn(class'JazzWaterSplash',Self,,other.location);
		water.velocity = other.velocity;
		water.particles = 10*FRand()+10;

		water.Begin();

		// water ripple
		if (other.Velocity.Z < -500)
		{
			// big splash
			
			spawn(class'WaterRipple',Self,,other.location+vect(0,0,40));

		}
		else
		{
			// small splash
			x = fmin(other.velocity.z/500,-0.1)*-1;
			ripple = spawn(class'WaterRipple',Self,,other.location+(vect(0,0,40)*x));
			ripple.drawscale = x;
			
		}
	}
}

defaultproperties
{
     ZoneGravity=(Z=0.000000)
     bWaterZone=True
}
