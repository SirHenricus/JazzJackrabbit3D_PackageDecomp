//=============================================================================
// turtle1.
//=============================================================================
class turtle1 expands JazzPawnAI;

#exec MESH IMPORT MESH=turtle1 ANIVFILE=MODELS\turtle_a.3d DATAFILE=MODELS\turtle_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=turtle1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Turtle1 SEQ=All                      STARTFRAME=0 NUMFRAMES=310
#exec MESH SEQUENCE MESH=Turtle1 SEQ=Turtlehide               STARTFRAME=0 NUMFRAMES=60
#exec MESH SEQUENCE MESH=Turtle1 SEQ=Turtlewalk               STARTFRAME=60 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Turtle1 SEQ=TurtleRun                STARTFRAME=89 NUMFRAMES=16
#exec MESH SEQUENCE MESH=Turtle1 SEQ=Turtleidle               STARTFRAME=105 NUMFRAMES=70
#exec MESH SEQUENCE MESH=Turtle1 SEQ=TurtleStill              STARTFRAME=175 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Turtle1 SEQ=Turtlehit                STARTFRAME=176 NUMFRAMES=38
#exec MESH SEQUENCE MESH=Turtle1 SEQ=TurtleUnhide             STARTFRAME=214 NUMFRAMES=96

#exec MESHMAP NEW   MESHMAP=turtle1 MESH=turtle1
#exec MESHMAP SCALE MESHMAP=turtle1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jturtle_01 FILE=Textures\turtle_01.PCX GROUP=Skins FLAGS=2	//Material #1

#exec MESHMAP SETTEXTURE MESHMAP=turtle1 NUM=0 TEXTURE=Jturtle_01

var JazzTurtleBlood BloodPart; // Patch change - this is used for the blood particles (Not that violent, because it looks reather cartoony)

/////////////////////////////////////////////////////////////////////////////////////
// 																	ANIMATIONS
/////////////////////////////////////////////////////////////////////////////////////
//
// Waiting animation
//
function PlayWaiting()
{
	LoopAnim('turtleidle',0.9);
	GroundSpeed = WalkingSpeed;
}

// Slow walk Animation
//
function PlaySlowWalk()
{
	LoopAnim('turtlewalk',1.0);
	GroundSpeed = WalkingSpeed;
}

// Normal walk Animation
function PlayWalking()
{
	LoopAnim('turtlewalk',1.0);
	GroundSpeed = WalkingSpeed;
}

// Running Animation
function PlayRunning()
{
	LoopAnim('turtlerun',1.1);
	GroundSpeed = RushSpeed;
}

// Play Hit (Damage)
function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	local ActorShieldHitEffect Image;
	
	// Patch Change - a new flashing effect when an actor is hurt.
	Image = spawn(class'ActorShieldHitEffect');
	Image.SetOwner(Self);
	
	// Patch change - Spawn some blood particles
	BloodPart = Spawn(class'JazzTurtleBlood',Self);
	BloodPart.Velocity = VRand()*100;
	BloodPart.Velocity.Z = 200+rand(200);
	BloodPart.DrawScale = 0.5+rand(0.5);
		
	GotoState('HitAnimation');
}

/////////////////////////////////////////////////////////////////////////////////////
// Override Action														STATES
/////////////////////////////////////////////////////////////////////////////////////
//
//
//
state HitAnimation
{	
	Begin:
		IgnoreAllDecisions = true;
		Acceleration = vect(0,0,0);
		PlayAnim('turtleHit');
	
		FinishAnim();
		IgnoreAllDecisions = false;
		GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// Override Action														STATES
/////////////////////////////////////////////////////////////////////////////////////
//
//
//
state AfraidOfTarget
{

Begin:
	//Log("TurtleHideInShell) "$Self);

	//if (Health <= origHP * 0.5)
	//{
		// Afraid: Hide in shell for a brief period of time.
		//
		IgnoreAllDecisions = true;
		PlayAnim('turtleHide');
		Sleep(0.1);
		StateBasedInvulnerability = true;
		FinishAnim();
	
		// Todo: Make the turtle temporarily indestructable while in his shell.
		// 
		Sleep(6);
		
		// Turtle emerges again from his shell.
		// 
		PlayAnim('turtleUnhide');
		Sleep(0.2);
		StateBasedInvulnerability = false;
		FinishAnim();
	
		// Make the current target the AfraidTarget.
		//
		//CurrentTarget = AfraidTarget;
		Enemy = None;		// Forgets the player who attacked him.
		AfraidTarget = None;
		IgnoreAllDecisions = false;
		GotoState('Decision');
	//}
}

defaultproperties
{
     Courage=COU_Timid
     Intelligence=INT_Instinct
     WaitStyle=WAT_LoneWanderer
     CombatStyle=COM_Rusher
     WalkingSpeed=90.000000
     RushSpeed=250.000000
     AfraidDuration=2.000000
     BlobShadow=True
     BlobShadowBlackness=1.000000
     ScoreForDefeating=100
     ExperienceForDefeating=10
     DeathEffect=Class'CalyGame.JazzTurtleShell'
     JumpedOnDeathEffect=Class'CalyGame.JazzTurtleDead'
     JumpOnDamage=50
     JumpOnTakeDamage=True
     ToucherDamage=10
     ToucherTakeDamage=True
     WaterDamage=0.750000
     SoundDamage=0.750000
     SharpPhysicalDamage=0.150000
     DamageHitBack=True
     bFreezeable=True
     bBurnable=True
     bPetrify=True
     VoicePack=Class'CalyGame.VoiceTurtle'
     SightRadius=500.000000
     Health=50
     HitSound1=Sound'JazzSpeech.TurtleFX.turtle2'
     HitSound2=Sound'JazzSpeech.TurtleFX.turtlebite'
     Land=Sound'JazzSounds.Jazz.step1'
     Die=Sound'JazzSpeech.TurtleFX.turtledie'
     WaterStep=Sound'JazzSounds.Jazz.WaterStep'
     AnimSequence=Turtle1
     DrawType=DT_Mesh
     Texture=Texture'JazzEnemy.Skins.Jturtle_01'
     Skin=Texture'JazzEnemy.Skins.Jturtle_01'
     Mesh=LodMesh'JazzEnemy.Turtle1'
     DrawScale=0.800000
     CollisionRadius=31.000000
     CollisionHeight=31.000000
}
