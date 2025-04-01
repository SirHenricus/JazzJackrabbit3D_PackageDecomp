//=============================================================================
// BaseChunk.
//=============================================================================
class BaseChunk expands JazzEffects;

var()	Sound	HitSound;

var		float 			FadeTime;
var ()  float 			Life;
var 	bool 			Fading;
var	()	bool 			ShrinkAway;		// Object shrinks away instead of trying to fade
var ()	bool			SmokeWanish;	// Patch change - if this is on, make the objects disappear turn into smoke!
var ()	bool			SpawnSmoke;		// Patch change - let's spawn some smoke while the chunks fall!
var ()	bool			RandomFadeTime;	// Patch change - Kinda hacky, just used for the rock chunks.
var 	RockChunkSmoke	SmokePart;		// Patch change - Smoke particle animation thingy

var	float b;	// Patch change - need this for spawning small particles when the chunks fall.		

var float Size;
var float RandSize;
var bool  bFloating;

var vector RandoSpin;

var float CurLife;

var vector NewLocation;
var rotator NewRotation;

function BeginPlay()
{
	Size = Size+Rand(RandSize);
	DrawScale = Size;
	SetCollisionSize(Size*20, Size*20 );
	SetTimer(Life,false);
	Disable('Tick');
	
	randoSpin = VRand()*200;
	SetRotation( RotRand(true) );
}

function PostBeginPlay()
{
	if (RandomFadeTime)
	{ FadeTime = 0.1+FRand()*0.6; }
}

event Timer()
{
	Fading = true;
	
	if (!ShrinkAway)
	Style = STY_Modulated;
	
	enable('Tick');
}

// Patch change - let's push the chunks around!
function Touch( actor Other )
{
	if (other.isA('JazzPlayer') || other.isA('JazzPawnAI') )
	{
		velocity.X += ((Other.Location.X-Location.X)*0.2+Other.Velocity.X)*0.1;
		velocity.Y += ((Other.Location.Y-Location.Y)*0.2+Other.Velocity.Y)*0.1;
		velocity.Z += ((Other.Location.Z-Location.Z)*0.2+Other.Velocity.Z+10)*0.1;
	}
}

event Tick(float DeltaTime)
{
	local vector FacingVector;
	
	local float TestValue;
	local bool  YawReverse;
	
	CenterOfGravityCheck(DeltaTime);
	
	if (SpawnSmoke)	// Patch change - let's spawn some particles!
	{
		b += DeltaTime;
		if (b > 0.2)
		{
			SmokePart = Spawn(class'RockChunkSmoke',self);
			SmokePart.SetLocation(Location+VRand()*(3+DrawScale)*2);
			SmokePart.DrawScale = 0.2+DrawScale*FRand();
			b = FRand()*0.2;
		}
	}

	if (bFloating)
	{ Velocity.Z += Buoyancy*DeltaTime; }

	if (Fading)
	{
		CurLife += DeltaTime;
	
		if(CurLife > FadeTime)
		{ Destroy(); }
		else
		{
			if (SmokeWanish) // Patch change - it is now possible to just destroy the chunks with a smoke aftermath. Looks kinda cooler.
			{
				SmokePart = Spawn(class'RockChunkSmoke',self);
				SmokePart.DrawScale = DrawScale + 4;
				Destroy();
			}
			else
			{
				if (ShrinkAway)
				{
					DrawScale = Size*(1-(CurLife/FadeTime));
					SetCollisionSize( Size*20 * (1-(CurLife/FadeTime)), Size*20 * (1-(CurLife/FadeTime)) );
					SetPhysics(PHYS_Falling);
				}
				else
				{
					DrawScale = Size;
					SetCollisionSize(Size*20, Size*20 );
					ScaleGlow = 1 - (CurLife/FadeTime);
				}
			}
		}
	}
	else
	{
		DrawScale = Size;
		SetCollisionSize(Size*20, Size*20 );
	}
	
	// Patch change - New spinning code!
	//FacingVector.Y += (Velocity.X - FacingVector.Y)*DeltaTime;
	//FacingVector.X += (Velocity.Y - FacingVector.X)*DeltaTime;
	FacingVector += (Velocity - FacingVector)*DeltaTime;
	
	/*if ( (sqrt(abs(Velocity.X*Velocity.X+Velocity.Y*Velocity.Y)) > 15) )
	{
		YawReverse = (FacingVector.X<0);
		TestValue = (FacingVector.Y+0.1)/FacingVector.X;
		if (YawReverse)
		{ NewRotation.Yaw = (-16384-(16384-atan(TestValue)/3.142857/2*65536)); }
		else
		NewRotation.Yaw = (atan(TestValue)/3.142857/2*65536);
	}
	
	NewRotation.Pitch -= sqrt(Velocity.X*Velocity.X+Velocity.Y*Velocity.Y)*5;*/
	
	NewRotation = Rotation;
	NewRotation.Yaw += randoSpin.Z;
	NewRotation.Pitch += randoSpin.Y;
	NewRotation.Roll += randoSpin.X;

	SetRotation(NewRotation);
}

function bool VectorTrace( vector V, vector Origin )
{
	local vector 	HitLocation,HitNormal;
	local actor		A;
	
	A = Trace( HitLocation, HitNormal,	V, Origin );

	// Return true if trace is not blocked.
	return((HitLocation == V) || (A==None));
}

function CenterOfGravityCheck ( float DeltaTime )
{
	local vector NewLocation,OriginLocation;
	local float LocSlide;
	local vector XSpeed,YSpeed;
	
	if ((Physics == PHYS_Walking) || (Physics == PHYS_Rolling))
	{
		// Moving already?
		NewLocation = Location;
		NewLocation.Z -= CollisionHeight + 5;

		// Center blocked?
		if (VectorTrace(NewLocation,Location)==false)
		return;
			
		// Continue to move object in direction that is not blocked.
		OriginLocation = Location;

		LocSlide = 100*DeltaTime;
		XSpeed.X += LocSlide;
		YSpeed.Y += LocSlide;

		NewLocation.X += CollisionRadius;
		OriginLocation.X += CollisionRadius;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// E
		{
			Velocity += XSpeed;
			Acceleration += XSpeed;
		}

		NewLocation.X -= CollisionRadius*2;
		OriginLocation.X -= CollisionRadius*2;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// W
		{
			Velocity -= XSpeed;
			Acceleration -= XSpeed;
		}

		NewLocation.X += CollisionRadius;
		NewLocation.Y += CollisionRadius;
		OriginLocation.X += CollisionRadius;
		OriginLocation.Y += CollisionRadius;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// S
		{
			Velocity += YSpeed;
			Acceleration += YSpeed;
		}

		NewLocation.Y -= CollisionRadius*2;
		OriginLocation.Y -= CollisionRadius*2;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// N
		{
			Velocity -= YSpeed;
			Acceleration -= YSpeed;
		}
	}
}

singular function ZoneChange( ZoneInfo NewZone )
{	
	if (bFloating && !NewZone.bWaterZone)
	{ bFloating = False; }

	if (NewZone.bWaterZone && !bFloating)
	{ bFloating = True;	}
}


/*simulated function HitWall( vector HitNormal, actor Wall )
{
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	RandSpin(100000);
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
	
	/*Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	*/
}

simulated final function RandSpin(float spinRate)
{
	DesiredRotation = RotRand();
	RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
	RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
	RotationRate.Roll = spinRate * 2 *FRand() - spinRate;	
}*/

defaultproperties
{
     FadeTime=1.000000
     Life=10.000000
     Physics=PHYS_Falling
     bBounce=True
}
