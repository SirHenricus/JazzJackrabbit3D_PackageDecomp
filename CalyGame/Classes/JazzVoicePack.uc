//=============================================================================
// JazzVoicePack.
//=============================================================================
class JazzVoicePack expands Info;

// 
// This is a base class intended for organizing the voice sets to assign to different players and
// enemies with ease.  And to provide a more standardized way to know which voice/sound effects
// are needed for new players/enemies.
//
// Basic sound effects can be kept as defaults, also, overridden when something special is desired.
//

//
// The SoundMix struct contains references to a small array of sounds.  
//
/*struct SoundMix
{
var class		Sound;
};*/

// Player/NPC/Enemy effects
//
var() Sound		WarnFriendsSound;		// Sound when yelling to friends to attack!
var() Sound		ModerateDanger;			// Exclamation of something dangerous seen.
var() Sound		ImmediateDanger;		// Exclamation of something really dangerous seen.
var() Sound		InterestingComment;		// Comment on interesting item seen.
var() Sound		Taunt;					// Taunt the player.
var() Sound		AttackThreat;			// Yell out when attacking.
var() Sound		TakeOutWeapon;			// 
var() Sound		PutAwayWeapon;			// 
var() Sound		PhysicalAttack1;		//
var() Sound		PhysicalAttack2;		//
var() Sound		ProjectileAttack;		// Inherent projectile attack ability

// Base Pawn effects
//
var() Sound		MinorHurt;				// 1-10% damage
var() Sound		MinorHurtAlt1;			// Alternate MinorHurt sound
var() Sound		ModerateHurt;			// 11-35% damage
var() Sound		MajorHurt;				// 36+% damage
var() Sound		Death;					// Death
var() Sound		PlinkSound;				// No damage done
var() Sound		Poisoned;
var() Sound		EatSomething;			// Yum?
var() Sound		EatSomething2;			// Yum? alternate

// Movement effects
//
var() Sound		DashSound;
var() Sound		FootStep;
var() Sound		LedgeGrab;				// Grab onto ledge
var() Sound		LedgeGrabAlt1;			// Alternate grab onto ledge
var() Sound		LedgeFall;				// Fall back down from ledge
var() Sound		LedgePull;				// Pull up onto ledge.
var() Sound		JumpSound;
var() Sound		DoubleJumpSound;
var() Sound		LandMinor;
var() Sound		LandMajor;
var() Sound		SpecialAction1;
var() Sound		SplashMinor;
var() Sound		SplashMajor;
var() Sound		SplashOut;
var() Sound		WaterStep;

// Sound Return Functions
//
function sound DoSound ( actor A, Sound S )
{
	if (S != None)
	A.PlaySound(S, SLOT_Pain, 1, false, 2500.0, 1.0);
}

// Example
//
//function sound WarnFriends()
//{	return(SoundPick(WarnFriendsSound));		}
//

function DamageSound ( actor A, float DamagePct )
{
	//Log("Damage Sound) "$A$" "$DamagePct);
	if (DamagePct==0)
	{
		DoSound(A,PlinkSound);
	}
	else
	if (DamagePct<=10)
	{
		if ((MinorHurtAlt1 != None) && (rand(2)<1))
		{
		DoSound(A,MinorHurtAlt1);
		}
		else
		{
		DoSound(A,MinorHurt);
		}
	}
	else
	if (DamagePct<=35)
	{
		DoSound(A,ModerateHurt);
	}
	else
	DoSound(A,MajorHurt);
}

// Grab onto ledge (for alternate sounds)
function LedgeGrabSound ( actor A )
{
	if ((LedgeGrabAlt1 != None) && (rand(2)<1))
	{
		DoSound(A,LedgeGrabAlt1);
	}
	else
	DoSound(A,LedgeGrab);
}

function ThreatSound ( actor A )
{
	DoSound(A,AttackThreat);
}

function DeathSound ( actor A )
{
	DoSound(A,Death);
}

// Grab onto ledge (for alternate sounds)
function EatSound ( actor A )
{
	if ((EatSomething2 != None) && (rand(2)<1))
	{
		DoSound(A,EatSomething2);
	}
	else
	DoSound(A,EatSomething);
}

defaultproperties
{
}
