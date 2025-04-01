//=============================================================================
// TagaBee.
//=============================================================================
class TagaBee expands JazzFlyingPawnAI;

var rotator NewRotation;

function PlayFiring()
{
	PlayAnim('attack');
}

function PlayFiringAnim()
{
	PlayAnim('attack');
}

function PlayWaiting()
{
	LoopAnim('fly');
	PlaySound(sound'tagaloop',Slot_Interact,0.2);
}

function PlayFlying()
{
	LoopAnim('fly');
	PlaySound(sound'tagaloop',Slot_Interact,0.2);
}

// Play Hit (Damage)
function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	local ActorShieldHitEffect Image;
	
	// Patch Change - a new flashing effect when an actor is hurt.
	Image = spawn(class'ActorShieldHitEffect');
	Image.SetOwner(Self);
	
	GotoState('HitAnimation');
}

state HitAnimation
{
	function Tick(float DeltaTime)
	{
		// Todo: Slow down pawn
		AirSpeed -= DeltaTime*500;
		if (AirSpeed<0) AirSpeed=0;
		
		// New acceleration
		Acceleration = vector(Rotation)*AirSpeed;
		
		Global.Tick(DeltaTime);
	}
	
	begin:
	Acceleration = vect(0,0,0);
	PlayAnim('Hit');

	FinishAnim();
	PlayFlying();
	IgnoreAllDecisions = false;
	GotoState('Decision');
}

//
// Death Animation
//
State Dying
{
	event Landed(vector HitNormal)
	{
		Local rotator NewRotation;
		
		NewRotation = Rotation;
		NewRotation.Pitch = 0;
		NewRotation.Roll = 0;
		
		SetRotation(NewRotation);	
		
		SetPhysics(PHYS_None);
		bBlockActors = False;
		bBlockPlayers = False;
		SetTimer(3.0,true);
	}
	
	function Timer()
	{
		LifeSpan = 3.0;
		SetTimer(0,false);
	}

	function BeginState()
	{		
		SetPhysics(PHYS_Falling);
		SetCollisionSize( Default.CollisionRadius, Default.CollisionHeight+10 );
	}
	
	function Tick ( float DeltaTime )
	{
		//Acceleration.Z += DeltaTime*500;
		if (LifeSpan>0)
		{
			Style = STY_Translucent;
			ScaleGlow = (LifeSpan/3);
		}
	}
	
Begin:
	PlaySound(sound'tagadie',Slot_Interact,0.0);
	PlayAnim('dead1');
	FinishAnim();
}

// Taga Physical Swing
//
function FlyingPhysicalAttack()
{
	GotoState('AttackTarget','TagaPhysical');
}

state AttackTarget
{
TagaPhysical:
	IgnoreAllDecisions = true;
	PlayAnim('spin');
	PlaySound(sound'tagaattack');
	
	Sleep(0.27);
	NewRotation = Rotation;
	NewRotation.Yaw += 65536/2;
	
	for (temp=0; temp<8; temp++)
	{
	DamageOpponent(NewRotation,50,10,'Sharp',300);
	if (temp<7)	Sleep(0.23);
	NewRotation.Yaw = Rotation.Yaw - 65536/2 - 65536/8*temp;
	}

	PlayAnim('takeoff');
	PlaySound(sound'tagaattack2');
	FinishAnim();
	IgnoreAllDecisions = false;
	// TODO: Increase speed boost - temporary

	AttackRun=false;
	GotoState('Wander');
}

defaultproperties
{
     MaxAltitude=300.000000
     NormalSpeed=300.000000
     MaxSpeed=500.000000
     Courage=COU_Timid
     Intelligence=INT_Instinct
     TriggerHappy=INT_Moderate
     WaitStyle=WAT_LoneWanderer
     ProjAttack=True
     ProjAttackType(0)=Class'CalyGame.JazzIceShard'
     ProjAttackDesire(0)=1
     ProjRecharge=0.500000
     WalkingSpeed=200.000000
     RushSpeed=200.000000
     AfraidDuration=0.000000
     ScoreForDefeating=75
     DeathEffect=Class'CalyGame.ParticleExplosion'
     EnergyDamage=1.200000
     FireDamage=0.600000
     WaterDamage=1.200000
     SoundDamage=1.200000
     VoicePack=Class'CalyGame.VoiceTagaBee'
     GroundSpeed=500.000000
     AirSpeed=500.000000
     AirControl=0.030000
     Health=70
     Physics=PHYS_Projectile
     AnimSequence=Fly
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.Taga'
     CollisionRadius=30.000000
     RotationRate=(Pitch=10000,Yaw=10000,Roll=10000)
}
