//=============================================================================
// JazzObject.
//=============================================================================
class JazzObject expands Actor;

// Basic Item Type
//
var(JazzObject)	enum	ObjectVal {
OBJ_Vegetable,
OBJ_Meat,
OBJ_Mineral,
OBJ_Wood,
OBJ_Metal,
OBJ_Magic
} ObjectMaterial;

// Base Item Type
//
var(JazzObject)	enum	ObjectTypeVal {
OBJ_Natural,
OBJ_LowTech,
OBJ_MedTech,
OBJ_HighTech,
OBJ_SuperHighTech,
OBJ_Magical
} ObjectType;

// Base Item Type
//
var(JazzObject)	enum	ObjectDangerVal {
OBJ_Normal,
OBJ_Dangerous
} ObjectDanger;

var(JazzObject) bool 	HitFlash;

// Base Item Type
//
var bool bSplash;
var bool bWasCarried;
var bool bFloating;

var()			bool	floatAnimation;
var()			int		BaseInterest;
var()			int		Health;
var()			bool	Destroyable;
var()			class	DestroyEffect;
var()			sound	DestroySound;
var()  class<BaseChunk> ChunkClass;
var() 			int 	SizeOfChunks;
var() 			int 	RandSizeOfChunks;
var() 			int 	NumberOfChunks;

var()			bool	BentByPlayer;			// Patch change - a new effect that makes objects bend over when the player approached them - gret for bushes and such.
var				vector	OrigLocation;

var()			bool	bPushable;				// Pushing
var()			sound	PushSound;
var()			sound	EndPushSound;
var				bool	bPushSoundPlaying;

var()			bool	bGlides;				// Object keeps moving after pushed
var()			bool	bRotates;				// Object rotates when moving
var()			float 	FrictionSlowdown;		// 0 = No friction
var()			bool	FallOffEdge;			// Patch change - this is used for the boudlers, so they roll off from edges.
var()			bool	RollInDirection;		// Patch change - A pretty cheap way of making the boulders seemingly roll, but it works for now.
var()			bool	SpinOnSides;			// Patch change - got this idea from Deus Ex, where objects rotate when their sides are pushed.
var()			bool	AlignToFloor;			// Patch change - Align object to floor normal
												// Higher values - more friction
var				float 	OrigSize;				// Used for the explosion effect			          -- Patch change
var				bool 	Dead;					// Had to do some cheap coding... sorry guys		   -- Patch change
var 	RockExplosion			SmokePart;		// Need this for making the smoke effect the correct size -- Patch change
var 	ActorShieldHitEffect	FlashObj;

var				vector			BendSpeed;		// Used for the bumping effect -- Patch change
var				vector			Bend;			// The above -- Patch change
// Patch change - save the original size for the explosion effect
function BeginPlay()
{
	OrigSize = DrawScale;
	OrigLocation = Location;
}

// Apply velocity from bumping actor
function Bump( actor Other )
{
	local float speed, oldZ;
	local Rotator NewRot;
	
	if (BentByPlayer) // Patch change - the bendover effect!
	{
		//if (other.isA('JazzPlayer'))
		//{
			Bend.X += (Location.X-other.Location.X)*600;
			Bend.Y += (Location.Y-other.Location.Y)*600;
		//}
	}

	if( bPushable && (Pawn(Other)!=None) && (Other.Mass > 40) )
	{
		oldZ = Velocity.Z;
		speed = VSize(Other.Velocity);
		Velocity = Other.Velocity * FMin(120.0, 20 + speed)/speed;

		if (bGlides)
		Acceleration = Other.Acceleration;
		
		if ( Physics == PHYS_None ) {
			Velocity.Z = 25;
			if (bPushSoundPlaying)
			{
				AmbientSound = EndPushSound;
				bPushSoundPlaying = False;
			}
		}
		else
		{
			Velocity.Z = oldZ;
			SetTimer(0.1, True);
			if ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) > 1)
			{
				if (!bPushSoundPlaying)
				{
					AmbientSound = PushSound;
					bPushSoundPlaying = True;
				}
			}
		}
		SetPhysics(PHYS_Rolling);
		Instigator = Pawn(Other);
		
		// Patch change - Rotate the object realistically, depending from which side it is pushed
		// Note that this code is heavily based off of the one found in "Deus Ex", so huge thanks to the Ion Storm guys!
		if (SpinOnSides)
		{
			NewRot = Rotator((Other.Location - Location) << Rotation);
			NewRot.Pitch = 0;
			NewRot.Roll = 0;
	
			if (NewRot.Yaw >= 24576)
				NewRot.Yaw -= 32768;
			else if (NewRot.Yaw >= 8192)
				NewRot.Yaw -= 16384;
			else if (NewRot.Yaw <= -24576)
				NewRot.Yaw += 32768;
			else if (NewRot.Yaw <= -8192)
				NewRot.Yaw += 16384;
	
			NewRot.Yaw *= 0.025;
			SetRotation(Rotation+NewRot);
		}
	}
}

