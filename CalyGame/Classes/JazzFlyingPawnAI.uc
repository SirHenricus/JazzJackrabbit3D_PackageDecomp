//=============================================================================
// JazzFlyingPawnAI.
//=============================================================================
class JazzFlyingPawnAI expands JazzPawnAI;

//
// Goal for Class:
//
// Replace all ground motion with flying motion.
//
// 

//
// Variables:
//
// Normal roaming altitude
//
var() float MaxAltitude;
var() float NormalSpeed;
var() float MaxSpeed;
var	  bool AttackRun;


/////////////////////////////////////////////////////////////////////////////////////
// LIFE		 															STATES
/////////////////////////////////////////////////////////////////////////////////////
//
auto state Life
{
	Begin:
	MinHitWall = -0.5;
	SetPhysics(PHYS_Flying);
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// AI INITIALIZATION												INITIALIZATION
/////////////////////////////////////////////////////////////////////////////////////
//
function PreBeginPlay()
{
	Super.PreBeginPlay();

	ResetActorDesires();
	
	// Set Unreal movement code intrinsics
	//
	bCanFly = true;
	bCanSwim = false;
	bAvoidLedges = false;
	bStopAtLedges = false;
}

function PreSetMovement()
{
	bCanJump = false;
	bCanWalk = false;
	bCanSwim = false;
	bCanFly = true;
	MinHitWall = -0.6;
	bCanOpenDoors = false;
	bCanDoSpecial = false;
}


//
// NEW ANIMATIONS
//
function PlayFlying();


state Wander
{
	function NewWanderLocation()
	{
		local int Tries;
		local float Distance,Temp;
		local vector BestDest;
		local vector HitLocation;
		local vector HitNormal;
		local vector Change;
	
		Tries = 8;
		Distance = 0;
	
		while (Tries>0)		
		{
		Destination = Location + VRand() * (FRand()*200+50) + VRand()*vect(1,1,0) * (FRand()*200+50);
		
		// Todo: Trace down from same Z height (altitude) and decide.
		Trace(HitLocation,HitNormal,Destination-vect(0,0,10000),Location);
		Temp = VSize(HitLocation-Destination);
		//Log("Altitude) "$Temp$" Hit:"$HitLocation$" "$Destination);
		if (Temp>MaxAltitude)
		{
			HitLocation.Z += MaxAltitude + 50;
			Destination = HitLocation;
		}
		
		
		Trace( HitLocation, HitNormal, Destination, Location );
		
		//Log("HitLocation) "$HitLocation$" "$Location$" "$Destination);
		
		if (HitLocation == vect(0,0,0))
		{
			//Log("Flying) Great Destination Found");
			return;
		}
		
		//Log("HitLocation) "$HitLocation$" "$Distance);
		if (VSize(HitLocation-Location)>Distance)
		{
			BestDest = HitLocation;
			Distance = VSize(HitLocation-Location);
		}
		Tries--;
		//Log("Dest) "$Tries$" "$Distance$" "$VSize(HitLocation-Location));
		}
		
		Destination = BestDest;
	}

	Begin:

	NewWanderLocation();
	GotoState('FlyTowardDestination');
}

state GoHidePoint
{
	Begin:
	GotoState('Wander');
}

state FlyTowardDestination
{
	function UpdateYawRotation ( vector targ )
	{
	local rotator NewRotation;
	local int YawErr;
	DesiredRotation = Rotator(targ - location);
	DesiredRotation.Yaw = DesiredRotation.Yaw & 65535;
	YawErr = (DesiredRotation.Yaw - (Rotation.Yaw & 65535)) & 65535;
	
	NewRotation = Rotation;
	if (YawErr<32200)
		NewRotation.Yaw += 100;
	else
		NewRotation.Yaw += 100;
		
	SetRotation(NewRotation);
	}
	
	function bool GoodAim(vector targ)
	{
		local int YawErr;
	
		DesiredRotation = Rotator(targ - location);
		DesiredRotation.Yaw = DesiredRotation.Yaw & 65535;
		YawErr = (DesiredRotation.Yaw - (Rotation.Yaw & 65535)) & 65535;
		if ( (YawErr < 1000) || (YawErr > 64535) )
			return true;
	
		return false;
	}

	function Tick(float DeltaTime)
	{
		// Special AttackRun code
		if (AttackRun) { 
			// Enemy may move - update location
			Destination = Enemy.Location;
		
			// Check if too close to enemy and we should veer off
			if (VSize(Location-Enemy.Location)<100)	// This determines how close it likes to get to the player when attacking
			{
				AttackRun=false;
				GotoState('Wander');
			}
			
			// Check if enemy is in target to fire  (Then switch to wander for a brief time.)
			if (GoodAim(Enemy.Location))
			{
				if (RunPhysicalAttack && VSize(Location-Enemy.Location)<300)
				{
					FlyingPhysicalAttack();
					return;
				}
						
				if (VSize(Location-Enemy.Location)<600)
				{
				GotoState('AttackTarget','FireAnim');
				}
			}
		
		}
	
		FlyingTick(DeltaTime);
				
		//Log("NewRotation) "$NewRot$" "$Rotation);
		Global.Tick(DeltaTime);
	}

	Begin:
	PlayFlying();
	
	SetBase(None);
	if (AttackRun) 
	{
	DesiredSpeed = NormalSpeed * 1.2;
	MaxDesiredSpeed = MaxSpeed * 1.2;
	GroundSpeed = Default.GroundSpeed * 1.2;
	AirSpeed = Default.AirSpeed * 1.2;
	}
	else
	{
	DesiredSpeed = NormalSpeed;
	MaxDesiredSpeed = MaxSpeed;
	GroundSpeed = Default.GroundSpeed;
	AirSpeed = Default.AirSpeed;
	}
	
	IgnoreAllDecisions = true;
	Sleep(FRand()*3+1);
	IgnoreAllDecisions = false;
	
	if (AttackRun) { 
	AttackRun = false;
	GotoState('Wander'); }
	
	GotoState('Decision');
}

function ClientSetLocation( vector NewLocation, rotator NewRotation )
{
	local Pawn P;

	ViewRotation      = NewRotation;
	NewRotation.Roll  = 0;
	SetRotation( NewRotation );
	SetLocation( NewLocation );
}

function ClientSetRotation( rotator NewRotation )
{
	local Pawn P;

	ViewRotation      = NewRotation;
	NewRotation.Roll  = 0;
	SetRotation( NewRotation );
}

state AttackTarget
{
	function Tick(float DeltaTime)
	{
		// Todo: Slow down pawn
		AirSpeed -= DeltaTime*400;
		if (AirSpeed<0) AirSpeed=0;
		
		Destination = Enemy.Location;
		FlyingTick(DeltaTime);
		
		Global.Tick(DeltaTime);
	}

	// In-air firing animation (projectile)
	FireAnim:
	PlayFiringAnim();
	Sleep(0.35);
	DoProjectileAttack(false);
	FinishAnim();
	AttackRun=false;
	GotoState('Wander');
	
	Begin:
	// Error Check: Do we have an enemy?
	if (Enemy == None) GotoState('Wander');
	
	// Fly towards enemy.
	Destination = Enemy.Location;
	AttackRun = true;
	GotoState('FlyTowardDestination');	
}

function bool GoodAim(vector targ)
{
}

function PlayFiringAnim()
{
}

function FlyingTick ( float DeltaTime )
{
		local rotator NewRot;
		
		local vector HitLocation;
		local rotator DesRot;
		local float TestValue;
		
		local float TurnRate;
		local int TempVal;
		
		SetPhysics(PHYS_Flying);
	
		// New acceleration
		Acceleration = vector(Rotation)*AirSpeed;
		
		// Camera Rotation
		HitLocation = Destination - Location;
		TestValue = HitLocation.Y/HitLocation.X;
		if (HitLocation.X<0)
		DesRot.Yaw = (-16384-(16384-atan(TestValue)/Pi/2*65536)) & 65535;
		else
		DesRot.Yaw = (atan(TestValue)/Pi/2*65536) & 65535;
		
		DesRot.Pitch = (atan(HitLocation.Z/
			sqrt(abs(HitLocation.X * HitLocation.X + HitLocation.Y * HitLocation.Y)))
			/Pi/2*65536) & 65535;
			
		// Turn toward target
		NewRot = Rotation;
		NewRot.Yaw = NewRot.Yaw & 65535;
		TurnRate = (25000+
						(300-VSize(Velocity))*25)
						*DeltaTime;
		if (abs(DesRot.Yaw - NewRot.Yaw)<=TurnRate)
		{
		NewRot.Yaw = DesRot.Yaw;
		}
		else
		{
		TempVal = DesRot.Yaw;
		//Log("Flying) RotCheck) TempVal:"$TempVal$" NewRot.Yaw:"$NewRot.Yaw);
		if (TempVal < NewRot.Yaw) TempVal += 65536;
		//Log("Flying) RotateToward "$NewRot.Yaw$" "$TempVal$" "$TempVal-NewRot.Yaw);
		if ((TempVal - NewRot.Yaw) > (65536/2))
		{
		//Log("------ Subtract "$NewRot.Yaw);
		NewRot.Yaw -= TurnRate;
		}
		else
		{
		//Log("------ Add "$NewRot.Yaw);
		NewRot.Yaw += TurnRate;
		}
		}
		
		// Raise up and down in pitch
		TurnRate = 15000*DeltaTime;
		//Log("Pitch) "$NewRot.Pitch$" "$DesRot.Pitch$" "$TurnRate$" "$Rotation);
		//DesRot.Pitch = 65535-DesRot.Pitch;
		NewRot.Pitch = NewRot.Pitch & 65535;
		if (abs(NewRot.Pitch - DesRot.Pitch) < TurnRate)
		{
		NewRot.Pitch += (DesRot.Pitch - NewRot.Pitch)/2;
		}
		else
		{
			TempVal = DesRot.Pitch & 65535;
			if (TempVal < NewRot.Pitch) TempVal+=65536;
			//Log("Des Y) "$Destination.Z$" Now:"$Location.Z);
			//Log("NewRot) "$NewRot.Pitch$" DesRot:"$TempVal);
			if ((TempVal - NewRot.Pitch) > (65536/2))
			{
			if ((NewRot.Pitch>60000) || (NewRot.Pitch<10000))
			NewRot.Pitch -= TurnRate;
			}	
			else
			if ((NewRot.Pitch<5000) || (NewRot.Pitch>50000))
			NewRot.Pitch += TurnRate;
		}

		SetRotation(NewRot);
		ViewRotation = NewRot;
		DesiredRotation = NewRot;
}

// Physical Attack
//
// RunPhysicalAttack set to 'true'
// Override in actual enemy class to implement
//
function FlyingPhysicalAttack()
{
}

state FlyingAttack
{
	Begin:
	GotoState('Decision');
}

defaultproperties
{
     BlobShadow=True
     BlobShadowBlackness=1.000000
}
