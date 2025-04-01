//=============================================================================
// Lizard.
//=============================================================================
class Lizard expands JazzPawnAI;

#exec MESH IMPORT MESH=Lizard ANIVFILE=MODELS\Lizard_a.3d DATAFILE=MODELS\Lizard_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Lizard X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Lizard SEQ=All                      STARTFRAME=0 NUMFRAMES=170
#exec MESH SEQUENCE MESH=Lizard SEQ=LizardStill              STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Lizard SEQ=Lizardspin               STARTFRAME=1 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Lizard SEQ=Lizardrun                STARTFRAME=30 NUMFRAMES=18
#exec MESH SEQUENCE MESH=Lizard SEQ=Lizardrunswipe           STARTFRAME=48 NUMFRAMES=18
#exec MESH SEQUENCE MESH=Lizard SEQ=Lizardidle2              STARTFRAME=66 NUMFRAMES=75
#exec MESH SEQUENCE MESH=Lizard SEQ=Lizardidle               STARTFRAME=141 NUMFRAMES=29

#exec MESHMAP NEW   MESHMAP=Lizard MESH=Lizard
#exec MESHMAP SCALE MESHMAP=Lizard X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JLizard_01 FILE=Textures\Lizard_01.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=JLizard_02 FILE=Textures\Lizard_02.PCX GROUP=Skins FLAGS=2
#exec TEXTURE IMPORT NAME=JLizard_03 FILE=Textures\Lizard_03.PCX GROUP=Skins FLAGS=2

#exec MESHMAP SETTEXTURE MESHMAP=Lizard NUM=0 TEXTURE=JLizard_01

var 	int	AttackCounter;
var	rotator	NewRotation;
var class<actor> ProjectileQueue;

var JazzTurtleBlood BloodPart; // Patch change - this is used for the blood particles (Not that violent, because it looks reather cartoony)

/////////////////////////////////////////////////////////////////////////////////////
// 																	ANIMATIONS
/////////////////////////////////////////////////////////////////////////////////////
//
// Waiting animation
//
function PlayWaiting()
{
	LoopAnim('lizardidle2',0.9);
	GroundSpeed = WalkingSpeed;
}

// Slow walk Animation
//
function PlaySlowWalk()
{
	LoopAnim('lizardrun',0.9);
	GroundSpeed = RushSpeed;
}

// Normal walk Animation
function PlayWalking()
{
	LoopAnim('lizardrun',0.9);
	GroundSpeed = RushSpeed;
}

// Running Animation
function PlayRunning()
{
	LoopAnim('lizardrun',0.9);
	GroundSpeed = RushSpeed;
}

// Play Hit (Damage)
// Patch change - Usually lizards just stop after you start shooting them
// This made them way too easy to defeat - this code is removed so they just keep coming at the player.
//function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
//{
	//GotoState('HitAnimation');
//}

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
	BloodPart.MultiSkins[1] = Texture'Jazzytextures2.goldrefl1';
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
	TweenAnim('LizardIdle',0.3);
	Sleep(0.3);
	
	IgnoreAllDecisions = false;
	GotoState('Decision');
}


/////////////////////////////////////////////////////////////////////////////////////
// PHYSICAL ATTACK FROM RUNNING											STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state RushStrike
{
	Begin:
	// Add creature-specific attack code.
	
	TweenAnim('LizardRunSwipe',0.05);
	IgnoreAllDecisions = true;
	Sleep(0.05);
	Acceleration = 0.8*Acceleration;
	VoicePackActor.DoSound(Self,VoicePackActor.PhysicalAttack2);
	
	PlayAnim('LizardRunSwipe',1.0);
	Sleep(0.3);
	DamageOpponent(Rotation,60,15,'Blunt',300);
	
	if (ProjectileQueue != None)
	{
		spawn(ProjectileQueue);
		ProjectileQueue = None;
	}
	
	Acceleration = 0.8*Acceleration;
	FinishAnim();
	IgnoreAllDecisions=false;
	
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// PHYSICAL ATTACK FROM STANDING POSITION								STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state StandStrike
{
	Begin:
	// Add creature-specific attack code.
	TweenAnim('LizardSpin',0.2);
	IgnoreAllDecisions = true;
	Acceleration = 0.1*Acceleration;
	Sleep(0.2);
	PlayAnim('LizardSpin',1.0);
	VoicePackActor.DoSound(Self,VoicePackActor.PhysicalAttack1);
	

	NewRotation = Rotation;
	NewRotation.Yaw += 65536/2;


	for (AttackCounter=0; AttackCounter<8; AttackCounter++)
	{
	Sleep(0.07);
	
	// Do damage to player near lizard.
	DamageOpponent(NewRotation,40,15,'Blunt',300);
	
	NewRotation.Yaw += 65536/10;
	}
	
	Sleep(0.1);
	DamageOpponent(Rotation,30,15,'Blunt',150);
	
	FinishAnim();
	
	IgnoreAllDecisions = false;
	GotoState('Decision');
}

state AttackTarget
{

function FireProjectile( int ProjNum )
{
	ViewRotation = Rotation;
	
	// Check Weapon Cell Inventory Slot (0)
	if (Weapon != None)
	{
		Weapon.bPointing = true;
		JazzWeaponCell(InventorySelections[0]).Fire(0);
		PlayFiring();
	}
	else
	{
	// Nonweapon Base Attack
	ProjectileQueue = class<actor>(ProjAttackType[ProjNum]);
	
	// Override here to have rush strike done with animation when attacking
	GotoState('RushStrike');
	}
}

}

defaultproperties
{
     Courage=COU_Strong
     Intelligence=INT_Instinct
     TriggerHappy=INT_Vicious
     WaitStyle=WAT_Ambusher
     CombatStyle=COM_Rusher
     StandPhysicalAttack=True
     RunPhysicalAttack=True
     RunPhysicalFacing=True
     AvoidLedgesWhenAttacking=True
     WalkingSpeed=200.000000
     RushSpeed=300.000000
     BlobShadow=True
     BlobShadowBlackness=1.000000
     ScoreForDefeating=150
     ExperienceForDefeating=30
     DeathEffect=Class'CalyGame.JazzLizardDead'
     EnergyDamage=0.900000
     FireDamage=1.500000
     WaterDamage=0.400000
     SharpPhysicalDamage=0.800000
     BluntPhysicalDamage=0.700000
     bFreezeable=True
     bBurnable=True
     VoicePack=Class'CalyGame.VoiceLizard'
     Health=60
     HitSound1=Sound'JazzSpeech.Lizard.hurt1'
     HitSound2=Sound'JazzSpeech.Lizard.hurt1'
     Die=Sound'JazzSounds.Enemy.lizarddie'
     Physics=PHYS_Walking
     DrawType=DT_Mesh
     Texture=Texture'JazzEnemy.Skins.JLizard_01'
     Mesh=LodMesh'JazzEnemy.Lizard'
     DrawScale=1.900000
     CollisionRadius=27.000000
     CollisionHeight=55.000000
}