function int Interest( actor Other )
{
	return(BaseInterest);
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	// Patch change - this is edited in order to allow the Hit Flash effect
	if (Destroyable==false)
	return;
	else
	{
		Health -= Damage;
		if (HitFlash == true)
		{
			FlashObj = Spawn(class'ActorShieldHitEffect',self);
			FlashObj.blow = False;
			FlashObj.GlowMultiplier = 10;
		}
	}
	if (Health<=0)
		//KilledBy(EventInstigator);
		{ Dead = True; }
}
event Tick(float DeltaTime)
{
	local int x;
	local BaseChunk Chunk;
	local vector Vel;
	local vector ChunkLocation;
	local float OverSize;
	
	local float TestValue;
	local bool  YawReverse;
	local rotator NewRotation;
	local vector FacingVector;
	
	local float        ang;
	local rotator      NewRot;
	
	local vector newLocation;
	local rotator NewRotationBend;
	
	// Patch change - need to check the floor normal in order to properly align Jazz to it.
	local vector 	HitLocation, HitNormal, HitNormalSmooth;     local Actor HitActor;
	local rotator	NormalRot;
    local float newPitch, newRoll, dist;
    local vector SearchDir;
	
	//local JazzPlayer gpo;
	
	if (FallOffEdge == True)
	{ CenterOfGravityCheck(DeltaTime);  }
	
	// Patch change - We want to stop the looping push sound when the object moves slow enough (Or stops completely)
	// Also if the object is underwater, we most certanly don't want to hear any sounds when pushing them (At least above ground)
	if (bPushSoundPlaying && (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 3 || bFloating)
	{
		AmbientSound = EndPushSound;
		bPushSoundPlaying = False;
	}
	
	if (bFloating)
	{
		if (floatAnimation)
		{
			ang = 2 * Pi * Level.TimeSeconds / 4.0;
			NewRot.Pitch += Sin(ang) * 4;//512;
			NewRot.Roll += Cos(ang) * 4;//512;
			NewRot.Yaw += Sin(ang) * 3;//256;
			SetRotation(Rotation+NewRot);
		}
		Velocity.Z += Buoyancy*DeltaTime;
	}
	
	if (BentByPlayer) // Patch change - the bendover effect!
	{
		//OrigLocation
		
		// Find the player
		/*foreach allactors(class'JazzPlayer', gpo)
		{
			// Bend the thing, Bender!
			if ( sqrt( abs((Location.X-gpo.Location.X)*(Location.X-gpo.Location.X)+(Location.Y-gpo.Location.Y)*(Location.Y-gpo.Location.Y)) ) < 50 )
			{
				BendSpeed.X += Location.X-gpo.Location.X;
				BendSpeed.Y += Location.Y-gpo.Location.X;
			}
		}*/
		
		// Physics
		//BendSpeed += -Bend/100;
   		//BendSpeed /= 1.1;
    	//Bend += BendSpeed*DeltaTime;
    	
    	// Calculate the new rotation
		NewRotationBend.Roll = Bend.X;
		NewRotationBend.Pitch = Bend.Y;
    	
    	// Set location and rotation
    	//SetLocation(NewLocation);
    	SetRotation(NewRotationBend);
	}
	
	if (RollInDirection == True)
	{
		FacingVector += (Velocity-FacingVector)*DeltaTime*20;
		
		NewRotation.Pitch -= sqrt(abs(Velocity.X*Velocity.X+Velocity.Y*Velocity.Y))*100;
		
		if ( (sqrt(abs(Velocity.X*Velocity.X+Velocity.Y*Velocity.Y)) > 5) )
		{
			YawReverse = (FacingVector.X<0);
			TestValue = (FacingVector.Y+0.1)/FacingVector.X;
			if (YawReverse)
			{ NewRotation.Yaw = (-16384-(16384-atan(TestValue)/3.142857/2*65536))+16384; }
			else
			NewRotation.Yaw = (atan(TestValue)/3.142857/2*65536)+16384;
		}
		
		SetRotation(NewRotation);
		// Thiss stuff doesn't work wery well... or at all. Will do later.
	}
	
	// Patch change - Align objects to floor normal
	if (AlignToFloor)
	{
		SearchDir = vect(0,0,-1); // must be normed
		//HitNormalSmooth += (HitNormal*100-HitNormalSmooth)*50*DeltaTime;
		HitActor = Trace( HitLocation, HitNormal, Location + 500*SearchDir, Location, false );
		if ( HitActor != None )
	   	{
	   		//HitNormalSmooth += (HitNormal*100-HitNormalSmooth)*0.01*DeltaTime;
	   		
	   		Plane( HitNormal, newRoll, newPitch, Rotation.Yaw ); // <-----
	   		newRotation.Roll = newRoll;
	   		newRotation.Pitch = newPitch;
	      	newRotation.Yaw = Rotation.Yaw;
	      	
	      	setRotation( newRotation );
	      	//dist = CollisionHeight * (HitNormal dot HitNormal) / (SearchDir dot HitNormal);
	      	//Move( HitLocation + SearchDir*dist - Location );
   		}
		
		SetRotation(newRotation);
	}

	if (Dead == True)
	{
		DrawScale += DeltaTime*3;
		if ( DrawScale >= OrigSize + 0.4 )
		{	
			// Chunk Effect
			if (ChunkClass != None)
			{
				SmokePart = Spawn(class'RockExplosion',self);
				SmokePart.DrawScale = DrawScale + 3;
				
				for(x = NumberOfChunks; x > 0; x--)
				{
					// Patch change - Improved chunk generator. Now randomizes the size and location.
					ChunkLocation = Location + VRand()*Drawscale*30;
					Chunk = spawn(ChunkClass,,,ChunkLocation);
					Chunk.Size = DrawScale*5/NumberOfChunks;//SizeOfChunks;
					Chunk.RandSize = 0.5;//RandSizeOfChunks;
					
					Vel = VRand() * 200;
					if (Vel.Z<0) {Vel.Z*=-1;}
					Chunk.Velocity = Vel;
				}
			}
			
			// Destroy Effect
			if (DestroyEffect != None)
			spawn(class<actor>(DestroyEffect),None,,Location,Rotation);
			
			if (DestroySound !=None)
			PlaySound(DestroySound);
		
			Destroy();
		}
	}
//}
}

// Patch change - Taken from UnrealSP. Used for various effects
function Plane(vector Normal, out float Roll, out float Pitch, float Yaw)
{
   local Vector X0,Y0,Z0,X1,Y1,Z1,X2,Y2,Z2;

   // convert Unreal angles to RAD
   Yaw *= Pi/32768.;

   X0 = vect(1,0,0);
   Y0 = vect(0,1,0);
   Z0 = vect(0,0,1);

   // rotate by Yaw in plane defined by X0, Y0
   X1 = cos(Yaw)*X0 + sin(Yaw)*Y0;
   Y1 = -sin(Yaw)*X0 + cos(Yaw)*Y0;
   Z1 = Z0; 

   // goal: Normal dot X2 = 0
   // X2 = cos(Pitch)*X1 + sin(Pitch)*Z1
   // cos(Pitch)*(Normal dot X1) + sin(Pitch)*(Normal dot Z1) = 0
   // sin(Pitch)/cos(Pitch) = -(Normal dot X1)/(Normal dot Z1);
   // -> Pitch = arctan( -(Normal dot X1)/(Normal dot Z1) )
   Pitch = atan( -(Normal dot X1)/(Normal dot Z1) );

   // rotate by Pitch in plane defined by X1, Z1
   X2 = cos(Pitch)*X1 + sin(Pitch)*Z1;
   Y2 = Y1;
   Z2 =-sin(Pitch)*X1 + cos(Pitch)*Z1;

    // goal: Normal dot Y3 = 0
   // Y3 = cos(Roll)*Y2 - sin(Roll)*Z2
   // cos(Roll)*(Normal dot Y2) - sin(Roll)*(Normal dot Z2) = 0
   // sin(Roll)/cos(Roll) = (Normal dot Y2)/(Normal dot Z2)
   // -> Roll = arctan( (Normal dot Y2)/(Normal dot Z2) )
   Roll = atan( (Normal dot Y2)/(Normal dot Z2) );

   // rotate by (-Roll) in plane defined by Y2, Z2
   // X3 = X2
   // Y3 = cos(Roll)*Y2 - sin(Roll)*Z2
   // Z3 = sin(Roll)*Y2 + cos(Roll)*Z2

   // convert RAD to Unreal angles
   Roll *= 32768./Pi;
   Pitch *= 32768./Pi;
}

function Landed(vector HitNormall)
{
	if( Instigator!=None && (VSize(Instigator.Location - Location) < CollisionRadius + Instigator.CollisionRadius) )
		SetLocation(Instigator.Location);
	TakeDamage( Velocity.Z/10, Instigator, Vect(0,0,1), Vect(0,0,1)*900,'exploded' );
}

// Trace to vector V and see if anything is in the way.
//
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


// Testbed area for function to rotate a rotator
//
//
function rotator RotateRotator ( rotator RotA, rotator RotB )
{
	local vector VectorA,VectorB;
	local float X,Y,Z;
	local float a,b,c,d,e,f,g,h,i;
	
	VectorA = vector(RotA);
	VectorB = vector(RotB);
	
	// Transform around Y axis
	VectorB = VectorA;
	VectorA.X =  cos(0.02) * VectorB.X + sin(0.02) * VectorB.Z;
	VectorA.Z = -sin(0.02) * VectorB.X + cos(0.02) * VectorB.Z;
	
	// Transform around X axis
	VectorB = VectorA;
	VectorA.Y =  cos(0.02) * VectorB.Y - sin(0.02) * VectorB.Z;
	VectorA.Z =  sin(0.02) * VectorB.Y + cos(0.02) * VectorB.Z;
	
	// Transform around Z axis
/*	VectorB = VectorA;
	VectorA.X =  cos(0.05) * VectorB.X - sin(0.05) * VectorB.Y;
	VectorA.Y =  sin(0.05) * VectorB.X + cos(0.05) * VectorB.Y;*/
	
	//Log("VectorA) "$VectorA$" : VectorB) "$VectorB);
	
//	VectorA += VectorB*1000;
	
	//Log("Vector) "$VectorA$" "$VectorB);
	
	return(OrthoRotation(VectorA,VectorA,VectorA));
}

/*function rotator JazzOrthoRotation ( vector V )
{
	local Rotator R;
	local float TestValue,XYSize;
	local bool  YawReverse;
	local bool  PitchReverse;
	
	YawReverse = (V.X<0);
	PitchReverse = (((V.X<0) && (V.Y<0)) || ((V.X>0) && (V.Y>0)));

	TestValue = V.Y/V.X;
	R.Yaw = atan(TestValue)/3.142857/2*65536;
	
/*	R.Yaw = atan(V.Z/
			sqrt(abs(V.Y*V.Y+V.X*V.X)))
				/3.142857/2*65536;*/
	

	XYSize = sqrt((V.X*V.X)+(V.Y*V.Y));
	TestValue = V.Z / XYSize;

	//Log("Reverse) "$YawReverse$" "$PitchReverse);	
	if (PitchReverse)
	{
//	R.Pitch = -16384-(16384-atan(TestValue)/3.142857/2*65536);
	R.Pitch = atan(TestValue)/Pi/2*65536;
	//R.Pitch = atan(TestValue)/Pi/2*65536;
	//Log("Calc1) **");
	}
	else
	{
	//Log("Calc2)");
	R.Pitch = atan(TestValue)/Pi/2*65536;
	}
	
	if (R.Pitch>49152)
	{
		//Log("ReverseCalc)");
		R.Pitch = 49152-(R.Pitch-49152);
	}

	//Log("Result1) "$atan(TestValue));
	//Log("Result2) "$-16384-(16384-atan(TestValue)/Pi/2*65536));
	//Log("Vector) "$V$" "$TestValue$" "$XYSize$" "$R);

/*	R.Pitch = atan(V.Z/
			sqrt(abs(V.X*V.X+V.Y*V.Y)))
				/3.142857/2*65536;*/
				
	//Log("Vector) "$V$" "$R);
				
	return(R);
}*/


