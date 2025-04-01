//=============================================================================
// RockChunk.
//=============================================================================
class RockChunk expands BaseChunk;

simulated function HitWall( vector HitNormal, actor Wall )
{
	if ( sqrt(abs(Velocity.X*Velocity.X+Velocity.Y*Velocity.Y+Velocity.Z*Velocity.Z)) > 10 )
	{ randoSpin = VRand()*200; }
	else 
	{ randoSpin.X = 0; randoSpin.Y = 0; randoSpin.Z = 0; }
	
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);
	
	// Disabled for now - It's kind of annoying when a chunk gets stuck in a wall - makes your ears bleed...
	//if ( sqrt(abs(Velocity.X*Velocity.X + Velocity.Y*Velocity.Y + Velocity.Z*Velocity.Z))*0.5 > 5 )
	//{ PlaySound(HitSound,SLOT_Misc,sqrt(abs(Velocity.X*Velocity.X + Velocity.Y*Velocity.Y + Velocity.Z*Velocity.Z))*0.5); }
	
	
	
	/*Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	*/
}


/*simulated event Tick (float DeltaTime)
{
	local vector FacingVector;
	
	local float TestValue;
	local bool  YawReverse;
	
	FacingVector.Y = Velocity.X;
	FacingVector.X = Velocity.Y;
	
	if ( (sqrt(abs(FacingVector.X)+abs(FacingVector.Y)) > 0.5) )
	{
		YawReverse = (FacingVector.X<0);
		TestValue = (FacingVector.Y+0.1)/FacingVector.X;
		if (YawReverse)
		{ NewRotation.Yaw = -(-16384-(16384-atan(TestValue)/3.142857/2*65536))+16384; }
		else
		NewRotation.Yaw = -(atan(TestValue)/3.142857/2*65536)+16384;
	}
	
	NewLocation += Velocity;
	NewRotation.Pitch += sqrt(abs(FacingVector.X)+abs(FacingVector.Y));
	
	SetLocation(NewLocation);
	SetRotation(NewRotation);
}
simulated function RandSpin(float spinRate)
{
	local rotator NewRotation;
	
	/*NewRotation.Yaw += spinRate;
	NewRotation.Pitch += spinRate;
	NewRotation.Roll += spinRate;
	
	SetRotation( NewRotation );*/
	
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;
}*/

defaultproperties
{
     HitSound=Sound'JazzSounds.Interface.menuhit'
     FadeTime=0.700000
     Life=5.000000
     SmokeWanish=True
     SpawnSmoke=True
     RandomFadeTime=True
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.rock1'
     DrawScale=0.300000
     CollisionRadius=6.000000
     CollisionHeight=6.000000
     bCollideActors=True
     bCollideWorld=True
     Buoyancy=-90.000000
}