// Includes rotation code
//
///function Tick ( float DeltaTime )
///{
	///local rotator RotateRotator;//ApplyRotation;

	
	///if (bRotates)
	///{	
		/*Acceleration -= (Acceleration*(DeltaTime*FrictionSlowDown));

		if(Velocity.X != 0)
		{
			ApplyRotation.Pitch -= Velocity.X * 5;
		}
	
		if(Velocity.Y != 0)
		{
			ApplyRotation.Roll += Velocity.Y * 5;
		}*/
		
		///RotateRotator.Pitch -= Velocity.X * 5;
		///RotateRotator.Roll += Velocity.Y * 5;
		
		//ApplyRotation.Yaw += 5;
		//ApplyRotation.Pitch += 3;

		///SetRotation(RotateRotator);
	///}

	// Check if object is near edge of ledge and should fall off.
	//	
	///CenterOfGravityCheck(DeltaTime);
///}

function rotator JazzOrthoRotation ( vector V )
{
	local Rotator R;
	local float TestValue,XYSize;
	local bool  YawReverse;
	local bool  PitchReverse;
	
	YawReverse = (V.X<0);
	PitchReverse = (((V.X<0) && (V.Y<0)) || ((V.X>0) && (V.Y>0)));

	TestValue = V.Y/V.X;
	
	//if (YawReverse)
	//{
	//R.Yaw = -16384-(16384-atan(TestValue)/3.142857/2*65536);
	//}
	//else
	
	R.Yaw = atan(TestValue)/3.142857/2*65536;
	R.Yaw = atan(V.Z/
			sqrt(abs(V.Y*V.Y+V.X*V.X)))
				/3.142857/2*65536;
	
	XYSize = sqrt(abs(V.X*V.X)+abs(V.Y*V.Y));
	TestValue = V.Z / XYSize;
	
	//if (XYSize<0)
	/*if (PitchReverse)
	if (V.X>0)
	{
	R.Pitch = -16384-(16384-atan(TestValue)/3.142857/2*65536)-65536/4;
	R.Pitch = 16384*2-(atan(TestValue)/3.142857/2*65536);
	R.Pitch = 16384*2+atan(TestValue)/Pi/2*65536;
	R.Pitch = -atan(TestValue)/Pi/2*65536;
	Log("Calc1) **");
	}
	//R.Pitch = atan(TestValue)/Pi/2*65536;
	else
	{
	Log("Calc2)");*/
	R.Pitch = atan(TestValue)/Pi/2*65536;
	//}
	
	Log("Result1) "$atan(TestValue)/3.142857/2*65536);
	Log("Result2) "$-16384-(16384-atan(TestValue)/Pi/2*65536));
	Log("Vector) "$V$" "$TestValue$" "$XYSize$" "$R);

	R.Pitch = atan(V.Z/
			sqrt(abs(V.X*V.X+V.Y*V.Y)))
				/3.142857/2*65536;
				
	//Log("Vector) "$V$" "$R);
				
	return(R);
}

singular function ZoneChange( ZoneInfo NewZone )
{
	local float splashsize;
	local actor splash;
	
	if (bFloating && !NewZone.bWaterZone)
	{ bFloating = False; }

	if (NewZone.bWaterZone && !bFloating)
	{ bFloating = True;	}
	
	if( NewZone.bWaterZone )
	{
		if( bSplash && !Region.Zone.bWaterZone && Mass<=Buoyancy 
			&& ((Abs(Velocity.Z) < 100) || (Mass == 0)) && (FRand() < 0.05) && !PlayerCanSeeMe() )
		{
			bSplash = false;
			SetPhysics(PHYS_None);
		}
		else if( !Region.Zone.bWaterZone && (Velocity.Z < -200) )
		{
			// Else play a splash.
			splashSize = FClamp(0.0001 * Mass * (250 - 0.5 * FMax(-600,Velocity.Z)), 1.0, 3.0 );
			if( NewZone.EntrySound != None )
				PlaySound(NewZone.EntrySound, SLOT_Interact, splashSize);
			if( NewZone.EntryActor != None )
			{
				splash = Spawn(NewZone.EntryActor); 
				if ( splash != None )
					splash.DrawScale = splashSize;
			}
		}
		bSplash = true;
	}
	else if( Region.Zone.bWaterZone && (Buoyancy > Mass) )
	{
		if( Buoyancy > 1.1 * Mass )
			Buoyancy = 0.95 * Buoyancy; // waterlog
		else if( Buoyancy > 1.03 * Mass )
			Buoyancy = 0.99 * Buoyancy;
	}

	if( NewZone.bPainZone && (NewZone.DamagePerSec > 0) )
		TakeDamage(100, None, location, vect(0,0,0), NewZone.DamageType);
}

defaultproperties
{
}
