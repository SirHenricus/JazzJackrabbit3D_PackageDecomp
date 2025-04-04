//=============================================================================
// JazzPlayer.
//=============================================================================
class JazzPlayer expands PlayerPawn
	config(user);


////////////////////////////////////////////////////////////////////////////////// VARS ////
//

///////////////////////////////////////////////////////////////////////////////////////////
// General Player Statistics
///////////////////////////////////////////////////////////////////////////////////////////
//
// General Statistics
//
var float			LifeTime;
//
// Additional Status Values
//
var() travel int	HealthMaximum;	// (Pawn) Health is starting health.
									// HealthMaximum can be changed, so keep that in mind.

// Invulnerability - Effects against player
var 	bool		CurrentlyInvulnerable;
var()	float		InvulnerabilityDuration;
var		float		InvulnerabilityTime;
var		bool		InvulnerabilityEffect;

// Animations
var() float  RunningAnimationSpeed;
var() float  SwimmingAnimationSpeed;

// Charging
var		JazzChargeEffect	ChargeEffect;
// Fire
var		float		FireTime;
var		bool		FireEffect;
// Poison
var		float		PoisonTime;
var()	texture		PoisonTexture;
var		bool		PoisonEffect;
// Frozen
var()	texture		FrozenTexture;
// Petrify
var()	texture		PetrifyTexture;
var		float		TrailTime;

// Shield Actor
var		JazzShield	ShieldActor;

// General effects
var 	float 		EffectTime;

///////////////////////////////////////////////////////////////////////////////////////////
// Inventory / Etc.
///////////////////////////////////////////////////////////////////////////////////////////
//
// Inventory Amounts
//
var travel int		Carrots;	// Currency, of one form or another - currently money
var travel int		Keys;		// # of keys or key pieces
var travel int		Lives;		// # of lives the player has left
var float			ManaAmmo;	// Amount of ammo player has
var travel float	ManaAmmoMax; // Amount of ammo maximum
var travel float	ManaRechargeRate; // Rate of recharge of mana ammo
var float			ManaRechargeTime; // Accumulated time for recharge
var byte			LevelGems;	// # of Special Level Gems
//
// Item Inventory System
//
// Group
// 0 - Weapon Cells
var bool				bShowInventory;
var travel Inventory	InventorySelections[5];		// Item currently selected in each group type - written to from JazzHUD
				// InventorySelections needs the be saved along with the player data

// Event Replication
//
var travel name			Events[200];
var travel byte			EventNum;
									
///////////////////////////////////////////////////////////////////////////////////////////
// Player Motion
///////////////////////////////////////////////////////////////////////////////////////////
//
// Vehicle Variables
//
var float			DefaultGroundSpeed;
var vector			VelocityHistory;
var JazzVehicle		Vehicle;
var bool			VehicleBounce;
//
// ForceTurning (This is done manually due to no known automatic function to use.)
//
var bool    		ForceTurning;
var int				TurnSpeedMax;	// TurnSpeedMax must be a multiple of TurnAccel
var int				TurnSpeed;
var	int				TurnAccel;
var bool			TurnIsClose;
var int				TurnDecelDistance;
//
// Jazz Motion Variables
var()	float		DashSpeed;		// Multiplier for quick-forward motion when double-forward
var		float		DashTime;
var		float		DashReadyTime;
var		eDodgeDir	DashDirection;
var 	float		LatentBounce;
var		bool		LatentBounceDo;

var     float		OldAForward,BaseAForward;
var		float		OldATurn;
var		float		OldAStrafe;
var		bool		OldRunContinue;	// Not a new PlayRunning - Use in animation to
									// tell if this is merely a check to see if the
									// player changed direction.

var		int			MouseDelay;
//
//
// Jazz Special Motion Variables
var		float		SpecialMotionHeldTime;		// Time SpecialMotion button has been held
//
// Jazz Jump-Twice Variables
var		float		DoubleJumpReadyTime;
var		float		DoubleJumpDelayTime;
var		bool		DoubleJumpAlready;
var()	bool		DoubleJumpAllowed;
//
// Swimming Variable
var()	float		MaxSwimmingJumpDuration;
var		float		SwimmingJumpDuration;
var		bool		bWaterJump;
var		bool		bJustJumpedOutOfWater;
//
// Ledge Hang
var		bool		bLedgeGrabOk;	// Zone info may change this
var		bool		bWasHung;
var		float		LedgeCheckDelay;
var		bool		bLedgeForwardHeld;
var		bool		bLedgeBackHeld;
//
// Extra stuff (Patch change)
var		bool		dive; // A new diving feature - will update this once I get a new model with extra animations in place.
var		bool		Conversation; // Just to check if we are having a conversation. If that's the case, the controls are limited and the camera changes.


///////////////////////////////////////////////////////////////////////////////////////////
// Sounds																VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////
//
// VoicePack
var()		class				VoicePack;
var			JazzVoicePack		VoicePackActor;

var	travel	byte				ColorSetting;			// In-game color selection override
var			texture				BaseSkin;
var			mesh				BaseMesh;

var()		sound				TransmuteSoundOn;
var()		sound				TransmuteSoundOff;
var			texture				TransmuteSkin;
var			mesh				TransmuteMesh;
var			float				TransmuteTime;
//var			float				TransmuteEffectTime;	// If !=0 Transmute in Effect	


///////////////////////////////////////////////////////////////////////////////////////////
// Display Variables													VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////
//
// Camera
var travel globalconfig enum	CameraType				// Camera type in use
{
CAM_None,								// 0) No camera set
CAM_Behind,								// 1) Normal behind-view style
CAM_Roaming								// 2) Crispy roaming style
} CameraInUse;

var vector FadeColor;
var float FadeDepth;
var float FadeRate;

// Level Transition
var float TransitionTime;
var string URL;
var bool  TransitionBlack;

// Roaming
var rotator BasePlayerFacing;
var rotator DesiredFacing,DesiredCameraFacing;

var rotator CameraRotationFrom,CameraRotationCamera;

//var travel bool	UseKevinCamera;			// Whether the new camera should be used.  (Legacy)
//var bool	KevinCameraAvailable;		// Display Kevin Camera selection in A/V list?
var rotator CameraRoaming;				// Current roaming values for camera relative location
var rotator	CameraHistory;
var float	CameraHistoryDeltaTime;
var float	CameraDistHistory;
var bool    CameraFixedBehind;			// False for walking - True for swimming
var actor	ExternalCameraOverride;
var bool	CameraAutoTween;				// Camera is currently automatically tweening to behind the player
var bool	CameraAutoBlocked;				// Camera was last blocked
//
// Text System
//var			JazzText	TextBox;			// Used for Devon's Messaging system
//
// Tutorial System Variables
var		bool			bShowTutorial;
var		bool			bShowPurchase;
var		byte			LastTutorial;		// Last tutorial message
var		travel byte		Tutorial[40];		// Tutorial booleans for determining if action has been done before.
var	localized string	TutorialTitle[40];	// Text for tutorial system messages
var	localized string	TutorialText[40];	// Text for tutorial system messages
var		enum			TutorialNumType		// This contains the predefined tutorial #s that other actors reference
{
	TutorialGetWeaponCell,
	TutorialGetWeapon,
	TutorialRocketBoard,
	TutorialHangGlider,
	TutorialLevelGem
} TutorialNum;

//var(Tutorial)	class<TutorialDisplay>		// TutorialDisplay actors containing the information to display for an event.
//					TutorialDisp[50];		// See TutorialNum above for the tutorial references
var				bool	TutorialActive;		// Is the tutorial system actively checking and displaying tutorials?
//
// Camera Variables
var vector			MyCameraLocation;
var rotator			MyCameraRotation;

// Patch change - Some extra variables for the new camera
var vector			SmoothLocForCam;
//var vector		View;
var vector			CameraDistAdd;
var vector			CamDisplacement;
var vector			TargDisplacement;
var float			CameraDistance;
//var float			ViewDist;

//
// Activation Icon
var		ActivationPlayerIcon	MyActivationIcon;
// 
// Targeting Reticule
var globalconfig texture	TargetIcon;
//
// Current Music volume - for entering menus
var		float 			MusicVolume;

///////////////////////////////////////////////////////////////////////////////////////////
// Damage																VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////
//
// Damage Ratings
//
// % of damage taken from source type
//
var(JDamage)	float	EnergyDamage;
var(JDamage)	float	FireDamage;
var(JDamage)	float	WaterDamage;
var(JDamage)	float	SoundDamage;
var(JDamage)	float	SharpPhysicalDamage;	// Arrow/sword/etc.
var(JDamage)	float	BluntPhysicalDamage;	// Club/mace/rock/etc.
var				float	LastDamageAmount;


///////////////////////////////////////////////////////////////////////////////////////////
// Multiplayer Game Variables											VARIABLES
///////////////////////////////////////////////////////////////////////////////////////////
//

// var THPlayerReplicationInfo THPRI;

// Remove these as they are in the Player replication info now
/*
// How many gems the player has (used for Treasure Hunt mode)
var		int			GemNumber;
// If the player has the key (used for Treasure Hunt mode)
var		bool		TreasureKey;
// The time the player spent in the level
var		float		TreasureTime;
// If the player has finished or not (used for Treasure Hunt mode)
var		bool		TreasureFinish;
*/

// If we are the leader
var		bool		bLeader;
var		float		LeaderGrowEffectTime;
var		float		LeaderDesiredScale;
var		float		OriginalScale;

var		bool		bHasFlag;
var		CTFFlag		TeamFlag;
var	()  bool		bThunderLand;
//var		bool		bSpectate;

var		float		fJump;

var	JTargeting Targeting;

//var		JazzDecalShadow		Shadow;
var 	JazzBlobShadow		Shadow;
var 	JazzFootStep		FootStepDec;
var 	JazzDirtSmoke		JazzDirtPart;

//
var		vector		FaceVec;	// Patch change - This vector is used for the smooth turning motion when running around
var		vector		CamShake;	// Patch change - A new camera shake effect! Used for explosions and such.
var		rotator		CamShakeRot;// Same as above, just used for the camera's rotations.
var		vector		CamBob;		// Patch change - Used mainly for fall damage - only the Z axis is actually used here.
var		vector		CamBobSpeed;// Same as above

var		vector		smoothVel;

//
// Animations
function PlayGrabbing(float tweentime);
function PlayLedgePullup(float tweentime);
function PlayLedgeHang();
function PlayLedgeGrab();


////////////////////////////////////////////////////////////////////////////////////////////
// Network Variable Transfers
////////////////////////////////////////////////////////////////////////////////////////////
//
replication
{
	// Things server should replicate to the client
	unreliable if( Role==ROLE_Authority && bNetOwner )
		InventoryItems,Carrots, Gems, Score, ColorSetting; // , GemNumber, TreasureKey, TreasureTime, TreasureFinish;
	
	// Things the client should send to the server
	reliable if ( Role<ROLE_Authority )
		InvulnerabilityTime,TeamFlag,bHasFlag,bLeader,bThunderLand,TeamChange,bSpectate;
		
	// Functions the server should call
	reliaplayerble if( Role == ROLE_Authority)
		GainLeader, LoseLeader, BecomeSpectator, LeaveSpectator,PickUpFlag;

	// Input variables.
	unreliable if( Role<ROLE_AutonomousProxy )
		DashTime;
}

function ZoneChange( ZoneInfo NewZone )
{
	if (JazzAdvancedZone(NewZone) != None)
	{
		bLedgeGrabOk = !JazzAdvancedZone(NewZone).NoLedgeGrab;
		//Log("ZoneChange) AdvancedZone");
	}
	else
		bLedgeGrabOk = true;
	//Log("ZoneChange) LedgeGrabOk "$bLedgeGrabOk);
}


///////////////////////////////////////////////////////////////////////////////////////////
// Main Tick Function
///////////////////////////////////////////////////////////////////////////////////////////
//
//
event Tick (float DeltaTime)		// Untested
{
	LifeTime += DeltaTime;
}

function PostRender(canvas Canvas)
{
	Super.PostRender(Canvas);
	
	//if (TextBox != NONE)
	//TextBox.DrawText(Canvas);

	// Devon : Windowing system - Render the windows after the HUD
	//
	/*if (WindowsMain != NONE)
	WindowsMain.DrawWindows(Canvas);*/
}

// Try to pause the game.
exec function Pause()
{
	if (Level.DefaultGameType != Class'CalyGame.JazzIntro')
	{
		if (( bShowMenu ) || ( bShowTutorial ))
			return;
		if( !SetPause(Level.Pauser=="") )
			ClientMessage(NoPauseMessage);
	}
}

// Try to set the pause state; returns success indicator.
function bool SetPause( BOOL bPause )
{
	local int MusicVol;
	local int SoundVol;
	
	if( (Level.Game.bPauseable || bAdmin || Level.Netmode==NM_Standalone)
	 && (Level.DefaultGameType != Class'CalyGame.JazzIntro') )
	{
		// Do not change volume when pausing for Tutoral message
		if (!bShowTutorial)
		{
			if ( bPause )
			{
				MusicVolume = int(ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume"));
				
				// Pause
				if (Level.Pauser == "")
				{
					SoundVol = SoundVol * 0.5;
					MusicVol = MusicVolume * 0.5;
				}
						
				Level.Pauser=PlayerReplicationInfo.PlayerName;
			}
			else
			{
				// Unpause
				if (Level.Pauser != "")
				{
					MusicVol = MusicVolume;
				}
						
				Level.Pauser="";
			}
			ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$MusicVol);
		}
		return True;
	}
	else
	{
		MusicVol = MusicVolume;
		return False;
	}
}

// Text Box handling
//
exec function AddText(string Text)
{
	//TextBox.AddText(Text,3+Len(Text)/5);
}

///////////////////////////////////////////////////////////////////////////////////////////
// Starting in Level
///////////////////////////////////////////////////////////////////////////////////////////
//
function PostBeginPlay()
{
	local JTargeting Targ;
	
	// Patch - it is possible to change views now, let's set bBehindView true by default every time!
	
	bBehindView = true;

	// Patch - let's reset the camera location so it doesn't start out from zero point.
	SmoothLocForCam = Location;
	
	// Fading Test
	
	TransitionBlack = false;
	SetToBlack();
	FadeToNormal(10);

	Super.PostBeginPlay();

	// Store original skin and mesh
	BaseSkin = Default.Skin;
	BaseMesh = Default.Mesh;
	
	// Default starting animation
	PlayWaiting();

	/*if(TextBox == None)
	{
		TextBox = spawn(class'JazzText',self);
	}*/

	// Test Lives Display
	//
	ChangeLives(0);
	
	// Windowing system defaults.
	//
	/*if(WindowsMain == None)
	{
		WindowsMain = spawn(class'jazzMainWindows',self);
		WindowsMain.Owner = self;
		WindowsMain.bDisplayWindows = true;
		//WindowsMain.bHasControl = true;
		//WindowsMain.bDisplayCursor = true;
	}*/
	
	
	Targ = Spawn(class'JTargeting',self);
	Targ.SetOwner(self);
	Targeting = Targ;
	// Patch change - We no longer will use the 3d crosshair
	//if (TargetIcon != None) Targ.Texture = TargetIcon;

	// Shadow
	//Shadow = Spawn(class'JazzDecalShadow',self);
	Shadow = Spawn(class'JazzBlobShadow',self);
	Shadow.Size = 0.1;
	Shadow.SetOwner(self);
	
	// Tutorial system defaults
	//
	LastTutorial = -1;

	if (JazzGameInfo(Level.Game).TutorialsInMode==true)
	TutorialActive = true;
	
	// Initialize Camera
	InitializeCamera();
	
	// Force initial player variables (new 19G)
	InitPlayerVariables();
}

function InitPlayerVariables()
{
	// Store original skin & mesh
	if (ColorSetting != 0)
		SpecialChangeSkin(ColorSetting);
	
	// Set ammo to current maximum
	ManaAmmo = ManaAmmoMax;
	ManaRechargeTime = 0;
	// Patch change - now the ammo recharge rate actually changes depending on the difficulty!
	/*if ( Level.Game.Difficulty == 0 )
	{ ManaRechargeRate = 0.05; }
	else if ( Level.Game.Difficulty == 1 )
	{ ManaRechargeRate = 0.1; }
	else if ( Level.Game.Difficulty == 2 )
	{ ManaRechargeRate = 0.5; }
	else if ( Level.Game.Difficulty == 3 )
	{ ManaRechargeRate = 1; }*/ // This is disabled until I can figure out what's wrong with the difficulty settings (They don't really change)
	
	ManaRechargeRate = 0.2;

	// Initialize Camera
	InitCamera();
}

// Travel Post Accept is called after PostBeginPlay when 'travel' variables are replicated
//
event TravelPostAccept()
{
	Log("JazzPlayer) TravelAccept");

	// Perform level event replication
	ReplicateLevelEvents();
	
	InitPlayerVariables();
	
	Super.TravelPostAccept();
}

///////////////////////////////////////////////////////////////////////////////////////////
// Events
///////////////////////////////////////////////////////////////////////////////////////////
//
// See Triggers/ReplicateGameEvent for more detail.
//
function ReplicateLevelEvents()
{
	local ReplicateGameEvent R;
	local JazzItem I;
	local JazzPawn P;
	local byte ReturnValue;
	
	// Unique Game Events
	foreach allactors(class'ReplicateGameEvent', R)
	{
		R.Instigator=Self;
		if (SearchForEvent(R.EventName) >= 0)
		R.PerformCheck(true);
	}

	// Unique Items	
	foreach allactors(class'JazzItem', I)
	{
		if (I.Unique==true)
		{
			if (SearchForEvent(I.UniqueName) >= 0)
			{
				I.Destroy();
			}
		}
	}
	
	foreach allactors(class'JazzPawn', P)
	{
		if (P.UniqueEnemy==true)
		{
			if (SearchForEvent(P.DeathTriggerTag) >= 0)
			{
				P.DeathTrigger();
				P.Destroy();
			}
		}
	}
}

function AddEventDone( name EventName )
{
	// EventNum stores the current available Event, since Unreal starts everything at 0
	// for us where we'd otherwise want -1.  Not important, just keep it in mind.

	// Do not add event if event already exists.
	if (SearchForEvent(EventName) != -1)
	return;

	if (EventNum<200)
	{
		Events[EventNum]=EventName;
		EventNum++;
	}
}

// Return # of event in list or -1 if not found.
//
function float SearchForEvent( name EventName )
{
	local byte e;
	
	for (e=0; e<EventNum; e++)
	{
		if (Events[e]==EventName)
		return(e);
	}
	return(-1);
}

///////////////////////////////////////////////////////////////////////////////////////////
// Input
///////////////////////////////////////////////////////////////////////////////////////////
//
// Note on Input:
//
// In order to avoid having to redo internal Unreal code, we can just use existing useless
// buttons and remap them to what we want to use them for. :)
//
// bStrafe = bSpecialMotion
//

// JazzWindows : Mouse Left and Right instant click handling
//
/*function exec MouseLeftClick()
{
	if (bShowTutorial)
		TutorialEnd();
	else
	if (!bShowMenu)
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(true);
		else
			Fire();
	}
}*/

/*function exec MouseRightClick()
{
	if (bShowTutorial)
		TutorialEnd();
	else
	if (!bShowMenu)
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(false);
		else
			AltFire();
	}
}*/

// JazzWindows : Toggle mouse control in windows
//
/*function exec ToggleWindow(optional bool bForceFalse)
{
	if(bForceFalse)
	{
		WindowsMain.bHasControl = false;
		WindowsMain.bDisplayCursor = false;
	}
	else
	{
		WindowsMain.bHasControl = !WindowsMain.bHasControl;
		WindowsMain.bDisplayCursor = !WindowsMain.bDisplayCursor;
	}
}*/

///////////////////////////////////////////////////////////////////////////////////////////
// Visible Flash - Fading Routines
///////////////////////////////////////////////////////////////////////////////////////////
//
// Thanks to Robert Allen for Fading
//
function ViewFlash(float DeltaTime)
{
	local vector goalFog;
	local float goalscale, delta;
	
	// Do not allow anything but black at this special point
	if (TransitionBlack) SetToBlack();
	
	delta = FMin(0.1, DeltaTime); //<--- the most amount of delta per tick is 0.1
	goalScale = 1 
				+ DesiredFlashScale 
				+ ConstantGlowScale 
				+ HeadRegion.Zone.ViewFlash.X
				+ FadeDepth; 
	goalFog = DesiredFlashFog 
				+ ConstantGlowFog 
				+ HeadRegion.Zone.ViewFog
				+ FadeColor;
	DesiredFlashScale -= DesiredFlashScale * 2 * delta;  
	DesiredFlashFog -= DesiredFlashFog * 2 * delta;
	FlashScale.X += (goalScale - FlashScale.X) * 0.1 * delta * FadeRate;
	FlashFog += (goalFog - FlashFog) * 0.1 * delta * FadeRate;

	if ( FlashScale.X > 0.990 )
		FlashScale.X = 1; // AHA! This is why > 1 didn't do anything
		
	FlashScale = FlashScale.X * vect(1,1,1);

	if ( FlashFog.X < 0.019 )
		FlashFog.X = 0;
	if ( FlashFog.Y < 0.019 )
		FlashFog.Y = 0;
	if ( FlashFog.Z < 0.019 )
		FlashFog.Z = 0;
}

// Recommend speed of 30
//
function FadeToBlack(int NewFadeRate) 
{
	FadeColor = vect(0,0,0);
	FadeDepth = -1;
	FadeRate = NewFadeRate;
}

function FadeToNormal(int NewFadeRate)
{
	FadeColor = vect(0,0,0);
	FadeDepth = 0;
	FadeRate = NewFadeRate;
}

function SetToBlack ()
{
	FlashScale.X = 0;
}

function SetToNormal ()
{
	FlashScale.X = 1;
}


///////////////////////////////////////////////////////////////////////////////////////////
// Damage Routines
///////////////////////////////////////////////////////////////////////////////////////////
//
function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
}

function SpawnGibbedCarcass()
{
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	local bool		bAlreadyDead;
	local MultiStar M;
	
	
	//local ActorShieldHitEffect PainRed;
	
	// Patch Change - a new flashing effect when an actor is hurt.
	// This effect is disabled for Jazz for now, since it has a wierd bug where if you would get
	// hurt before you hurt an enemy, the effect will not appear throughout the level.
	
	// Perhaps a different effect is more suitable for Jazz anyway?
	//PainRed = spawn(class'ActorShieldHitEffect');
	//PainRed.SetOwner(Self);

	// Invulnerability still in effect?
	if (InvulnerabilityTime<=0 && !bGodMode)
	{
		switch (damageType)
		{
			case 'Energy':
				Damage *= EnergyDamage;
				LastDamageAmount = Damage;
			break;
		
			case 'Fire':
				Damage *= FireDamage;
				LastDamageAmount = Damage;
			break;
			
			case 'Water':
				Damage *= WaterDamage;
				LastDamageAmount = Damage;
			break;
			
			case 'Sound':
				Damage *= SoundDamage;
				LastDamageAmount = Damage;
			break;
			
			case 'Sharp':	// Pointed object physical damage (arrow/sword/etc)
				Damage *= SharpPhysicalDamage;
				LastDamageAmount = Damage;
			break;
				
			case 'Blunt':	// Blunt object physical damage (club/mace/rock/etc)
				Damage *= SharpPhysicalDamage;
				LastDamageAmount = Damage;
			break;
		}
	
		if (Damage<1)
		{
			Damage=0;
			VoicePackActor.DoSound(Self,VoicePackActor.PlinkSound);
		}
		else
		{
			if (damageType != 'NoStar')
			{
				M = spawn(class'MultiStar',Self);
				M.MultiSpawn(Damage/5+1);
			}

			
			// Update HUD
			//JazzHUD(MyHUD).UpdateHealth();
	
			// No?  Then get hurt.
			InvulnerabilityTime = InvulnerabilityDuration;
			VoicePackActor.DamageSound(Self,float(Damage)/float(HealthMaximum));

			// Stolen code from Pawn class - redoing Unreal's oddly unworking stuff.
			//if (Physics == PHYS_Walking) // Patch change - we want this kind of stuff to work in mid-air as well!
				momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
			momentum = momentum/Mass;
			AddVelocity( momentum ); 
				
			Damage = Level.Game.ReduceDamage(Damage, DamageType, self, instigatedBy);
			bAlreadyDead = (Health <= 0);
			Health -= Damage;
			
			CamShake = VRand()*25; // Patch change - let's make the camera randomly change it's position to further indicate the damage!
			CamShakeRot.Roll = -3000+rand(6000); // Same as above, just camera's rotations.
			
			if (CarriedDecoration != None)	// Drop carried decoration
				DropDecoration();
			
			
			if ((Health<=0) && ( !bAlreadyDead ))
			{
				NextState = '';
				PlayDeathHit(Damage, hitLocation, damageType, Momentum);
				Enemy = instigatedBy;
				Died(instigatedBy, damageType, HitLocation);
			}
			
			MakeNoise(1.0);
			
			//Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		}
	}
	else
	{
	VoicePackActor.DoSound(Self,VoicePackActor.PlinkSound);
	}
}

function Carcass SpawnCarcass()
{
	return None;
}

function PlayTakeHitSound(int damage, name damageType, int Mult)
{
	if ( Level.TimeSeconds - LastPainSound < 0.3 )
		return;
	LastPainSound = Level.TimeSeconds;
	
	//VoicePackActor.DoSound(Self,VoicePackActor.DashSound);
	//PlaySound(HurtDefaultSound);
}



// General Effect Duration
//
function bool EffectToggle ( bool Effect, float EffectTime )
{
	// Flicker Player
	if ((Effect == false) || (EffectTime>0.5))
	Effect = true;
	else
	Effect = false;
	
	if (EffectTime<=0)	Effect = false;
	
	return( Effect );
}

// Transmutation functionality
//
function TransmuteToMesh ( mesh NewMesh, texture NewSkin, name ASequence, float AFrame, float NewTime )
{
	// Initiate Transmute effect
	//
	// Transmute effect is 
	// <0 = Transmuting Back
	// >0 = Transmute Into
	// 
	
	if ((TransmuteTime>0) && (TransmuteTime<9))	// Currently transmuted
	{
		TransmuteTime = -1;
	}
	else
	if (TransmuteTime<0)	// Transmuting back
	{
		// Nothing happens - can't interrupt effect
	}
	else					// No Transmute Effect Currently
	{
		PlaySound(TransmuteSoundOn);
		TransmuteMesh = NewMesh;
		TransmuteSkin = NewSkin;
//		AnimSequence = ASequence;
//		AnimFrame = AFrame;
		AnimSequence = '';
		AnimFrame = 0;
		TransmuteTime = NewTime;
	}
}

// Return to default texture
//
function ReturnToDefaultSkin ()
{
	if (BaseSkin != None)
	Skin = BaseSkin;
	Texture = Default.Texture;
}
function ReturnToDefaultMesh ()
{
	
}

// Zone/special event skin selection
//
// Subclass and alter.
//
function SpecialChangeSkin( byte Color )
{
	Texture = Skin;
	BaseSkin = Skin;

	ColorSetting = Color;	
}

// Multiplayer skin selection
function ServerChangeSkin(coerce string SkinName, coerce string FaceName, byte TeamNum)
{
	local texture NewSkin;
	local string MeshName;

	MeshName = GetItemName(string(Mesh));
	if ((Left(SkinName, Len(MeshName)) ~= MeshName) )
	{
		NewSkin = texture(DynamicLoadObject(SkinName, class'Texture'));
		if ( NewSkin != None )
		{
			Skin = NewSkin;
			BaseSkin = NewSkin;
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// Environment Activation / Conversation								GAMEPLAY
//////////////////////////////////////////////////////////////////////////////////////////////	
//
// This is the Use Item command.
//
exec function UseItem()
{
	if ((bShowTutorial))
		TutorialEnd();
	else
	MyActivationIcon.DoActivate();
}

function CheckActivationObjects()
{
	// Trace in front of player for an object/NPC that can be activated.
	//
	// Implement a delay for switching to a different object when one already selected
	// and/or a delay for removing the focus after turning away.
	//

/*intrinsic(277) final function Actor Trace
(
	out vector      HitLocation,
	out vector      HitNormal,
	vector          TraceEnd,
	optional vector TraceStart,
	optional bool   bTraceActors,
	optional vector Extent
);*/
	
	local vector 	HitLocation,HitNormal;
	local actor 	Result;
	local bool		ActorFound;
	
	if (MyActivationIcon != None)
	{

		Result = Trace( HitLocation, HitNormal, 
			Location + (100 * vector(Rotation)), Location );

		if (Result != None)
		{
			if (JazzGameObjects(Result) != None)
			{
				MyActivationIcon.Show(Result);
				ActorFound = true;
			}
			else
			if (JazzPawn(Result) != None)
			{
				if (JazzPawn(Result).Activateable == true)
				{
					MyActivationIcon.Show(Result);
					ActorFound = true;
				}
			}
		}
	
		// No actor found - deactivate icon?
		//
		if (ActorFound == false)
		{
			MyActivationIcon.Hide();
			ActorFound = false;
		}
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// Timed Effects														SPECIAL EFFECTS
//////////////////////////////////////////////////////////////////////////////////////////////	
//
event PlayerTick ( float DeltaTime )
{
	local float   	TestValue;
	local vector  	convoLoc;
	local vector  	targLoc;
	local vector  	SmokLoc;
	local float		b;
	
	// Patch change - the new particle effects appear all the time when we run!
	if ( Physics == PHYS_Walking && (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) > 50000)
	{
		b -= DeltaTime;
		if (b<0.0)
		{
			b = 50000.0;
			
			SmokLoc = VRand()*10;
			SmokLoc.Z = -40;
			
			JazzDirtPart = Spawn(class'JazzDirtSmoke',self);
			JazzDirtPart.NewLocation = Location+SmokLoc;
			if ( DashTime > 0 )
			{
				JazzDirtPart.Velocity.Z = sqrt(abs(velocity.X)+abs(Velocity.Y))*0.05;
				JazzDirtPart.DrawScale = 0.2+Rand(0.2);
			}
		}
	}
	
	//smoothVel += (Velocity-smoothVel)*DeltaTime*3;
	
	// Default Camera
	//
	CameraHistoryDeltaTime += DeltaTime;
	
	if (JazzHUD(MyHUD) != None)
	if (JazzHUD(MyHUD).ConversationTrapButton())
	{ Conversation = true; }
	else
	{ Conversation = false; }
	
	if (Conversation)
	{
		convoLoc = JazzHUD(MyHUD).ConvFocus.Location+(Location-JazzHUD(MyHUD).ConvFocus.Location)*0.5;
		SmoothLocForCam += (convoLoc - SmoothLocForCam)*DeltaTime*10; // target location
		//CameraLocation = SmoothLocForCam+(ViewDist - WallOutDist)*-View;
		
		ViewRotation.Pitch = 0;
		ViewRotation.Yaw = JazzHUD(MyHUD).ConvFocus.Rotation.Yaw+16384;
		
		/*targLoc = (SmoothLocForCam - MyCameraLocation);
		// costum rotation
		TestValue = targLoc.Y/targLoc.X;
		if (targLoc.X<0)
		ViewRotation.Yaw = -16384-(16384-atan(TestValue)/3.142857/2*65536);
		else
		ViewRotation.Yaw = (atan(TestValue)/3.142857/2*65536);

		ViewRotation.Pitch = 0.0;//atan(targLoc.Z/
				//sqrt(abs(targLoc.X*targLoc.X+targLoc.Y*targLoc.Y)))
					///3.142857/2*65536;
					*/
	}
	else
	{
		if (bAltFire == 1)
		{
			CameraDistance += (50 - CameraDistance)*DeltaTime*10;
			TargDisplacement.Z += (40 - TargDisplacement.Z)*DeltaTime*10;
		}
		else
		{
			CameraDistance += (190 - CameraDistance)*DeltaTime*10;
			TargDisplacement.Z += (50 - TargDisplacement.Z)*DeltaTime*10;
		}
		SmoothLocForCam += (Location+TargDisplacement - SmoothLocForCam)*DeltaTime*10; // target location
	}

	// Decrease Ledge Grab Delay
	//
	if (LedgeCheckDelay>0)
	LedgeCheckDelay -= DeltaTime;
	
	// Patch change - If Noclip is on, let's change our state!
	if (bNoclip)
	{
		//GotoState('Noclip'); // Couldn't get this to work :/
		//if (!IsInState('PlayerSwimming'))
		//{ GotoState('PlayerSwimming'); }
		
		SetPhysics(PHYS_Walking);
		Setcollision( false , false , false );
		bCollideWorld = False;
		if (AnimSequence != 'JazzFall')
		{ TweenAnim('JazzFall',0.1); }
		else
		{ LoopAnim('JazzFall'); }
		
		AnimRate = 0.5;
	}

	// Check for activation object/NPC in front of player 
	//
	CheckActivationObjects();
	
	// Player Invulnerability Display
	//
	if (InvulnerabilityTime>0)
	{
		InvulnerabilityTime -= DeltaTime;
		InvulnerabilityEffect = EffectToggle(InvulnerabilityEffect,InvulnerabilityTime);		
		
		if (InvulnerabilityEffect)
		Style = STY_Modulated;
		else
		Style = STY_Normal;
	}

	// Ammo Recharge
	//
	if (ManaRechargeRate==0) { InitPlayerVariables(); }		// Varibles not set?
	if (ManaAmmo>ManaAmmoMax) { ManaAmmo = ManaAmmoMax; }
	ManaRechargeTime += DeltaTime;
	if(ManaRechargeTime >= ManaRechargeRate)
	{
		ManaRechargeTime -= ManaRechargeRate;
		if (ManaAmmo<ManaAmmoMax && bFire == 0 && bAltFire == 0)
		{ ManaAmmo += 0.5; }
	}	// Changed from 'While' to 'If'

	// Player Poison Timer
	//
	if (PoisonTime>0)
	{
		PoisonTime -= DeltaTime;
		PoisonEffect = EffectToggle(PoisonEffect,PoisonTime);
		
		if (PoisonEffect)
		{
			Skin = PoisonTexture;
			Texture = PoisonTexture;
		}
		else
		{
			ReturnToDefaultSkin();
		}
	}
	
	// Player Fire Timer
	//
	if (FireTime > 0)
	{
		FireTime -= DeltaTime;
		FireEffect = EffectToggle(FireEffect,FireTime);
		
		if (FireEffect)
		{
			if (Physics == Phys_Swimming)
			{ BurnEnd(); }
			//Health -= 1; // Patch change - Jazz takes damage while he is on fire
			// Take damage
		}
		else
		{
			BurnEnd();
		}
	}
	
	// Player Trails - Initiated from other than Dash
	//
	if (TrailTime>0)
	{
		TrailTime -= DeltaTime;
	}
	
	// Do Player Trail
	//
	if ((TrailTime>0) || (DashTime>0))
	{
		DoPlayerTrail();
	}
	
	// Transmutation Effect
	//
	if (TransmuteTime>0)
	{
		if (TransmuteTime>9.5)
		{
			Style = STY_Translucent;
			ScaleGlow = 1-(10-TransmuteTime)*2;
		}
		else
		if (TransmuteTime>9)
		{
			Skin=TransmuteSkin;
			Texture=TransmuteSkin;
			Mesh=TransmuteMesh;
			ScaleGlow = ((9.5-TransmuteTime)*2);
		}
		else
		{
			Style = STY_Normal;
			Skin=TransmuteSkin;
			Texture=TransmuteSkin;
			Mesh=TransmuteMesh;
			ScaleGlow = 1;

			if (TransmuteTime<1)
			TransmuteTime=-TransmuteTime;
		}
		TransmuteTime -= DeltaTime;
	}
	else
	if (TransmuteTime<0)
	{
		if (TransmuteTime<-0.5)
		{
			Style = STY_Translucent;
			Skin=TransmuteSkin;
			Texture=TransmuteSkin;
			Mesh=TransmuteMesh;
			ScaleGlow = ((-(TransmuteTime+0.5))*2);
			
			TransmuteTime += DeltaTime;
			if (TransmuteTime>=-0.5)
			{
			PlaySound(TransmuteSoundOff);
			ReturnToDefaultSkin();
			Mesh = BaseMesh;
			AnimEnd();
			}
		}
		else
		if (TransmuteTime<0)
		{
			Style = STY_Translucent;
			ReturnToDefaultSkin();
			Mesh = BaseMesh;
			ScaleGlow = 1-(-TransmuteTime)*2;
			TransmuteTime += DeltaTime;
			if (TransmuteTime>=0)
			{
				TransmuteTime = 0;
				ReturnToDefaultSkin();
				Mesh = BaseMesh;
				Style = STY_Normal;
				ScaleGlow = 1;
			}
		}
	}

	// Leader Effect
	//	
	if (LeaderGrowEffectTime>0)
	{
		LeaderEffectTick ( DeltaTime );
	}
	
	// Visibility
	//
	UpdateVisibility();
}

// Touching Others Spreads an Effect
//
function Touch( actor Other)
{
	Super.Touch(Other);
	if(Other.IsA('JazzPlayer'))
	{
		if (FireEffect)				///// Fire
			JazzPlayer(Other).Burn();
	}
	else if(Other.IsA('JazzPawn'))
	{
		if (FireEffect)				///// Fire
			JazzPawn(Other).Burn();
	}
	else if(Other.IsA('JazzDecoration'))
	{
		if (FireEffect)				///// Fire
		{	//JazzDecoration(Other).Burn(); 
		}
	}
}

// Noclip cheat - this was trickier than I previously thought
exec function Noclip()
{
	if ( !bAdmin && (Level.Netmode != NM_Standalone) )
		return;

	if ( bNoclip )
    {
		SetCollision(true,true,true);
		bCollideWorld = True;
		bBlockActors = true;
		bBlockPlayers = true;
		bNoclip = false;
		GotoState('PlayerWalking');
		ClientMessage("No clipping off");
		return;
	}
	
	bBlockActors = false;
	bBlockPlayers = false;
	bNoclip = true;
	ClientMessage("No clipping on");
}
	
// Burn Effect
//
// As suggested by Devon, I modified the fire effect to no longer use a state to maintain
// compatibility.
//
// All effects consist of:
//   [Name]Time		(FireTime/PoisonTime)		Time remaining on effect
//	 [Name]Effect	(FireEffect/PoisonEffect)	If effect is currently active
//
// Effect on and off functions should start and end an effect, in general.  While the
// effect timing is taken care of in PlayerTick.
//
exec function Burn()
{	
	//local JazzFireEffect	F; // Patch Change - let's use a different effect here
	local FireParticleGen	F;
	//TODO: Check for some kind of resistance to affects
	if(FireTime<=0)
	{
		AbruptFireHalt();
		
		// Start the burning process
		FireTime = 15;	// Burn for 15 seconds
		
		// Initiate Fire Effect
		// Patch Change - let's spawn a different effect here
		// - this will spawn independent particles that will stay in their own position
		F = Spawn(class'FireParticleGen',Self);
		F.LifeTime = FireTime;
		F.SetOwner(self);
		
		//F = Spawn(class'JazzFireEffect',Self);
		//F.SetBase(Self);
		//F.Activate(3,1,75,70,true,0.2);
	}
}

function BurnEnd()
{
	//local JazzFireEffect	F;
	local FireParticleGen	F;

	// Remove fire special effect
	//foreach ChildActors(class'JazzFireEffect',F)
	foreach ChildActors(class'FireParticleGen',F)
	{
		F.Destroy();
	}	
}


// Petrify Effect
//
function Petrify()
{
	//TODO: Check for some kind of resistance to affects
	if(IsInState('Petrified'))
	{
		EffectTime += 2;
	}
	else
	{
		AbruptFireHalt();
		GotoState('Petrified');
	}
}

state Petrified
{
	ignores Fire,AltFire;
	
	// TODO: Stop player from taking damage when petrified
	// TODO: Stop player from being able to shoot when petrified
	// TODO: Let player edge around a bit when petrified and make it lower petrification time
	function BeginState()
	{
		SetPhysics(PHYS_Falling);
		Acceleration = vect(0,0,0);
		Skin = PetrifyTexture;
		//PlayAnim('');
		EffectTime = 10;
		fJump = 0;
	}
	
	event PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;
		
		if(fJump <= 0)
		{
			GetAxes(Rotation,X,Y,Z);
			
			if(Physics != PHYS_Falling)
			{
				if(bEdgeForward && bWasForward)
				{
					Velocity += X*20;
				}
				else if(bEdgeBack && bWasBack)
				{
					Velocity -= X*20;
				}
				
				if(bEdgeLeft)
				{
					Velocity -= Y*20;
				}
				else if(bEdgeRight)
				{
					Velocity += Y*20;
				}
				
				if(bEdgeForward || bEdgeBack || bEdgeLeft || bEdgeRight)
				{
					Velocity.Z = 25;
					
					fJump = 0.75;
					
					SetPhysics(PHYS_Falling);
				}
			}
		}
		bPressedJump = false;
	}
	
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
		
		EffectTime -= DeltaTime;
		
		fJump -= DeltaTime;
		
		PlayerMove(DeltaTime);
		
		if(EffectTime <= 0)
		{
			ReturnToDefaultSkin();
			// TODO: Check to see if the player needs to be in a different state
			ReturnToNormalState();
		}
	}
	
/*	function exec MouseLeftClick()
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(true);
	}*/
	
/*	function exec MouseRightClick()
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(false);
	}*/
	
	function Freeze();
	function Burn();
}

///////////////////////////////////////////////////////////////////////////////////
// Bubble Effect
///////////////////////////////////////////////////////////////////////////////////
//
function Bubble()
{
	//TODO: Check for some kind of resistance to affects
	if(IsInState('Bubble'))
	{
		// Do nothing
	}
	else
	{
		AbruptFireHalt();
		GotoState('Bubbled');
	}
}

state Bubbled
{
	ignores Fire,AltFire;
	
	function BeginState()
	{
		SetPhysics(PHYS_Falling);
		Acceleration = vect(0,0,0);
		//PlayAnim('');
		EffectTime = 5;
		
		Spawn(class'BubbledEffect',Self);
	}
	
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		// We should get out of the bubble state once we've been shot or taken any form of damage
		EffectTime = 0;
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}		
	
	function EndState()
	{
		local BubbledEffect Bubble;
		
		foreach ChildActors(class'BubbledEffect',Bubble)
		{
			Bubble.Destroy();
		}
		ReturnToDefaultSkin();
	}
	
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
		EffectTime -= DeltaTime;

		if(EffectTime <= 0)
		{
			ReturnToNormalState();
		}
	}
}

// Freeze Effect
//
function Freeze(optional int Level)
{
	//TODO: Check for some kind of resistance to affects
	if(IsInState('Frozen'))
	{
		EffectTime += 2;
	}
	else
	{
		if (Level==0)
		EffectTime = 1;
		else
		EffectTime = Level;
		
		AbruptFireHalt();
		GotoState('Frozen');
	}
}

state Frozen
{
	ignores Fire,AltFire;
	
	function BeginState()
	{
		SetPhysics(PHYS_Falling);
		Acceleration = vect(0,0,0);
		Skin = FrozenTexture;
		//PlayAnim('');
	}
	
	event PlayerMove(float DeltaTime)
	{
		if(aForward != 0 && aTurn != 0 && aStrafe != 0)
		{
			EffectTime -= DeltaTime/4;
		}
		bPressedJump = false;
	}
	
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
		EffectTime -= Damage/10;
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}
	
	/*function UpdateRotations()
	{
		DesiredRotation = ViewRotation; //save old rotation
		ViewRotation.Pitch += 8.0 * DeltaTime * aLookUp;
		ViewRotation.Pitch = ViewRotation.Pitch & 65535;
		If ((ViewRotation.Pitch > 17000) && (ViewRotation.Pitch < 50000))
		{
			If (aLookUp > 0) 
				ViewRotation.Pitch = 17000;
			else
				ViewRotation.Pitch = 50000;
		}
		switch (CameraInUse)
		{
			case CAM_Behind:
				ViewRotation.Yaw += 16.0 * DeltaTime * aTurn;
				
			break;
			case CAM_Roaming:
				ViewRotation.Yaw = (ViewRotation.Yaw + 
					RotateTowardYaw(BasePlayerFacing.Yaw-DesiredFacing.Yaw,ViewRotation.Yaw,DeltaTime*5));
			
		break;
		}
	}*/
	
	function Burn()
	{
		ReturnToNormalState();
	}
	
	event PlayerTick(float DeltaTime)
	{
		Global.PlayerTick(DeltaTime);
		EffectTime -= DeltaTime;
		
		PlayerMove(DeltaTime);
		
		if(EffectTime <= 0)
		{
			ReturnToDefaultSkin();
			// TODO: Check to see if the player needs to be in a different state
			ReturnToNormalState();
		}

		Acceleration /= 1.35;
	}

	function Bump( actor Other)
	{
		if(PlayerPawn(Other) != None)
		{
			Acceleration += (Other.Velocity / 0.4);
		}
	}	
	
/*	function exec MouseLeftClick()
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(true);
	}*/
	
/*	function exec MouseRightClick()
	{
		if(WindowsMain.bHasControl)
			WindowsMain.MouseClick(false);
	}	*/
}


//////////////////////////////////////////////////////////////////////////////////////////////	
// Dash Trails															SPECIAL EFFECTS
//////////////////////////////////////////////////////////////////////////////////////////////	
//
simulated function DoPlayerTrail ()
{
	local JazzPlayerTrailImage Image;
	Image = spawn(class'JazzPlayerTrailImage');
	Image.AnimFrame = AnimFrame;
	Image.AnimRate = 0;
	Image.AnimSequence = AnimSequence;
	Image.Mesh = Mesh;
	Image.Skin = Skin;
	Image.DrawScale = DrawScale;
	Image.InitialScaleGlow = DashTime;
}

function PlayDashSound()
{
	VoicePackActor.DoSound(Self,VoicePackActor.DashSound);
	//PlaySound(DashSound, SLOT_Interact, 1, false, 1000.0, 1.0);
}


simulated function PlayerTrailTime ( float Duration )
{
	TrailTime = Duration;
}
//////////////////////////////////////////////////////////////////////////////////////////////	
// Initialization														INITIALIZATION
//////////////////////////////////////////////////////////////////////////////////////////////	
//
function ServerReStartPlayer()
{
	if ( Level.NetMode == NM_Client )
		return;
	if( Level.Game.RestartPlayer(self) )
	{
		ServerTimeStamp = 0;
		TimeMargin = 0;
		Level.Game.StartPlayer(self);
		ClientReStart();
	}
	else
		log("Restartplayer failed");
		
	ReturnToDefaultSkin();
	
	// Reset Weapon
	if (Weapon == None)
	JazzWeapon(Weapon).ChangeWeapon(0);
	if (Weapon != None)
	JazzWeapon(Weapon).ChangeCell(0);
	
	// Reset Weapon
	if (InventorySelections[0] != None)
	{
	JazzWeaponCell(InventorySelections[0]).ChargeEnd();
	JazzWeaponCell(InventorySelections[0]).GotoState('Idle');
	}
}

function PreBeginPlay()
{
	Super.PreBeginPlay();

	// Set LedgeGrab to ok initially
	bLedgeGrabOk = true;

	// Game Setup
	ManaAmmoMax = 100;
	ManaAmmo = ManaAmmoMax;

	// Turn Rate Maximum Set
	TurnSpeedMax = 2000;
	TurnAccel = 200;

	// DoubleJump
	DoubleJumpAlready = false;

	// Voice Pack System Initialize
	VoicePackActor = JazzVoicePack(spawn(class<actor>(VoicePack)));
	
	// Create activation icon
	MyActivationIcon = spawn(class'ActivationPlayerIcon',Self);
	MyActivationIcon.SetOwner(Self);

	// Set default camera to use
	if (CameraInUse == CAM_None)
		CameraInUse = CAM_Behind;
	InitCamera();
	

	/*if(TextBox == None)
	{
		TextBox = spawn(class'JazzText',self);
	}*/
}

event PreRender( canvas Canvas )
{
	Super.PreRender(Canvas);
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// Initialization														INITIALIZATION
//////////////////////////////////////////////////////////////////////////////////////////////	
//
//
function InitializeCamera()
{
	CameraDistHistory = 50;
}


//////////////////////////////////////////////////////////////////////////////////////////////	
// Camera Functions
//////////////////////////////////////////////////////////////////////////////////////////////	
//
function NextCameraType ()
{
	switch (CameraInUse)
	{
		case CAM_Behind:		CameraInUse = CAM_Roaming;	break;
		case CAM_Roaming:		CameraInUse = CAM_Behind;	break;
	}
	InitCamera();
}

function InitCamera ()
{
	// Init camera system in new type
	
	switch (CameraInUse)
	{
	case CAM_Roaming: // CAM_Roaming: // Patch change - the roaming camera is not needed anymore ( One type of camera will do all needed stuff )
		//
		// Set base direction to current facing
		//
		BasePlayerFacing = Rotation;
		break;
	}
}

function bool CheckForExternalCamera(out vector CameraLocation, out rotator CameraRotation)
{
	local JazzFixedCamera XCam;
	local vector HitLocation;
	local float TestValue;

	// Scan for External Cameras
	//
	//ExternalCameraOverride = None;
	foreach allactors(class'JazzFixedCamera', XCam)
	{
		if (FastTrace(HitLocation,Location)==true)
		ExternalCameraOverride = XCam;	
	}
	
	// External Camera Viewpoint Calculation
	//	
	if (ExternalCameraOverride != None)	// Is there an external camera to use instead?
	{
		// External Camera code
		if (ExternalCameraOverride.IsA('JazzThirdPersonCamera'))
		{
			CameraLocation = ExternalCameraOverride.Location;
			HitLocation = SmoothLocForCam;
			CameraRotation.Roll = 0.0;

			TestValue = HitLocation.Y/HitLocation.X;
			if (HitLocation.X<0)
			CameraRotation.Yaw = -16384-(16384-atan(TestValue)/3.142857/2*65536);
			else
			CameraRotation.Yaw = atan(TestValue)/3.142857/2*65536;

			CameraRotation.Pitch = atan(HitLocation.Z/
					sqrt(abs(HitLocation.X*HitLocation.X+HitLocation.Y*HitLocation.Y)))
						/3.142857/2*65536;
		}
		else
		{
			CameraLocation = ExternalCameraOverride.Location;
			HitLocation = (Location-ExternalCameraOverride.Location);
			TestValue = HitLocation.Y/HitLocation.X;
			if (HitLocation.X<0)
			CameraRotation.Yaw = -16384-(16384-atan(TestValue)/3.142857/2*65536);
			else
			CameraRotation.Yaw = atan(TestValue)/3.142857/2*65536;
				
			CameraRotation.Pitch = atan(HitLocation.Z/
					sqrt(abs(HitLocation.X*HitLocation.X+HitLocation.Y*HitLocation.Y)))
						/3.142857/2*65536;
		}
		return true;
	}
	else
	{
		HitLocation = SmoothLocForCam;
	}
	return false;
}

////////////////////// Redo External Viewpoint
//
event PlayerCalcView( out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	CameraInUse = CAM_Behind; // Patch Change - Roaming camera is no longer used.
	// So for the sake of my free time, I'm just setting it to Behind at all times.
	
	if (CheckForExternalCamera(CameraLocation,CameraRotation))
	{
		if (!ExternalCameraOverride.IsA('JazzThirdPersonCamera'))
		{ return; }
	}

	if (bHidden==true)
	{
		Super.PlayerCalcView(ViewActor,CameraLocation,CameraRotation);
		return;
	}

	// Special swimming characteristics
	// Patch change - only one type of camera is used now. Special cameras for swimming are no longer needed.
	//if (Physics==PHYS_Swimming)
	//{
		//PlayerCalcViewBehind(ViewActor,CameraLocation,CameraRotation);
	//}
	//else
	//{
		// Current camera to use
		switch (CameraInUse)
		{
		case CAM_Behind:
			PlayerCalcViewBehind(ViewActor,CameraLocation,CameraRotation);
			break;
			
		//case CAM_Roaming:
		//	PlayerCalcViewRoam(ViewActor,CameraLocation,CameraRotation);
		//	break;
		}
	//}

	// Store location of camera for other uses
	MyCameraLocation = CameraLocation;
	MyCameraRotation = CameraRotation;
}

function bool CameraBlockedCheck ( out rotator CameraRotation, out float ViewDist, float WallOutDist, float ViewMax, float ViewChange, float ViewDistIncrease )
{
	local vector HitLocation,HitNormal;

	local bool ViewBlocked;
	local int ExtrapolateLevel;

	ViewBlocked = true;					// View is currently blocked
	ExtrapolateLevel = 10;				// Precision level to check to
		
	while ((ExtrapolateLevel>0))
	{
		//CameraForwardHack += ViewChange*0.9;
		CameraRotation.Yaw -= ViewChange;
		
		ViewDist += ViewDistIncrease;
		
		if (!bNoclip)
		{ ViewBlocked = !(Trace( HitLocation, HitNormal, SmoothLocForCam - (ViewDist+WallOutDist) * vector(CameraRotation), SmoothLocForCam, false ) == None); }
		else
		{ ViewBlocked = false; }

		if ((!ViewBlocked)
			||
			((CameraRotation.Yaw > ViewMax) && (ViewChange<0))
			||
			((CameraRotation.Yaw < ViewMax) && (ViewChange>0))
			)
		{			
			// Extrapolate to next precision level
			ExtrapolateLevel -= 1;
						
			if (ExtrapolateLevel>0)
			{
			ViewMax = CameraRotation.Yaw;
			//CameraForwardHack -= ViewChange*0.9;
			CameraRotation.Yaw += ViewChange;
			ViewDist -= ViewDistIncrease;
						
			ViewChange /= 2;
			ViewDistIncrease /= 2;
			}
		}
	}
	
	return(ViewBlocked);
	//
	// End of New Check
}

// Behind View camera - Attempts to stay behind the player at all times and rotate upwards
// if blocked.
//
event PlayerCalcViewBehind( out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
{
	local vector View,HitLocation,HitNormal;
	local float ViewDist,OldViewDist,WallOutDist,NewDist,ViewDistIncrease,ViewDistA;
	local int	ExtrapolateLevel;
	local float ViewMax;
	local float ViewChange;
	local bool ViewBlocked;
	local float BaseYaw;
	local float BasePitch,LowPitch;
	local rotator NewRotation;
	local float LastDistance,NewDistance,OrigDistance;
	
	local rotator DesiredRotationFrom,DesiredRotationCamera;
	
	local float TestPitch,Temp;
	local float TestValue;
	local float ViewBest,ViewBestPitch,ViewBestDist,PitchA;

	local JazzFixedCamera	XCam;
	local actor				Result;
	
	local float CameraForwardHack,OldCameraForwardHack,CameraForwardHackA;	// Angle the camera towards ahead of Jazz if he's near a wall
	local bool  IgnoreBlockedCamera;
	local bool  CheckDownwardRotation;

	//bBehindView = true;	// Force bBehindView On for Jazz Viewpoint

	// View rotation.
	CameraRotation = ViewRotation+CamShakeRot;
	
	if( bBehindView ) //up and behind
	{
			if (CameraZone(Region.Zone) == None)		// Camera Zone?
			{
				// Normal Camera Angle
				//
				// Normal: Player is not in CameraFacing Zone and uses normal camera motion.
				// Default camera rotation to attempt first.
				if (CameraFixedBehind)
				{ CameraRotation.Pitch = ViewRotation.Pitch - 4000; }
				else
				{ CameraRotation.Pitch = 0 - 4000; }

				// Reduce distance from player
				if (ViewRotation.Pitch<20000)
				{
					TestPitch = ViewRotation.Pitch;
					if (CameraFixedBehind==false)
						CameraRotation.Pitch += ViewRotation.Pitch*0.5;
				}
				else
				{
					TestPitch = -(65536-ViewRotation.Pitch)*0.7;
					if (CameraFixedBehind==false)
						CameraRotation.Pitch += -(65536-ViewRotation.Pitch)/1.5;
				}

			    ViewDist = 200 - abs(TestPitch/200);		    
			    ViewDistIncrease = 0;
				WallOutDist = 15;
			
				//CameraRotation.Yaw = ViewRotation.Yaw;
				if (CameraRotation.Pitch > 30000) CameraRotation.Pitch -= 65536;
				
				// Store unaltered pitch
				BasePitch = CameraRotation.Pitch;
			
				CameraHistoryDeltaTime = CameraHistoryDeltaTime * 0.95;
				if (CameraHistoryDeltaTime < 0.1) { CameraHistoryDeltaTime = 0.1; }
				if (CameraHistoryDeltaTime > 1) { CameraHistoryDeltaTime = 1; }
			
				// Camera Distance History
				//if ((CameraDistHistory>0) && (abs(CameraDistHistory-ViewDist)>5))
				//ViewDist += (CameraDistHistory - ViewDist)*(0.9);
				// Temporarily removed because of too much annoying jumping around
			
				// Calculation fix for moving mouse up/down to look downin full pitch range
				//TestValue = abs(CameraHistory.Pitch-CameraRotation.Pitch);
				//if (65536-TestValue<TestValue) TestValue=65536-TestValue;
				//CameraRotation.Pitch = CameraRotation.Pitch + TestValue*(1-CameraHistoryDeltaTime);
				
				LowPitch = CameraRotation.Pitch;	// Store base pitch that camera would be at
			
				// Patch change - this made turning a bit too smooth
				CameraRotation.Yaw = CameraRotation.Yaw + (CameraHistory.Yaw-CameraRotation.Yaw)*(1-CameraHistoryDeltaTime);
				CameraRotation.Pitch = CameraRotation.Pitch + (CameraHistory.Pitch-CameraRotation.Pitch)*(1-CameraHistoryDeltaTime);

				//View = vect(1,0,0) >> CameraRotation;
				if (CameraRotation.Pitch > 30000) CameraRotation.Pitch -= 65536;
			}
			else
			{	
				// Special Camera Zone Angle
				//
				// Allow for specific camera angles and the like.
				// Override: Player is in CameraFacing Zone and must use fixed camera position.
				//
			
				switch (CameraZone(Region.Zone).CameraFacing)
				{
					case CAM_Above:
					CameraRotation.Pitch = -(65536/4);
					NewRotation = Rotation;
					NewRotation.Pitch = 0;
					SetRotation(NewRotation);
					break;
				}
				ViewDist = CameraZone(Region.Zone).CameraDistance;
				if (CameraZone(Region.Zone).CameraFixedYaw) CameraRotation.Yaw = 0;
				CameraRotation = CameraRotation + CameraZone(Region.Zone).CameraRotation;

				BasePitch = CameraRotation.Pitch;	// Store unaltered pitch
				LowPitch = CameraRotation.Pitch;	// Store base pitch that camera would be at
				
			    ViewDistIncrease = 2;
				WallOutDist = 5;
				
				IgnoreBlockedCamera = true;
			}
	
			// Check if Camera is Blocked
			//
			//
			if (Trace( HitLocation, HitNormal, SmoothLocForCam - (ViewDist+WallOutDist) * vector(CameraRotation), SmoothLocForCam, false ) != None && !bNoclip)
			{
				NewDist = ViewDist;

				// Check Upward First
				CameraRotation.Pitch = BasePitch;
				OldCameraForwardHack = CameraForwardHack;
				ViewMax = -13000;
				ViewChange = 2000;	// Pitch to change each check
				OldViewDist = ViewDist;
				ViewDistIncrease = -((ViewDist-40)/7);
				WallOutDist = 15;
				ViewBlocked = true;					// View is currently blocked
				ExtrapolateLevel = 10;				// Precision level to check to
				LastDistance = 0;
				
				// First check
				CheckDownwardRotation = true;
				NewRotation = CameraRotation;
				NewRotation.Pitch = 0;
				ViewBlocked = !(Trace( HitLocation, HitNormal, SmoothLocForCam - (ViewDist+WallOutDist) * vector(NewRotation), SmoothLocForCam, false ) == None);
				//OrigDistance = VSize(HitLocation-SmoothLocForCam);
				if (ViewBlocked) { CheckDownwardRotation = false; }
				
				if (!IgnoreBlockedCamera)
				{
					while ((ExtrapolateLevel>0))
					{
						CameraForwardHack += ViewChange*0.9;
						CameraRotation.Pitch -= ViewChange; ViewDist += ViewDistIncrease;
						
						ViewBlocked = !(Trace( HitLocation, HitNormal, SmoothLocForCam - (ViewDist+WallOutDist) * vector(CameraRotation), SmoothLocForCam, false ) == None);
						
						if ((!ViewBlocked) || (CameraRotation.Pitch < ViewMax))
						{
							// Extrapolate to next precision level
							ExtrapolateLevel -= 1;
							ViewBlocked=true;
	
							if (ExtrapolateLevel>0)
							{
								ViewMax = CameraRotation.Pitch;
								CameraForwardHack -= ViewChange*0.9;
								CameraRotation.Pitch += ViewChange;
								ViewDist -= ViewDistIncrease;
		
								ViewChange /= 2;
								ViewDistIncrease /= 2;
							}
							NewDist = ViewDist;
						}
					}
					
					LastDistance = VSize(HitLocation-SmoothLocForCam);
					CameraDistHistory = ViewDist;
				
					// Check if wall is above player and we should move the camera a bit
					if ((CameraRotation.Pitch<-10000) && (LastDistance<60))
					{
						//Log("Last Distance) "$LastDistance);
						Temp = (60-LastDistance)*300;
						CameraRotation.Pitch -= Temp;
						CameraForwardHack += Temp*0.9;
						//ViewDist = ViewDist * 0.96;  
						ViewDist = LastDistance;
					}
					
					// Check Downward Next
					if (ViewBlocked && CheckDownwardRotation)
					{
						PitchA = CameraRotation.Pitch;
						CameraForwardHackA = CameraForwardHack;
						ViewDistA = ViewDist;
						
						CameraForwardHack = OldCameraForwardHack;
						CameraRotation.Pitch = BasePitch;
						ViewMax = BasePitch+2000;
						ViewChange = -2000;	// Pitch to change each check
						ViewDist = OldViewDist;
						ViewDistIncrease = -((ViewDist-40)/5);
						WallOutDist = 15;
						ViewBlocked = true;					// View is currently blocked
						ExtrapolateLevel = 10;				// Precision level to check to
						
						if (!IgnoreBlockedCamera)
						while ((ExtrapolateLevel>0))
						{
						
							//CameraForwardHack -= ViewChange*0.9;
							CameraRotation.Pitch -= ViewChange; ViewDist += ViewDistIncrease;
							ViewBlocked = !(Trace( HitLocation, HitNormal, SmoothLocForCam - (ViewDist+WallOutDist) * vector(CameraRotation), SmoothLocForCam, false ) == None);
		
							if ((!ViewBlocked) || (CameraRotation.Pitch > ViewMax))
							{
								// Extrapolate to next precision level
								ExtrapolateLevel -= 1;
								ViewBlocked=true;
		
								if (ExtrapolateLevel>0)
								{
									ViewMax = CameraRotation.Pitch;
									//CameraForwardHack += ViewChange*0.9;
									CameraRotation.Pitch += ViewChange;
									ViewDist -= ViewDistIncrease;
			
									ViewChange /= 2;
									ViewDistIncrease /= 2;
								}
		
								NewDist = ViewDist;
								
							}
						}
		
						CameraDistHistory = 0;
						// If new to-wall distance is higher than the old one, go with the old one!
						NewDistance = VSize(HitLocation-SmoothLocForCam);
						if ((NewDistance<=LastDistance*0.95) /*|| (NewDistance<=OrigDistance)*/)
						{
							CameraForwardHack = CameraForwardHackA;
							CameraRotation.Pitch = PitchA;
							ViewDist = ViewDistA;
							CameraDistHistory = ViewDist;
						}
					}
				}
				//
				// End of New Check
			}
			else
			{
				NewDist = ViewDist;
				CameraDistHistory = ViewDist;
			}		
			
			
			CamBobSpeed += -CamBob/100;
   			CamBobSpeed /= 1.1;
    		CamBob += CamBobSpeed;
    		
    		CamShake -= CamShake*0.075;
    		CamShakeRot -= CamShakeRot*0.075;
			
			//Find the new viewpoint
			View = vect(1,0,0) >> CameraRotation;
			CameraLocation = SmoothLocForCam;
			CameraLocation -= (ViewDist - WallOutDist)*View+CamShake+CamBob;
			CameraHistory = CameraRotation;
			
			if (CameraFixedBehind)
			CameraRotation.Pitch += CameraForwardHack;
			else
			{
				if (ViewRotation.Pitch<20000)
				{ CameraRotation.Pitch += CameraForwardHack + ViewRotation.Pitch/2.5; }
				else
				{ CameraRotation.Pitch += CameraForwardHack - -(65536-ViewRotation.Pitch)/20; }
			}
	}
	else
	{
		// First-person view.
		CameraLocation = Location;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;
	}
}


function float RotateTowardYaw ( float YawA, float YawB, float ChangePct )
{
	local float YawChange;

	YawA = YawA & 65535;
	YawB = YawB & 65535;

	
	YawChange = (YawA - YawB) & 65535;

	if (YawChange > (65535 - YawChange))
	YawChange = -(65535-YawChange);
	
	return ( YawChange * ChangePct );
}

final static function float ATan2(float Y,float X)
{
  local float tempang;
 
  if(X==0) { //div by 0 checks.
    if(Y<0)
      return -pi/2.0;
    else if(Y>0)
      return pi/2.0;
    else
      return 0; //technically impossible (nothing exists)
  }
  tempang=ATan(Y/X);
 
  if (X<0)
    tempang+=pi;  //1st/3rd quad
 
  //normalize (from -pi to pi)
  if(tempang>pi) 
    tempang-=pi*2.0;
 
  if(tempang<-pi)
    tempang+=pi*2.0;
 
  return tempang;
}

function UpdateRotation(float DeltaTime, float maxPitch )
{
	local rotator newRotation, TerrainRot;
	local vector  FacingVector;
	local rotator AccelToFacingDir;
	local vector  FaceVecSpeed;
	local vector  RelativeVelocity;
	
	local float   AccelToFacingTestValue;
	local bool    AccelToFacingYawReverse;
	
	local vector  X,Y,Z;
	
	local float   TestValue;	// Patch change - This is used for making Jazz face the angle of his movement
	local bool    YawReverse; // Patch change - This is used for making Jazz face the angle of his movement
	
	local rotator TwoDRot; // Patch - Need this for the jumping rotations
	
	// Patch change - need to check the floor normal in order to properly align Jazz to it.
	local vector 	HitLocation, HitNormal, HitNormalSmooth;     local Actor HitActor;
    local float newPitch, newRoll, dist;
    local vector SearchDir;
    local rotator FloorRot, FloorRotTarg;
    	
	DesiredRotation = ViewRotation; //save old rotation
	ViewRotation.Pitch += 8.0 * DeltaTime * aLookUp;		// Was 16
//	CameraHistory.Pitch += 8.0 * DeltaTime * aLookUp;		// Was 16
	ViewRotation.Pitch = ViewRotation.Pitch & 65535;
	If ((ViewRotation.Pitch > 17000) && (ViewRotation.Pitch < 50000))
	{
		If (aLookUp > 0) 
			ViewRotation.Pitch = 17000;
		else
			ViewRotation.Pitch = 50000;
	}
	
	
	/// Camera control movement
	//
	// Turning motion.
	// * Turns in behind camera
	// * Runs in circle in roaming camera (turn slightly)
	//
	
	switch (CameraInUse)
	{
	case CAM_Behind:
		ViewRotation.Yaw += 16.0 * DeltaTime * aTurn;	// Was 16.0
		

//		CameraHistory.Yaw += 16.0 * DeltaTime * aTurn;
		
		// Update camera history to avoid smoothing out motion too much
		//CameraHistory.Pitch = ViewRotation.Pitch;
		//CameraHistory.Pitch += 8.0 * DeltaTime * aLookUp;
		//Log("ViewRotation) "$ViewRotation.Pitch$" "$CameraHistory.Pitch);
		break;
	case CAM_Roaming:
		// Rotate towards desired facing
		ViewRotation.Yaw = (ViewRotation.Yaw + 
			RotateTowardYaw(BasePlayerFacing.Yaw-DesiredFacing.Yaw,ViewRotation.Yaw,DeltaTime*5));
		
		
		//ViewRotation.Yaw += ((BasePlayerFacing.Yaw-DesiredFacing.Yaw)-ViewRotation.Yaw)*(DeltaTime*3);
		//ViewRotation.Yaw = BasePlayerFacing.Yaw-DesiredFacing.Yaw;
		
		//ViewRotation.Yaw += 24.0 * DeltaTime * aTurn;
		break;
	}
	
	ViewShake(deltaTime);
	ViewFlash(deltaTime);
	
	////////////////////////////////////////////////////Character Rotations///////////////////////////////////////
	newRotation = Rotation;
	smoothVel += (Velocity - smoothVel)*DeltaTime*5;

	TwoDRot = Rotation;
	TwoDRot.Pitch = 0;
	TwoDRot.Roll = 0;

	//if (Hanging == 0) // Check if the player is hanging on a ledge or not

	// Patch change - this code has been redesigned pretty much completely for better animation handling
	// Jazz now faces the direction of his movement, unless player starts using weapons.

	//if (!IsInState('Frozen'))
	//{
		if (Physics != PHYS_Falling )
		{
			if (sqrt(abs(aForward*aForward+aStrafe*aStrafe))!=0)
			{
				// Patch change - Here we get the nice, smooth rotation effect when turning!
				// Previously I used the velocity vector for that, but it proved to be annoying when trying to activate actors.
				// Of course that could have been fixed in another way, but making jazz run along a wall was only an unneeded effect.			
				
				FaceVec += (Acceleration-FaceVec)*DeltaTime*6;
				
				if (Acceleration.X == 0 && Acceleration.Y != 0)
				{
					if (FaceVec.X > 0 && FaceVec.X < 0.0001)
					{ FaceVec.X = -0.0001; }
					else
					if (FaceVec.X < 0 && FaceVec.X > -0.0001)
					{ FaceVec.X = 0.0001; }
				}
				if (Acceleration.X != 0 && Acceleration.Y == 0)
				{
					if (FaceVec.Y > 0 && FaceVec.Y < 0.0001)
					{ FaceVec.Y = -0.0001; }
					else
					if (FaceVec.Y < 0 && FaceVec.Y > -0.0001)
					{ FaceVec.Y = 0.0001; }
				}
				
				AccelToFacingYawReverse = (FaceVec.X<0);
				AccelToFacingTestValue = (FaceVec.Y+0.1)/FaceVec.X;
				if (AccelToFacingYawReverse)
				{ AccelToFacingDir.Yaw = (-16384-(16384-atan(AccelToFacingTestValue)/3.142857/2*65536))+16384-16384; }
				else
				AccelToFacingDir.Yaw = (atan(AccelToFacingTestValue)/3.142857/2*65536)+16384-16384;
				
				if ( sqrt(abs(FaceVec.X*FaceVec.X+FaceVec.Y*FaceVec.Y)) < 100 )
				{
					FaceVec.X = sin(AccelToFacingDir.Yaw * (pi/32768))*100;
					FaceVec.Y = cos(AccelToFacingDir.Yaw * (pi/32768))*100;
				}			
				//sin(degtorad(AccelToFacingDir))*1;
				//FacingVector.Y = Velocity.X;
				//FacingVector.X = Velocity.Y;
				FacingVector = FaceVec;
				//newRotation.Pitch = 0;
				smoothVel = Velocity;//vect(0,0,0);
			}
			
			//if ( Trace( HitLocation, HitNormal, Location + vect(0,0,-100), Location, false ) != none )
			//{ newRotation.Pitch = Rotator(HitNormal).Pitch-16384; }
			
			// Patch change - align Jazz to the floor normal
			SearchDir = vect(0,0,-1); // must be normed
			//if (sqrt(abs(aForward*aForward+aStrafe*aStrafe)) > 0.2)
			//{
		   		HitActor = Trace( HitLocation, HitNormal, Location + 500*SearchDir, Location, false );
			   	if ( HitActor != None )
			   	{
			   		//HitNormalSmooth += (HitNormal-HitNormalSmooth)*DeltaTime*5;
			   		
			   		Plane( HitNormal, newRoll, newPitch, Rotation.Yaw ); // <-----
			   		
			      	newRotation.Roll = newRoll;
				    newRotation.Pitch = newPitch;
			      	newRotation.Yaw = Rotation.Yaw;
			      	setRotation( newRotation );
			      	//dist = CollisionHeight * (HitNormalSmooth dot HitNormalSmooth) / (SearchDir dot HitNormalSmooth);
			      	//Move( HitLocation + SearchDir*dist - Location );
   				}
   			//}
   			/*else
   			{
   				HitNormalSmooth += (vect(0,0,-1)-HitNormalSmooth)*0.001*DeltaTime;

	   		}*/
		}
		else
		{
			//TerrainRot = Rotator(vect(0,0,0));
			RelativeVelocity = smoothVel << TwoDRot;
			
			newRotation.Roll  = Max(-3750,Min(3750,smoothVel.Z*RelativeVelocity.Y*0.02));
			newRotation.Pitch = Max(-3750,Min(3750,-smoothVel.Z*RelativeVelocity.X*0.02));
		}

		if (Weapon.bPointing == true)
		{ newRotation.Yaw = ViewRotation.Yaw; }
		else if ( (sqrt(abs(FacingVector.X)+abs(FacingVector.Y)) > 0.5)
				   && AnimSequence != 'JazzRunShooting'
				    && AnimSequence != 'RunBackShoot'
				     && AnimSequence != 'RunLeftShoot'
				      && AnimSequence != 'RunRightShoot' )
		{
			YawReverse = (FacingVector.X<0);
			TestValue = (FacingVector.Y+0.1)/FacingVector.X;
			if (YawReverse)
			{ newRotation.Yaw = (-16384-(16384-atan(TestValue)/3.142857/2*65536))+16384-16384; }
			else
			{ newRotation.Yaw = (atan(TestValue)/3.142857/2*65536)+16384-16384; }
			//{ newRotation.Yaw = -(-16384-(16384-atan(TestValue)/3.142857/2*65536))+16384+ViewRotation.Yaw*2-16384; }
			//else
			//newRotation.Yaw = -(atan(TestValue)/3.142857/2*65536)+16384+ViewRotation.Yaw*2-16384;
		}
	//}
	
	
	// Patch change... kind of - This was used originally when the Character would face the direction of it's acceleration at all times.
	// This is no longer the case as Jazz only faces this direction when he's on the ground. There's still some work to be done, and perhaps
	// a similar effect could be added to make the jumping and falling feel a lot more fun.
	/*if (Physics == PHYS_Falling)
	{
		if (Weapon.bPointing == true)
		{ newRotation.Pitch = 0; }
		else
		{ newRotation.Pitch = (Velocity.Z*-sqrt(abs(Velocity.X)+abs(Velocity.Y))) * 0.3; } // FIXME - Not exactly good enough
	}
	else
	{ newRotation.Pitch = 0; }*/

	setRotation(newRotation);
}

// Patch change - taken from Jazz Object class - Jazz now slides off the edge if he steps too far over it.
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
   Y1 =-sin(Yaw)*X0 + cos(Yaw)*Y0;
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

////////////////////// Pt.3 Redo Physics
//
// State is played while doing the wall hang thang.
// 
//
state Hanging
{
	function PlayerTick ( float DeltaTime )
	{
		Global.PlayerTick( DeltaTime );
	
		PlayerMove(DeltaTime);
		
	}
	
	// Redo update rotation to remove view up/down motion.
	//
	function UpdateRotation(float DeltaTime, float maxPitch)
	{
		local rotator newRotation;
		
		DesiredRotation = ViewRotation; //save old rotation
		
		// Remove viewrotation up/down
		//
		/*ViewRotation.Pitch += 8.0 * DeltaTime * aLookUp;
		ViewRotation.Pitch = ViewRotation.Pitch & 65535;
		If ((ViewRotation.Pitch > 16000) && (ViewRotation.Pitch < 59000))
		{
			If (aLookUp > 0) 
				ViewRotation.Pitch = 16000;
			else
				ViewRotation.Pitch = 59000;
		}
		ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;*/
		
		
		DesiredRotation = ViewRotation;
		ViewRotation.Pitch += 8.0 * DeltaTime * aLookUp;
		ViewRotation.Pitch = ViewRotation.Pitch & 65535;
		If ((ViewRotation.Pitch > 17000) && (ViewRotation.Pitch < 50000))
		{
			If (aLookUp > 0) 
				ViewRotation.Pitch = 17000;
			else
				ViewRotation.Pitch = 50000;
		}
		switch (CameraInUse)
		{
			case CAM_Behind:
				ViewRotation.Yaw += 16.0 * DeltaTime * aTurn;
			break;
			case CAM_Roaming:
				ViewRotation.Yaw = (ViewRotation.Yaw + 
					RotateTowardYaw(BasePlayerFacing.Yaw-DesiredFacing.Yaw,ViewRotation.Yaw,DeltaTime*5));
			break;
		}
		
		
		DashTime = 0;
		
		ViewShake(deltaTime);
		ViewFlash(deltaTime);
		
		newRotation = Rotation;
		newRotation.Yaw = ViewRotation.Yaw;
		newRotation.Roll = 0;
		newRotation.Pitch = 0;//ViewRotation.Pitch; // Patch change - The character only hangs with legs straight down, doesn't it?
		/*If ( (newRotation.Pitch > maxPitch * RotationRate.Pitch) && (newRotation.Pitch < 65536 - maxPitch * RotationRate.Pitch) )
		{
			If (ViewRotation.Pitch < 32768) 
				newRotation.Pitch = maxPitch * RotationRate.Pitch;
			else
				newRotation.Pitch = 65536 - maxPitch * RotationRate.Pitch;
		}*/
		
		//setRotation(newRotation); // Patch change - we no longer want Jazz to update his rotation!
	}

	//
	// Send movement to the server.
	// Passes acceleration in components so it doesn't get rounded.
	//
	function ServerMove
	(
		float TimeStamp, 
		vector InAccel, 
		vector ClientLoc,
		bool NewbRun,
		bool NewbDuck,
		bool NewbJumpStatus, 
		bool bFired,
		bool bAltFired,
		bool bForceFire,
		bool bForceAltFire,
		eDodgeDir DodgeMove, 
		byte ClientRoll, 
		int View,
		optional byte OldTimeDelta,
		optional int OldAccel
	)
	{
		local float DeltaTime, clientErr;
		local rotator DeltaRot, Rot;
		local vector LocDiff;
		local int maxPitch;
		local actor OldBase;
		
		// Make acceleration.
		/*
		Accel.X = AccelX;
		Accel.Y = AccelY;
		Accel.Z = AccelZ;
		*/
	
		// If this move is outdated, discard it.
		if ( CurrentTimeStamp >= TimeStamp )
			return;
	
		// handle firing and alt-firing // Patch change - Jazz is too busy holding on the ledge - he can't shoot!!!
		/*if ( bFired )
		{
			if ( bFire == 0 )
			{
				Fire(0);
				bFire = 1;
			}
		}
		else
			bFire = 0;
	
	
		if ( bAltFired )
		{
			if ( bAltFire == 0 )
			{
				AltFire(0);
				bAltFire = 1;
			}
		}
		else
			bAltFire = 0;*/
	
		// Save move parameters.
		DeltaTime = TimeStamp - CurrentTimeStamp;
		if ( ServerTimeStamp > 0 )
		{
			TimeMargin += DeltaTime - (Level.TimeSeconds - ServerTimeStamp);
			if ( TimeMargin > MaxTimeMargin )
			{
				TimeMargin -= DeltaTime;
				if ( TimeMargin < 0.5 )
					MaxTimeMargin = 1.0;
				else
					MaxTimeMargin = 0.5;
				DeltaTime = 0;
				//ClientMessage("I have turbo-speed"); //FIXME REMOVE
			}
		}
	
		CurrentTimeStamp = TimeStamp;
		ServerTimeStamp = Level.TimeSeconds;
		Rot.Roll = 256 * ClientRoll;

		// FIXME: ViewYaw no longer exsists (?)
		// Rot.Yaw = ViewYaw;
		
		//if ( (Physics == PHYS_Swimming) || (Physics == PHYS_Flying) )
		//	maxPitch = 2;
		//else
		//	maxPitch = 1;

		// FIXME: ViewPitch no longer exsists (?)
		/*
		If ( (ViewPitch > maxPitch * RotationRate.Pitch) && (ViewPitch < 65536 - maxPitch * RotationRate.Pitch) )
		{
			If (ViewPitch < 32768) 
				Rot.Pitch = maxPitch * RotationRate.Pitch;
			else
				Rot.Pitch = 65536 - maxPitch * RotationRate.Pitch;
		}
		else
			Rot.Pitch = ViewPitch;
		*/

		DeltaRot = (Rotation - Rot);
		// FIXME: ViewPitch and ViewYaw no longer exsist (?)
		/*
		ViewRotation.Pitch = ViewPitch;
		ViewRotation.Yaw = ViewYaw;
		*/
		ViewRotation.Roll = 0;
		SetRotation(Rot);

		OldBase = Base;

		// Perform actual movement.
		if ( (Level.Pauser == "") && (DeltaTime > 0) )
			MoveAutonomous(DeltaTime, NewbRun, NewbDuck, NewbJumpStatus, DodgeMove, InAccel, DeltaRot);
	
		// Accumulate movement error.
		if ( Level.TimeSeconds - LastUpdateTime > 0.3 )
		{
			ClientErr = 10000;
		}
		else if ( Level.TimeSeconds - LastUpdateTime > 0.07 )
		{
			LocDiff = Location - ClientLoc;
			ClientErr = LocDiff Dot LocDiff;
		}
	
		// If client has accumulated a noticeable positional error, correct him.
		if ( ClientErr > 3 )
		{
			if ( Mover(Base) != None )
				ClientLoc = Location - Base.Location;
			else
				ClientLoc = Location;
			// log("Client Error at "$TimeStamp$" is "$ClientErr$" with Velocity "$Velocity$" LocDiff "$LocDiff$" Physics "$Physics);
			LastUpdateTime = Level.TimeSeconds;
			ClientAdjustPosition
			(
				TimeStamp, 
				GetStateName(), 
				Physics, 
				ClientLoc.X, 
				ClientLoc.Y, 
				ClientLoc.Z, 
				Velocity.X, 
				Velocity.Y, 
				Velocity.Z,
				Base
			);
		}
		//log("Server "$Role$" moved "$self$" stamp "$TimeStamp$" location "$Location$" Acceleration "$Acceleration$" Velocity "$Velocity);
	}	

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		local vector OldAccel,VelocityChange,NewVelocity;
		local float OldVelocityKeep,OldVelocityChangeKeep;
		local vector View,HitLocation,HitNormal,NewLocation;
		
		local float TestValue;
		local bool  YawReverse;
		local rotator jumpdir;
		
		if (Physics == PHYS_None)
		{
		// Override Velocity System
		//TweentoHanging(0.1);
		}
		VelocityHistory = Velocity;
		bwashung = True;
		//bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );
		
		if (sqrt(abs(aForward*aForward+aStrafe*aStrafe)) > 1)
		{
			YawReverse = (aStrafe<0);
			TestValue = (-aForward+0.1)/aStrafe;
			if (YawReverse)
			{ jumpdir.Yaw = (-16384-(16384-atan(TestValue)/3.142857/2*65536))+16384; }
			else
			jumpdir.Yaw = (atan(TestValue)/3.142857/2*65536)+16384;
		}
	
		//TweentoHanging(0.1);
		// Jump Handling
		if ( bPressedJump )
		{			
			NewLocation = location;
			NewLocation.X = Location.X+cos(rotation.Yaw * (pi/32768))*-22;
			NewLocation.Y = Location.Y+sin(rotation.Yaw * (pi/32768))*-22;
			SetLocation(NewLocation);
			
			//bCollideWorld = True;
			SetCollisionSize( Default.CollisionRadius, Default.CollisionHeight );
			
			SetPhysics(Phys_Falling);
			Velocity.Z = 450; // Patch change - let's make Jazz jump higher! (Original - 400)
			/*Velocity.X = vector(ViewRotation).X*100; // Patch change - let's let the player decide where Jazz would go after the jump!
			Velocity.Y = vector(ViewRotation).Y*100;*/
			if (sqrt(abs(aForward*aForward+aStrafe*aStrafe)) > 1)
			{
				Velocity.X = vector(ViewRotation+jumpdir).X*150;
				Velocity.Y = vector(ViewRotation+jumpdir).Y*150;
			}
			//PlayLedgePullUp(3); // Patch change - the pullup animation doesn't look very good when you can still control yourself.
			PlayFlyingUp();
			VoicePackActor.DoSound(Self,VoicePackActor.LedgePull);
			ReturnToNormalState();
		}	
	}
	
	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local EDodgeDir OldDodge;
		local eDodgeDir DodgeMove;
		local rotator OldRotation;
		local float Speed2D;
		local bool	bSaveJump;
		local vector NewLocation;
		
		

		GetAxes(Rotation,X,Y,Z);
//ViewRotation.Yaw
		// Press back to fall off the ledge
		if (aUp < 0)//(aForward<0) // Patch change - Let's drop off by pressing Crouch, instead
		{
			if (bLedgeBackHeld==false)
			{
				NewLocation = location;
				NewLocation.X = Location.X+cos(rotation.Yaw * (pi/32768))*-22;
				NewLocation.Y = Location.Y+sin(rotation.Yaw * (pi/32768))*-22;
				SetLocation(NewLocation);
				
				//bCollideWorld = True;
				SetCollisionSize( Default.CollisionRadius, Default.CollisionHeight );
				
				SetPhysics(Phys_Falling);
				Velocity.Z = -25;	
				bWasHung = true;
				LedgeCheckDelay = 0.5;
				ReturnToNormalState();
				VoicePackActor.DoSound(Self,VoicePackActor.LedgeFall);
			}
		}
		else
		bLedgeBackHeld = false;
		
		// Press back to fall off the ledge
		/*if (aForward>0) // Patch change - How about we climb by jumping?
		{
			if (bLedgeForwardHeld==false)
			{
			bPressedJump = true;
			}
		}
		else*/
		if (bPressedJump == False)
		{ bLedgeForwardHeld = false; }
		
		//aForward *= 0;
		//aStrafe  *= 0;
		
		//aLookup  *= 0;
		//aTurn    *= 0;
		//OldAStrafe = aStrafe;
		//OldATurn = aTurn;
		//OldAForward = aForward;
		
		aForward *= 0.4;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aStrafe  *= 0.4;
		OldAStrafe = aStrafe;
		OldAForward = aForward;
		
		// Update acceleration.
		NewAccel = vect(0,0,0); 
		NewAccel.Z = 0;

		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);

		bPressedJump = false;
		
		
	}

	function EndState ()
	{
		//GroundSpeed = DefaultGroundSpeed;			// Removed version 19G
		VelocityHistory = vect(0,0,0);
		
		// Cool Effect :)
	}
	
	function AnimEnd()
	{
		PlayLedgeHang();
	}
	
	function BeginState ()
	{
		PlayLedgeGrab();
		bLedgeForwardHeld = true;
		bLedgeBackHeld = true;
	}
	
	
Begin:
	// Prepare Initial Motion
	
	bPressedJump = false;
	
	
}

////////////////////// Pt.3 Redo Physics
// 
//
state PlayerWalking
{
	function AnimEnd ()
	{
		local name MyAnimGroup;

		bAnimTransition = false;
		
		// Landed() calls AnimEnd with bJustLanded set to true
		//
		if ((Physics == PHYS_Falling) && (bJustLanded==false))
		{
			if (bJustJumpedOutOfWater)
			{
			PlayFlyingUp();
			bJustJumpedOutOfWater=false;
			}
			else
			PlayFallingDown();
		}
		else
		if ((Physics == PHYS_Walking) || (bJustLanded==true))
		{
			if (bIsCrouching)
			{
				if ( !bIsTurning && ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 1000) )
					PlayDuck();	
				else
					PlayCrawling();
			}
			else
			{
				MyAnimGroup = GetAnimGroup(AnimSequence);
				if ((Velocity.X * Velocity.X + Velocity.Y * Velocity.Y) < 1000)
				{
					if ( MyAnimGroup == 'Waiting' )
						PlayWaiting();
					else
					{
						bAnimTransition = true;
						TweenToWaiting(0.01);
					}
				}	
				else if (bIsWalking)
				{
					if ( (MyAnimGroup == 'Waiting') || (MyAnimGroup == 'Landing') || (MyAnimGroup == 'Gesture') || (MyAnimGroup == 'TakeHit')  )					{
						bAnimTransition = true;
						TweenToWalking(0.5);
					}
					else 
						PlayWalking();
				}
				else
				{
					if ( (MyAnimGroup == 'Waiting') || (MyAnimGroup == 'Landing') || (MyAnimGroup == 'Gesture') || (MyAnimGroup == 'TakeHit')  )
					{
						bAnimTransition = true;
						TweenToRunning(0.05);
					}
					else
						PlayRunning();
				}
			}
		}
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		local vector OldAccel;
		
		local rotator NewViewRotation1,NewViewRotation2;
		local vector  LocLeftWaist,LocRightWaist;
		local vector  FacingDistanceCheckShort,FacingDistanceCheckLong;
		local vector	HitNormal,HitLocation,HitLocation1,HitNormalA,HitNormalB;
		local vector	NewLocation; // Patch change - let's find the best location after grabbing a ledge!
		local float	  Temp;
		local rotator NewRotation;
		
		local float TestValue;
		local bool  YawReverse;
		
		local vector X,Y,Z;
		local rotator MoveFaceRotation;
		
		
		MoveFaceRotation = ViewRotation;
		MoveFaceRotation.Pitch = 0;
		GetAxes(MoveFaceRotation,X,Y,Z);
		
		if (!bNoclip && Physics == PHYS_Flying)
		{ SetPhysics(PHYS_Falling); }
		
		// Motion
		if (LatentBounceDo)
		{
			SetLocation(Location + vect(0,0,50));
			Velocity.Z = LatentBounce;
			SetPhysics(PHYS_Falling);
			LatentBounceDo = false;
		}

		//Acceleration.X *= 0.1;
		//Acceleration.Y *= 0.1;

		OldAccel = Acceleration;
		Acceleration = NewAccel;
		
		// JAZZ3 : This is the code that allows some motion while falling.
		if ((Physics == PHYS_Falling))
		{
			Temp = abs(VSize(Velocity+ ((NewAccel/VSize(NewAccel))*1600) ));
			Temp = Temp / 1500;
			if (Temp<0) Temp=0;
			if (Temp>1) Temp=1;
			Velocity += (NewAccel * DeltaTime)*(1-Temp);
			
				// Calculation - Increase by NewAccel factored down to 35%
		}
		else
		{ UpdateRunning(); }
		
		// Patch Change - This is disabled at the moment, Jazz would easily slide down slopes with wierd animation results
		// This will be enabled later in a possible future release when this physics feature will be improved to only work at sharp edges.
		//if (Physics == PHYS_Walking)
		//{ CenterOfGravityCheck(DeltaTime); }
		
		// Wall Grab End	
		if (bwashung)
			aforward = 0;
		
		// Wall Grab Detection
		if (bLedgeGrabOk)
		if ((Physics == PHYS_Falling) && (LedgeCheckDelay<=0))
		{
			// Wall Grabbing DetectionCode
			NewViewRotation1 = Rotation;//ViewRotation; // Patch change - viewRotation has been replaced with the character's rotation
			NewViewRotation2 = Rotation;//ViewRotation;
			NewViewRotation1.Yaw = Rotation.Yaw + 16384;//ViewRotation.Yaw + 16384;	// Left 90
			NewViewRotation2.Yaw = Rotation.Yaw - 16384;//ViewRotation.Yaw - 16384;	// Right 90
			
			LocLeftWaist	= Location + 10*vector(NewViewRotation1);	// Original value 20
			LocRightWaist	= Location + 10*vector(NewViewRotation2);	// Original value 20
			
			FacingDistanceCheckShort	= 50*vector(Rotation);//ViewRotation);	// Original value 50
			FacingDistanceCheckLong		= 100*vector(Rotation);//ViewRotation);	// Original value 100
			
			/*WallGrabLocRightShoulder = WallGrabLocRightWaist;
			WallGrabLocLeftShoulder = WallGrabLocLeftWaist;
			WallGrabLocRightHead = WallGrabLocRightWaist;
			WallGrabLocLeftHead = WallGrabLocLeftWaist;
			WallGrabLocRightOverHead = WallGrabLocRightWaist;
			WallGrabLocLeftOverHead =  WallGrabLocLeftWaist;
			WallGrabLocRightHead.Z = WallGrabLocRightWaist.Z + 50;
			WallGrabLocLeftHead.Z = WallGrabLocLeftWaist.Z + 50;
			WallGrabLocRightOverhead.Z = WallGrabLocRightWaist.Z + 200;
			WallGrabLocLeftOverhead.Z = WallGrabLocLeftWaist.Z + 200;*/
			
	        
	       	if (( Trace( HitLocation1, HitNormalA, LocRightWaist	+ FacingDistanceCheckShort, Location ) == Level ) &&
				( Trace( HitLocation, HitNormalB, LocLeftWaist	+ FacingDistanceCheckShort, Location ) == Level )&&
				( Trace( HitLocation, HitNormal, LocRightWaist	+ vect(0,0,50) + FacingDistanceCheckLong, Location ) != Level ) &&	// Original value 50
				( Trace( HitLocation, HitNormal, LocLeftWaist	+ vect(0,0,50) + FacingDistanceCheckLong, Location ) != Level ) &&	// Original value 50
				( Trace( HitLocation, HitNormal, LocRightWaist	+ vect(0,0,100) + FacingDistanceCheckLong, Location ) != Level ) &&	// Original value 200
				( Trace( HitLocation, HitNormal, LocLeftWaist	+ vect(0,0,100) + FacingDistanceCheckLong, Location ) != Level ) &&	// Original value 200
				( HitNormalA.Z < 0.4) && (HitNormalB.Z < 0.4)&&
				( Self.Velocity.Z <= 0))
			{

				NewLocation = Location;
				NewLocation.X = HitLocation1.X;//+cos(rotation.Yaw * (pi/32768))*-3;
				NewLocation.Y = HitLocation1.Y;//+sin(rotation.Yaw * (pi/32768))*-3;
				NewLocation.Z = HitLocation1.Z-15;
				//bCollideWorld = false;
				SetCollisionSize( 5, Default.CollisionHeight );
				
				SetLocation(NewLocation);
				
				newRotation = Rotation;
				/*YawReverse = (-HitNormalA.X<0);
				TestValue = (-HitNormalA.Y+0.1)/-HitNormalA.X;
				if (YawReverse)
				{ newRotation.Yaw = (-16384-(16384-atan(TestValue)/3.142857/2*65536)); }
				else
				newRotation.Yaw = (atan(TestValue)/3.142857/2*65536);*/
				NewRotation.Yaw = rotator((HitNormalB)*(-1)).Yaw;
				newRotation.Roll = 0;
				newRotation.Pitch = 0;
				SetRotation(newRotation);
				
				SetPhysics(Phys_None);
				//ViewRotation=rotator((HitNormalB)*(-1));
				PlayGrabbing(0.5);
				VoicePackActor.LedgeGrabSound(Self);
				GotoState('Hanging');
			}
	
			//End of Wall Grabbing Code
			
			if (!IsInState('Hanging'))
			{
				// Moving Mid-Air
				Velocity.X -= Velocity.X*DeltaTime;
				Velocity.Y -= Velocity.Y*DeltaTime;
				//if ((aForward<0) || ((Velocity.Z<10) && (Acceleration.Z<10)))
				Velocity += NewAccel * 0.15 * DeltaTime;
			}
			
			/*if ((aForward != 0) || (aStrafe != 0)) // Patch Change - aTurn is changed to aStrafe now
			{
				NewAccel.Y = aForward*5;
				NewAccel.X = aStrafe*5;
			}

			aForward = Sqrt(Square(aForward)+Square(aStrafe)); // Patch Change - aTurn is changed to aStrafe now
		
			aForward *= 0.1;
			aStrafe  *= 0.1;
			
			OldAStrafe = aStrafe;
			OldATurn = aTurn;
			OldAForward = aForward;
				
			NewAccel = aForward*X + aStrafe*Y; 
			NewAccel.Z = 0;*/
		}
		
		bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );

		// SpecialMotion
		// This is not used anymore
		/*if (aStrafe>0)
		{
			DoSpecialPlayerMotion( SpecialMotionHeldTime );
			SpecialMotionHeldTime += DeltaTime;
		}
		else
			SpecialMotionHeldTime = 0;*/

		// DoubleJump		//
		if (DoubleJumpAllowed)
		{
			DoubleJumpReadyTime -= DeltaTime;
			DoubleJumpDelayTime -= DeltaTime;
			if (bPressedJump && (DoubleJumpReadyTime>0) && (!DoubleJumpAlready) && (DoubleJumpDelayTime<=0))
			{
				DoubleJumpAlready = true;
				DoDoubleJump();
			}
		}

		// Jump Handling
		//
		// Patch change - Let's make Jazz jump as high as the player wants by holding the jump key!
		if ( (Physics == PHYS_Falling) && (Velocity.Z > 0) && (aUp == 0) )
		{ Velocity.Z -= Velocity.Z*DeltaTime*5; }
		
		
		if ( bPressedJump )
		{
			if (!bNoclip) // Patch change - jump unless noclip is on, othervise - just lift!
			{
				DoubleJumpReadyTime = 1.5;
				DoubleJumpDelayTime = 0.5;
				DoJump();
			}
		}
		
		if ( (Physics == PHYS_Walking)
			&& (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			if (!bIsCrouching) // Patch change - Crouching!
			{
				if (aUp < -1) //(bDuck != 0)
				{
					bIsCrouching = true;
					PlayDuck();
				}
			}
			else if (aUp >= -1) //(bDuck == 0)
			{
				OldAccel = vect(0,0,0);
				bIsCrouching = false;
			}

			if ( !bIsCrouching )
			{
				if ( (!bAnimTransition || (AnimFrame > 0)) && (GetAnimGroup(AnimSequence) != 'Landing') )
				{
					if ( Acceleration != vect(0,0,0) )
					{
						if ( (GetAnimGroup(AnimSequence) == 'Waiting') || (GetAnimGroup(AnimSequence) == 'Gesture') || (GetAnimGroup(AnimSequence) == 'TakeHit') )
						{
							bAnimTransition = true;
							TweenToRunning(0.05);
						}
					}
			 		else if ( (Velocity.X * Velocity.X + Velocity.Y * Velocity.Y < 1000) 
						&& (GetAnimGroup(AnimSequence) != 'Gesture') ) 
			 		{
			 			if ( GetAnimGroup(AnimSequence) == 'Waiting' )
			 			{
							if ( bIsTurning && (AnimFrame >= 0) ) 
							{
								bAnimTransition = true;
								PlayTurning();
							}
						}
			 			else if ( !bIsTurning ) 
						{
							bAnimTransition = true;
							TweenToWaiting(0.01);
						}
					}
				}
			}
			else if ( (Physics != PHYS_Swimming) )
			{
				if ( (OldAccel == vect(0,0,0)) && (Acceleration != vect(0,0,0)) )
					PlayCrawling();
			 	else if ( !bIsTurning && (Acceleration == vect(0,0,0)) && (AnimFrame > 0.1) )
					PlayDuck();
			}
		}

		//For WaterJump
		bWaterJump = False;
		//For wall Grab
		bwashung = False;
	}
	
	// Basic Jazz Motion
	// 			
	function Landed(vector HitNormal)
	{
		Local vector LandParticleLocation;
		Local rotator newRotation;
		local int i;
		
		if (bThunderLand)
		{ ThunderLand(); }
		
		if (Velocity.Z < 0)
		{
			newRotation = Rotation;
			newRotation.Roll = 0.0;
			newRotation.Pitch = 0.0;
			SetRotation(newRotation);
		}
				
		//From 'PlayerPawn' - Modified
		PlayLanded(Velocity.Z);
		if (Velocity.Z < -1.4 * JumpZ)
		{
			MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
			if (Velocity.Z <= -1500)
			{
				if ( Role == ROLE_Authority )
				{
					TakeDamage(-0.05 * (Velocity.Z + 1450), None, Location, vect(0,0,0), 'fell');
					CamBobSpeed.Z -= Velocity.Z*0.01; // Patch change - Let's make an intense bobbing effect you get hurt by falling.
					Velocity.Z = 200; // Patch change - let's make the character bounce off the ground.
				}
			}			
		}
		else if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.5 * JumpZ) )
			MakeNoise(0.1 * Level.Game.Difficulty);		
		bJustLanded = true;
		
		AnimEnd();
		
		// Patch change - We only want to do the landing sound and particles if we hit the ground hard enough.
		if (Velocity.Z <= -200 && !bThunderLand)
		{ VoicePackActor.DoSound(Self,VoicePackActor.LandMinor); }
		
		// Patch change - Let's make some cool particles!
		if (Velocity.Z <= -700)
		{
			for(i = 10; i > 0; i--)
			{
				LandParticleLocation.X = Location.X-12+rand(24);
				LandParticleLocation.Y = Location.Y-12+rand(24);
				LandParticleLocation.Z = Location.Z-40;
		
				JazzDirtPart = Spawn(class'JazzDirtSmoke',self);
				JazzDirtPart.NewLocation = LandParticleLocation;
				JazzDirtPart.Velocity.X = (Location.X-JazzDirtPart.Location.X)*5;
				JazzDirtPart.Velocity.Y = (Location.Y-JazzDirtPart.Location.Y)*5;
				JazzDirtPart.Velocity.Z = 0.5+rand(0.75);
				JazzDirtPart.DrawScale = 0.2+Rand(0.3);
			}
		}
		
		if (Velocity.Z > -1500)
		{ CamBobSpeed.Z -= Velocity.Z*0.001; } // Patch change - ...or if you just land without hurting yourself, let's do a slight bobbing effect!	
		//End 'PlayerPawn'

		// Dash End // Patch change - Why end the dashing? This makes it less fun actually.
		//DashTime = 0;
		//DashReadyTime = 0;

		// Trail End
		//TrailTime = 0;

		// DoubleJump End
		DoubleJumpAlready = false;
		DoubleJumpReadyTime = 0;
	}
	
	function DoDoubleJump ()
	{
		local vector VelocityAdd;
		
		if ( Role == ROLE_Authority )
			VoicePackActor.DoSound(Self,VoicePackActor.JumpSound);
		if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
			MakeNoise(0.1 * Level.Game.Difficulty);
		
		//if (aForward<0)	VelocityAdd.x = aForward/10;	// Only allow reverse speed increase
		VelocityAdd = VelocityAdd >> Rotation;
		if (Velocity.z + JumpZ*0.75 >= JumpZ*0.75) Velocity.z = JumpZ*0.75;
		else Velocity.z = JumpZ*0.75;
		
		Velocity += VelocityAdd;
		//if ( Base != Level )
			//Velocity.Z += Base.Velocity.Z; 
		SetPhysics(PHYS_Falling);
		//if ( bCountJumps && (Role == ROLE_Authority) )
			//Inventory.OwnerJumped();
			
		PlayFlyingUp();		
	}
	
	//Player Jumped
	function DoJump( optional float F )
	{
		Local vector JumpParticleLocation;
		local int i;
		
		if ( CarriedDecoration != None )
			return;
			
					
		if ( !bIsCrouching && (Physics == PHYS_Walking) )
		{			
			if ( Role == ROLE_Authority )
				VoicePackActor.DoSound(Self,VoicePackActor.JumpSound);
			if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
				MakeNoise(0.1 * Level.Game.Difficulty);

			if ((DashTime>0) && (VSize(Velocity)>400))
			{
				Velocity.Z = JumpZ * 0.8;
				DoubleJumpReadyTime = 0;
			}
			else
			{
				Velocity.Z = JumpZ;
			}
			
			if ( Base != Level )
				Velocity.Z += Base.Velocity.Z; 
			SetPhysics(PHYS_Falling);
			
			PlayFlyingUp();
		
			if ( bCountJumps && (Role == ROLE_Authority) )
				Inventory.OwnerJumped();	
				
			// Patch change - Let's make some cool particles!
			for(i = 10; i > 0; i--)
			{
				JumpParticleLocation.X = Location.X-10+rand(20);
				JumpParticleLocation.Y = Location.Y-10+rand(20);
				JumpParticleLocation.Z = Location.Z-35;
				
				JazzDirtPart = Spawn(class'JazzDirtSmoke',self);
				JazzDirtPart.Free = True;
				JazzDirtPart.NewLocation = JumpParticleLocation;
				JazzDirtPart.Velocity.X = Velocity.X * 0.003;
				JazzDirtPart.Velocity.Y = Velocity.Y * 0.003;
				JazzDirtPart.Velocity.Z = Velocity.Z * 0.001;
				JazzDirtPart.DrawScale = 0.2+Rand(0.35);
			}
		}
	}

	//////////////////////////////////////////////////////////////////////////////////////////////	
	// Special Player Motion 										(BUTTON: SPECIAL MOTION)
	//////////////////////////////////////////////////////////////////////////////////////////////	
	//
	// Override this function for the individual player.
	//
	function DoSpecialPlayerMotion( float HeldTime )
	{
		// Check for special item in use first
		
		// Do special Player Motion
	}

	event PlayerTick( float DeltaTime )
	{
		Global.PlayerTick(DeltaTime);
	
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
		PlayerMove(DeltaTime);
	}

function rotator JazzOrthoRotation ( vector V )
{
	local Rotator R;
	local float TestValue;
	local bool  YawReverse;
	
	YawReverse = (V.X<0);
	
	TestValue = (V.Y+0.1)/V.X;
	if (YawReverse)
	{
	R.Yaw = -16384-(16384-atan(TestValue)/3.142857/2*65536);
	}
	else
	R.Yaw = atan(TestValue)/3.142857/2*65536;

	return(R);
}

	// Main walking PlayerMove //////////////////////////////////////////// Character Movement //////////////////////////////////////////////
	//
	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local EDodgeDir OldDodge;
		local eDodgeDir DodgeMove;
		local rotator OldRotation,TempRotation;
		local rotator MoveFaceRotation;
		local float Speed2D,TempF;
		
		local float Size;

		//GetAxes(Rotation,X,Y,Z);
		MoveFaceRotation = ViewRotation;
		MoveFaceRotation.Pitch = 0;
		GetAxes(MoveFaceRotation,X,Y,Z);

		BaseAForward = aForward;
		
		/////////////////////////////////////////////////////////////////////////// ROAMING //////
		// Roaming camera control
		//
		// Left or right should cause player to run forward, but turn to be facing left or right
		//
		if (CameraInUse == CAM_Roaming)
		{
			if ((aForward != 0) || (aStrafe != 0)) // Patch Change - aTurn is changed to aStrafe now
			{
				if (!bNoclip)
				{
					NewAccel.Y = aForward;
					NewAccel.X = aStrafe; // Patch Change - aTurn is changed to aStrafe now
				}
				//else
				//{
				//	NewAccel = (aForward*X + aStrafe*Y + aUp*vect(0,0,1))*5;
				//}
				DesiredFacing = JazzOrthoRotation(NewAccel);
				DesiredFacing.Yaw -= 16384;
			}

			aForward = Sqrt(Square(aForward)+Square(aStrafe)); // Patch Change - aTurn is changed to aStrafe now
		}
		
		aForward *= 0.4;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aStrafe  *= 0.4;
		
		OldAStrafe = aStrafe;
		OldATurn = aTurn;
		OldAForward = aForward;
		
		// Super-Dash Acceleration Increase
		//
		//
		DashReadyTime -= DeltaTime;
		if (DashTime>0)
		{
			//if ((aTurn != 0) && (Physics != PHYS_Falling))
				//DashTime = 0;
			if (!bNoclip)
			{ GroundSpeed = 800; }
			else
			{ GroundSpeed = 2000; }
			DashTime -= DeltaTime;
			
			// Stop dash if stop running forwards
			if (aForward<=0) DashTime = 0;
	
			//if (frand()<0.5)
				//spawn(class'BloodPuff',,,Location + vect(0,0,10));
		}
		else
		{
			if (!bNoclip)
			{ GroundSpeed = 400; }
			else
			{ GroundSpeed = 1000; }
		}
		
		// Poisoned?  Lower the ground speed.
		// 
		// Ground Speed is set above depending on dash in effect or not.
		//
		if (PoisonEffect)
		{
			GroundSpeed = GroundSpeed*0.6;
		}
		
		
		// Update acceleration.
		switch (CameraInUse)
		{
		case CAM_Behind:
			if (!bNoclip)
			{
				NewAccel = aForward*X + aStrafe*Y; 
				NewAccel.Z = 0;
			}
			else
			{ NewAccel = (aForward*X + aStrafe*Y + aUp*vect(0,0,1))*15; }
			break;
			
		/*case CAM_Roaming:
			NewAccel = aForward*X + aStrafe*Y + abs(aTurn*2)*X; //Patch change - turning no longer makes the player move.
			//NewAccel = aForward*X + aStrafe*Y; //Patch change - this is used instead
			NewAccel.Z = 0;			
			 // Dependent of left/right motion make adjustments to the
			BasePlayerFacing.Yaw = BasePlayerFacing.Yaw - RotateTowardYaw(BasePlayerFacing.Yaw,ViewRotation.Yaw,1*DeltaTime);
			aStrafe = 0;
			break;*/
		}
		
		// Forward pressed
		//
		//Patch change - included checks for back keys -
		//Fixes spazzing dashig when both Up and Down keys are held
		if ((bEdgeForward && bWasForward && !bEdgeBack && !bWasBack) && (DashTime<=0) && (Physics!=PHYS_Falling) )
		{
			if (DashReadyTime>0)
			{
				DashTime = 2;
				DashDirection = DODGE_Forward;
				VoicePackActor.DoSound(Self,VoicePackActor.DashSound);
			}
			else
			{
				DashReadyTime = 0.5;
			}
		
		}
				
		if ( (Physics == PHYS_Walking) && (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			//if walking, look up/down stairs - unless player is rotating view
			if ( !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
					ViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bSnapToLevel )
				{
					ViewRotation.Pitch = ViewRotation.Pitch & 65535;
					if (ViewRotation.Pitch > 32768)
						ViewRotation.Pitch -= 65536;
					ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(ViewRotation.Pitch) < 1000 )
						ViewRotation.Pitch = 0;	
				}
			}

			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			//add bobbing when walking
			if ( !bShowMenu )
			{
				if ( Speed2D < 10 )
					BobTime += 0.2 * DeltaTime;
				else
					BobTime += DeltaTime * (0.3 + 0.7 * Speed2D/GroundSpeed);
				WalkBob = Y * 0.65 * Bob * Speed2D * sin(6.0 * BobTime);
				if ( Speed2D < 10 )
					WalkBob.Z = Bob * 30 * sin(12 * BobTime);
				else
					WalkBob.Z = Bob * Speed2D * sin(12 * BobTime);
			}
		}	
		else if ( !bShowMenu )
		{ 
			BobTime = 0;
			WalkBob = WalkBob * (1 - FMin(1, 8 * deltatime));
		}

		// Update rotation.
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
			
		bPressedJump = false;
	}
	
	function BeginState()
	{
		// Set Camera Mode
		//CameraFixedBehind = false; // Patch change - the camera shouldn't change when entering different zones!
		
		if ( GetAnimGroup(AnimSequence) == 'Swimming' )
		{
			if (Velocity.Z > 0)
			{
				bJustJumpedOutOfWater=true;
				TweenToFlyingUp(0.1);
			}
			else
			TweenToFallingDown(0.1);
		}
		
		SetPhysics(PHYS_Falling);
	}
}

// Alternate firing control tests
//
// The player wants to fire.
exec function Fire( optional float F )
{
	if (bShowTutorial)
	{
		TutorialEnd();
		return;
	}
	
	if (bShowPurchase)
	{
		JazzHUD(MyHUD).DoPurchase();
		return;
	}

	// Conversation - Trap the fire button?
	if (JazzHUD(MyHUD) != None)
	if (JazzHUD(MyHUD).ConversationTrapButton())
		return;
	
	// Intro - Trap the fire button?
	if (JazzIntroHUD(MyHUD) != None)
	if (JazzIntroHUD(MyHUD).InterceptButton())
		return;
		
	if( bShowMenu || bShowInventory || Level.Pauser!="" )
		return;

	// Activate an object in front of the player	
	if (MyActivationIcon != None)
	if (MyActivationIcon.Focus != None)
	{
		MyActivationIcon.DoActivate();
		return;
	}

	// Check Weapon Cell Inventory Slot (0)
	if (InventorySelections[0] != None)
	{
		Weapon.bPointing = true;
		JazzWeaponCell(InventorySelections[0]).Fire(F);
		//ManaAmmo -= 2; // Patch change - take ammo away.
		PlayFiring();	
	}
}

// The player wants to alternate-fire.
exec function AltFire( optional float F )
{
	if ((bShowTutorial))
	{
		TutorialEnd();
		return;
	}
	
	if (bShowPurchase)
	{
		JazzHUD(MyHUD).DoPurchase();
		return;
	}
	
	// Conversation - Trap the fire button?
	if (JazzHUD(MyHUD) != None)
	if (JazzHUD(MyHUD).ConversationTrapButton())
		return;

	// Intro - Trap the fire button?
	if (JazzIntroHUD(MyHUD) != None)
	if (JazzIntroHUD(MyHUD).InterceptButton())
		return;
	
	if( bShowMenu || bShowInventory || Level.Pauser!="" )
		return;

	// Check Weapon Cell Inventory Slot (0)
	if (InventorySelections[0] == None)
		JazzWeapon(Weapon).ChangeCell(0);
		
	if (InventorySelections[0] != None)
	{
		Weapon.bPointing = true;
		JazzWeaponCell(InventorySelections[0]).AltFire(F);
		PlayFiring();
		//ManaAmmo -= 20; // Patch change - take ammo away.
	}
}

// Abruptly ends all firing processes.  You must halt or change the animation manually as you see fit.
//
function AbruptFireHalt ()
{
	bFire 		= 0;
	bAltFire 	= 0;
//	bLeft 		= 0;
//	bRight 		= 0;
	
	// Check Weapon Cell Inventory Slot (0)
	if (InventorySelections[0] == None)
	{
		Weapon.GotoState('Idle');
	}
	else
	{
		JazzWeaponCell(InventorySelections[0]).GotoState('Idle');
	}
}


/////////////////////////////////////// Character Swimming //////////////////////////////////////
// Swimming
// Player movement.
// Player Swimming
state PlayerSwimming
{
	ignores SeePlayer, HearNoise, Bump;

	function Landed(vector HitNormal)
	{
		if (!bNoclip)
		{
			PlayLanded(Velocity.Z);
			if (Velocity.Z < -1.2 * JumpZ)
			{
				MakeNoise(-0.5 * Velocity.Z/(FMax(JumpZ, 150.0)));
				if (Velocity.Z <= -1100)
				{
					if ( (Velocity.Z < -2000) && (ReducedDamageType != 'All') )
					{
						health = -1000; //make sure gibs
						Died(None, 'fell', Location);
					}
					else if ( Role == ROLE_Authority )
						TakeDamage(-0.1 * (Velocity.Z + 1050), Self, Location, vect(0,0,0), 'fell');
				}
			}
			else if ( (Level.Game != None) && (Level.Game.Difficulty > 1) && (Velocity.Z > 0.5 * JumpZ) )
				MakeNoise(0.1 * Level.Game.Difficulty);				
			bJustLanded = true;
			if ( Region.Zone.bWaterZone )
				SetPhysics(PHYS_Swimming);
			else
			{
				GotoState('PlayerWalking');
				AnimEnd();
			}
		}
	}

	function SwimAnimUpdate(bool bNotForward)
	{
		if ( !bAnimTransition && (GetAnimGroup(AnimSequence) != 'Gesture') )
		{
			if ( bNotForward )
		 	{
			 	 if ( GetAnimGroup(AnimSequence) != 'Waiting' )
					TweenToSwimming(0.1);
			}
			else if ( GetAnimGroup(AnimSequence) == 'Waiting' )
				TweenToSwimming(0.1);
		}
	}

	function AnimEnd()
	{
		local vector X,Y,Z;
		GetAxes(Rotation, X,Y,Z);
		if ( (Acceleration Dot X) <= 0 )
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition = true;
				TweenToTreading(0.2);
			} 
			else
				PlayTreading();
		}	
		else
		{
			if ( GetAnimGroup(AnimSequence) == 'TakeHit' )
			{
				bAnimTransition = true;
				TweenToSwimming(0.2);
			} 
			else
				PlaySwimming();
		}
	}
	
	function ZoneChange( ZoneInfo NewZone )
	{
		local actor HitActor;
		local vector NewLocation,HitLocation, HitNormal, checkpoint;

		Global.ZoneChange(NewZone);
	
		if (!NewZone.bWaterZone && !bNoclip)
		{
			VoicePackActor.DoSound(Self,VoicePackActor.SplashOut);
			
			SetPhysics(PHYS_Falling);

			if ((SwimmingJumpDuration>MaxSwimmingJumpDuration*0.8))
			{
				// Do A Jump out of the water (It works now)
				SetPhysics(PHYS_Falling);
				
				Velocity.Z = JumpZ*0.8;
				
				DoubleJumpReadyTime = 1.5;
				DoubleJumpDelayTime = 0.5;
				PlayInAir();
				GotoState('PlayerWalking');
			}
			else
			if (!FootRegion.Zone.bWaterZone || (Velocity.Z > 160) )
			{
				GotoState('PlayerWalking');
				AnimEnd();
			}
			else //check if in deep water
			{
				checkpoint = Location;
				checkpoint.Z -= (CollisionHeight + 6.0);
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, false);
				if (HitActor != None)
				{
					GotoState('PlayerWalking');
					AnimEnd();
				}
				else
				{
					Enable('Timer');
					SetTimer(0.7,false);
				}
			}
		}
		else
		{
			Disable('Timer');
			SetPhysics(PHYS_Swimming);
		}
	}

	// Redo update rotation to remove view up/down motion.
	//
	
	//////////////////////////////////////////////////////////// Swimming Rotations ////////////////////////////////////////////////////
	
	function UpdateRotation(float DeltaTime, float maxPitch)
	{
		local rotator newRotation;
		
		local float TestValue;	// Patch change - This is used for making Jazz face the angle of his movement
		local bool  YawReverse; // Patch change - This is used for making Jazz face the angle of his movement
		
		local float PitchTestValue;	// Patch change - This is used for making Jazz face the angle of his movement
		local bool  PitchReverse; 	// Patch change - This is used for making Jazz face the angle of his movement
		
		local vector FacingVector;
		
		DesiredRotation = ViewRotation; //save old rotation
		
		// Remove viewrotation up/down
		//
		DesiredRotation = ViewRotation; //save old rotation
		ViewRotation.Pitch += 8.0 * DeltaTime * aLookUp;		// Was 16
		ViewRotation.Pitch = ViewRotation.Pitch & 65535;
		If ((ViewRotation.Pitch > 17000) && (ViewRotation.Pitch < 50000))
		{
			If (aLookUp > 0) 
				ViewRotation.Pitch = 17000;
			else
				ViewRotation.Pitch = 50000;
		}
	
		switch (CameraInUse)
		{
			case CAM_Behind:
				ViewRotation.Yaw += 16.0 * DeltaTime * aTurn;	// Was 16.0
			
			break;
			case CAM_Roaming:
			ViewRotation.Yaw = (ViewRotation.Yaw + 
				RotateTowardYaw(BasePlayerFacing.Yaw-DesiredFacing.Yaw,ViewRotation.Yaw,DeltaTime*5));
				
			break;
		}
			
		ViewShake(deltaTime);
		ViewFlash(deltaTime);
		
		newRotation = Rotation;
		
		// Not quite rotations, but it does the job here
		//abs(aStrafe * aStrafe + aForward * aForward))
		
		/*if ( sqrt(abs(FacingVector.X * FacingVector.X + FacingVector.Y
		 * FacingVector.Y + FacingVector.Z * FacingVector.Z)) < 0.5 )
		{ SwimmingAnimationSpeed += ( 0.5 - SwimmingAnimationSpeed ) * DeltaTime*2; }
		else
		{ SwimmingAnimationSpeed += ( 1.5 - SwimmingAnimationSpeed ) * DeltaTime*2; }*/
		if ( sqrt(abs(aStrafe*aStrafe + aForward*aForward + aUp*aUp)) < 0.2 )
		{ SwimmingAnimationSpeed = 0.5; }
		else
		{ SwimmingAnimationSpeed = 1; }
		
		//SwimmingAnimationSpeed = 0.1 + sqrt(abs(FacingVector.X * FacingVector.X + FacingVector.Y * FacingVector.Y));
			
		// Patch change - When a weapon is used, the character looks in the direction of the camera.
		if (Weapon.bPointing == true)
		{
			newRotation.Yaw = ViewRotation.Yaw;
			newRotation.Pitch = ViewRotation.Pitch;
		}
		else
		// Patch change - ...Or else it rotates in both Pitch and Yaw axes depending on his movement.
		{
			if (sqrt(abs(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y + Velocity.Z * Velocity.Z)) > 0.4 )
			{
				FacingVector = Velocity;
				//FacingVector.X += (Velocity.X - FacingVector.X)*DeltaTime*0.1;
				//FacingVector.Y += (Velocity.Y - FacingVector.Y)*DeltaTime*0.1;
				//FacingVector.Z += (Velocity.Z - FacingVector.Z)*DeltaTime*0.1;
			}
			// Got a nice code from the Taga bee's code - before this I used something similar,
			// but it didn't exactly work propertly. So thanks to whoever coded that!
			
			YawReverse = (FacingVector.X<0);
			TestValue = (FacingVector.Y+0.1)/FacingVector.X;
			if (YawReverse)
			newRotation.Yaw = (-16384-(16384-atan(TestValue)/Pi/2*65536)) & 65535;
			else
			newRotation.Yaw = (atan(TestValue)/Pi/2*65536) & 65535;
			
			newRotation.Pitch = (atan(FacingVector.Z/
			sqrt(abs(FacingVector.X * FacingVector.X + FacingVector.Y * FacingVector.Y)))
			/Pi/2*65536) & 65535;
		}

		setRotation(newRotation);
	}

	// Trace to vector V and see if anything is in the way.
	//
	function float WaterSurfaceDistance( )
	{
		local vector 	HitLocation,HitNormal;
		local actor 	Result;
		local bool		ActorFound;
		local float		NewDist;
	
		Result = Trace( HitLocation, HitNormal, Location + vect(0,0,1000), Location );

		return (VSize(HitLocation - Location));
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		local vector X,Y,Z, Temp;

		GetAxes(ViewRotation,X,Y,Z);
		Acceleration = NewAccel;

		// Buoyancy
		//Velocity.Z += 3;
		
		if (bNoclip && Physics != PHYS_Swimming)
		{ SetPhysics(PHYS_Swimming); }

		//WaterSurfaceDistance();

		if ( !bAnimTransition && (GetAnimGroup(AnimSequence) != 'Gesture') )
		{
			if ((X Dot Acceleration) <= 0)
	 		{
		 		 if ( GetAnimGroup(AnimSequence) != 'Swimming' )
					TweenToSwimming(0.1);
			}
			else if ( GetAnimGroup(AnimSequence) == 'Waiting' )
				TweenToSwimming(0.1);
		}
		bUpAndOut = ((X Dot Acceleration) > 0) && ((Acceleration.Z > 0) || (ViewRotation.Pitch > 2048));
		/*if ( bUpAndOut && !Region.Zone.bWaterZone && 
		/*CheckWaterJump(Temp) &&*/
			(bPressedJump || (SwimmingJumpDuration>0)) ) //check for waterjump
		{
			//velocity.Z = 330 + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
			/*velocity.Z = JumpZ; //set here so physics uses this for remainder of tick
			PlayDuck();
			GotoState('PlayerWalking');
			bPressedJump = false;
			SwimmingJumpDuration = 0;*/
		}
		else
		if ( aUp != 0 ) //(bPressedJump) Patch change - Jazz should smoothly swim up, instead of roughly shooting up.
		{*/
			//Velocity.Z += 500; 
			SwimmingJumpDuration = MaxSwimmingJumpDuration;
		/*}
		else
		if (SwimmingJumpDuration>0)
		{
			SwimmingJumpDuration-=DeltaTime;
			Velocity.Z = 300*(SwimmingJumpDuration/MaxSwimmingJumpDuration);
		}*/
	}

	event PlayerTick( float DeltaTime )
	{
		Global.PlayerTick(DeltaTime);
	
		if ( bUpdatePosition )
			ClientUpdatePosition();
		
		PlayerMove(DeltaTime);
		
		// Generate Bubbles
		GenerateBubbles(DeltaTime);
	}
	
	function GenerateBubbles ( float DeltaTime )
	{
		local vector NewLocation;
		if (FRand()-(sqrt(abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z))/250) < 0.05)
		{
			NewLocation = Location + VRand()*FRand()*50;
			spawn(class'WaterBubble',,,NewLocation);
		}
	}
	

	function PlayerMove(float DeltaTime)
	{
		local rotator oldRotation;
		local vector X,Y,Z, NewAccel;
		local float Speed2D;
	
		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.2;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aStrafe  *= 0.2;
		aUp		 *= 0.2;

		// Check for distance from top of the water and adjust buoyancy
		NewAccel = aForward*X + aStrafe*Y + aUp*vect(0,0,1); // Patch Change - Added the Y axis so Jazz can actually strafe underwater!
	
		//add bobbing when swimming
		/*if ( !bShowMenu )
		{
			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);
			WalkBob = Y * Bob *  0.5 * Speed2D * sin(4.0 * Level.TimeSeconds);
			WalkBob.Z = Bob * 1.5 * Speed2D * sin(8.0 * Level.TimeSeconds);
		}*/

		//SwimAnimUpdate();		// 220 Change

		// Update rotation.
		oldRotation = Rotation;
		UpdateRotation(DeltaTime, 2);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DODGE_None, OldRotation - Rotation);
			
		bPressedJump = false;
	}

	function Timer()
	{
		if ( !Region.Zone.bWaterZone && !bNoclip && (Role == ROLE_Authority) )
		{
			GotoState('PlayerWalking');
			AnimEnd();
		}
	
		Disable('Timer');
	}
	
	function BeginState()
	{
		local rotator NewRotation;
	
		// Set Camera Mode
		CameraFixedBehind = true;
			
		Disable('Timer');
		if ( !IsAnimating() )
			TweenToWaiting(0.3);
			
		if (Velocity.Z > -500)
		VoicePackActor.DoSound(Self,VoicePackActor.SplashMinor);
		else
		VoicePackActor.DoSound(Self,VoicePackActor.SplashMajor);
			
		SwimmingJumpDuration = 0;
		DashTime = 0;
//		NewRotation = Rotation;
//		NewRotation.Yaw = NewRotation.Yaw & 65535;
//		SetRotation(NewRotation);
//		ViewRotation.Yaw = ViewRotation.Yaw & 65535;
	}
	
	function EndState ()
	{
		BasePlayerFacing.Yaw = Rotation.Yaw & 65535;
	}
}
////////////////////////////////////////////////////////////////////////////////////////////////////
// RideVehicle
//
state RideVehicle
{

	event ForwardCheck()
	{
		local vector	HitLocation,HitNormal;
		local actor 	A;
		local int		NewDist;
	
		A = Trace( HitLocation, HitNormal, 
			Location + 80 * Velocity, Location );

		NewDist = VSize(Location - HitLocation);
	
		// Touching Forward Wall
		if (NewDist < 80)
		{
			Vehicle.HandleBumpForward();
		}
	}

	function PlayerTick ( float DeltaTime )
	{
		Global.PlayerTick( DeltaTime );
	
		PlayerMove(DeltaTime);

		// Check if something is rather close in motion direction
		if (Vehicle.BumpForwardCheck) 	ForwardCheck();	
	}
	
	function ForceHover ()
	{
		local vector View,HitLocation,HitNormal,NewLocation;
		local rotator CheckRotation;
		local float Distance;
	
		// Make sure above surface sufficiently
		//
		CheckRotation.Pitch = 65536/4;
		View = vect(1,0,0) >> CheckRotation;
		if( Trace( HitLocation, HitNormal, Location - 100 * vector(CheckRotation), Location ) != None )
			Distance = (Location - HitLocation) Dot View;
			
		if (Distance < 50)
		{
		NewLocation = Location;
		NewLocation.Z += 50-Distance;
		}
	}
	
	event PreRender( canvas Canvas )
	{
		Vehicle.AcceptPlayerRotation(Rotation);			// Move to prerender
		Vehicle.AcceptVehicleLocation(Location,Rotation);
		Super.PreRender(Canvas);
	}
	
	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)
	{
		local vector OldAccel,VelocityChange,NewVelocity;
		local float OldVelocityKeep,OldVelocityChangeKeep;

		OldAccel = Acceleration;
		Acceleration += NewAccel;
		
		//Acceleration.Z -= 1000;
		
		Vehicle.FilterSpeed(Acceleration,Velocity,DeltaTime);
		
		// SpecialMotion button handling for vehicles
		// This is not used anymore
		/*if (aStrafe>0)
		{
			Vehicle.PlayerPressedSpecialMotion( SpecialMotionHeldTime );
			SpecialMotionHeldTime += DeltaTime;
		}
		else
			SpecialMotionHeldTime = 0;*/

		// JAZZ3 : This is the code that allows some motion at any time.
		//if (Physics == PHYS_Walking)
		//{

			// Override Velocity System
			NewVelocity = Velocity;
			VelocityChange = Velocity - VelocityHistory;
			Velocity = (NewAccel * DeltaTime * 0.5) + Vehicle.FilterVelocityHistory(VelocityHistory,DeltaTime);
			Velocity.Z = NewVelocity.Z;
		//}
		
		/*if ((Physics != PHYS_Walking) && (Vehicle.FlyingVehicle == true))
		{
		// Override Velocity System
		NewVelocity = Velocity;
		VelocityChange = Velocity - VelocityHistory;
		Velocity = (NewAccel * DeltaTime * 0.5) + Vehicle.FilterVelocityHistory(VelocityHistory,DeltaTime);
		}*/
		
		//Acceleration.Y += 100;
		//Velocity.Y += 100;
		
		if (VehicleBounce)
		{
		Velocity.Z = Vehicle.FilterBounce(VelocityHistory.Z);
		if (Velocity.Z > 10) SetPhysics(Vehicle.FallingPhysics);
		VehicleBounce = false;
		}
		
		VelocityHistory = Velocity;
		
		bIsTurning = ( Abs(DeltaRot.Yaw/DeltaTime) > 5000 );

		// Jump Handling
		//
		if ( bPressedJump )
		{
			Vehicle.PlayerPressedJump();
		}
		//bPressedJump = false;
	}
	
	// Redo update rotation to remove view up/down motion.
	//
	function UpdateRotation(float DeltaTime, float maxPitch)
	{
		if (!Vehicle.Rotate360)
		{
			Global.UpdateRotation(DeltaTime,maxPitch);
		}
	}

	function ClientSetRotation( rotator NewRotation )
	{
		ViewRotation = NewRotation;
	}
	
	event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
	{
		local vector View,HitLocation,HitNormal;
		local float ViewDist, WallOutDist, TargetYaw, TargetPitch, DeltaTime;
		local vector ResultLocation;
	
		Global.PlayerCalcView(ViewActor,CameraLocation,CameraRotation);
		return;
	
		if ( ViewTarget != None )
		{
			ViewActor = ViewTarget;
			CameraLocation = ViewTarget.Location;
			CameraRotation = ViewTarget.Rotation;
			if ( Pawn(ViewTarget) != None )
			{
			if ( (Level.NetMode == NM_StandAlone) 
				&& (ViewTarget.IsA('PlayerPawn') || ViewTarget.IsA('Bot')) )
					CameraRotation = Pawn(ViewTarget).ViewRotation;

			CameraLocation.Z += Pawn(ViewTarget).EyeHeight;
		}

		return;
	}

	// View rotation.
	ViewActor = Self;
	CameraRotation = ViewRotation;

	if( bBehindView ) //up and behind
	{
	    ViewDist    = 200;
		WallOutDist = 60;

		View = vect(1,0,0) >> CameraRotation;
		//ResultLocation = 
		
		if( Trace( HitLocation, HitNormal, MyCameraLocation, SmoothLocForCam ) != None )
			ViewDist = FMin( (Location - HitLocation) Dot View, ViewDist );
		CameraLocation -= (ViewDist - WallOutDist) * View;
	}
	else
	{
		// First-person view.
		CameraLocation = Location;
		CameraLocation.Z += EyeHeight;
		CameraLocation += WalkBob;
	}
	}

	function PlayerMove( float DeltaTime )
	{
		local vector X,Y,Z, NewAccel;
		local EDodgeDir OldDodge;
		local eDodgeDir DodgeMove;
		local rotator OldRotation;
		local float Speed2D;
		local bool	bSaveJump;
		local vector NewLocation;

		// Flying vehicle check
		if ((Physics == Vehicle.FallingPhysics) && (Vehicle.FlyingVehicle == true))
		{
			//SetPhysics(PHYS_Flying);
			Velocity = VelocityHistory;
		}


		aForward *= 0.4;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		
		aForward = Vehicle.FilterForwardBack(aForward,DeltaTime);
		aTurn = Vehicle.FilterTurn(aTurn,DeltaTime);
		
		// Update acceleration.
		if (Vehicle.Rotate360)
		{
		//NewAccel = aForward*X;
		//GetAxes(ViewRotation,X,Y,Z);
		NewAccel = vector(ViewRotation)*aForward;
		}
		else
		{
		GetAxes(Rotation,X,Y,Z);
		NewAccel = aForward*X + aStrafe*Y;
		}
		
		//NewAccel.Z = 0;		// CHANGED - IS THIS OK?
		
/*		if ( (Physics == PHYS_Walking) && (GetAnimGroup(AnimSequence) != 'Dodge') )
		{
			//if walking, look up/down stairs - unless player is rotating view
			if ( !bKeyboardLook && (bLook == 0) )
			{
				if ( bLookUpStairs )
					ViewRotation.Pitch = FindStairRotation(deltaTime);
				else if ( bSnapToLevel )
				{
					ViewRotation.Pitch = ViewRotation.Pitch & 65535;
					if (ViewRotation.Pitch > 32768)
						ViewRotation.Pitch -= 65536;
					ViewRotation.Pitch = ViewRotation.Pitch * (1 - 12 * FMin(0.0833, deltaTime));
					if ( Abs(ViewRotation.Pitch) < 1000 )
						ViewRotation.Pitch = 0;	
				}
			}

			Speed2D = Sqrt(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y);

		}	
		else if ( !bShowMenu )
		{ 
		}*/

		// Update rotation.
		OldRotation = Rotation;
		UpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
		else
			ProcessMove(DeltaTime, NewAccel, DodgeMove, OldRotation - Rotation);
			
		bPressedJump = false;
	}

	
	function ValidVehicle ()
	{
		if (Vehicle == None)
		{
			ReturnToNormalState();
		}
	}
	
	function Landed(vector HitNormal)
	{
		VehicleBounce = true;		// Register that the vehicle will now bounce in ProcessMove

		AnimEnd();	
		SetPhysics(Vehicle.NormalPhysics);
	}
	
	function ZoneChange( ZoneInfo NewZone )
	{
		local actor HitActor;
		local vector HitLocation, HitNormal, checkpoint;

		Global.ZoneChange(NewZone);

		if (!NewZone.bWaterZone)
		{
			SetPhysics(Vehicle.FallingPhysics);
			//if (bUpAndOut && CheckWaterJump(HitNormal)) //check for waterjump
			if (bUpAndOut)
			{
				velocity.Z = JumpZ + 2 * CollisionRadius; //set here so physics uses this for remainder of tick
				PlayDuck();
				//DoJump();
				DoubleJumpReadyTime = 1.5;
				DoubleJumpDelayTime = 0.5;
				ReturnToNormalState();
			}				
			else if (!FootRegion.Zone.bWaterZone || (Velocity.Z > 160) )
			{
				GotoState('PlayerWalking');
				AnimEnd();
			}
			else //check if in deep water
			{
				checkpoint = Location;
				checkpoint.Z -= (CollisionHeight + 6.0);
				HitActor = Trace(HitLocation, HitNormal, checkpoint, Location, false);
				if (HitActor != None)
				{
					GotoState('PlayerWalking');
					AnimEnd();
				}
				else
				{
					Enable('Timer');
					SetTimer(0.7,false);
				}
			}
		}
		else
		{
			Disable('Timer');
			SetPhysics(PHYS_Swimming);
		}
	}
	
	function BeginState ()
	{
		// Set Camera Mode
		CameraFixedBehind = false;	// Override later with vehicle-specific camera
		AirSpeed = Vehicle.GroundSpeed;
		GroundSpeed = Vehicle.GroundSpeed;
		
		DashTime = 0;
		SetPhysics(Vehicle.NormalPhysics);
	}
	
	function EndState ()
	{
		GroundSpeed = DefaultGroundSpeed;
		VelocityHistory = vect(0,0,0);
		
		// Cool Effect :)
		DashTime = 3;
	}
	
	function AnimEnd()
	{
		local int Vel;
		
		if ((Physics == Vehicle.NormalPhysics) && (Vehicle.bAllowPlayerWalkAnimation))
		{
		Vel = VSize(Velocity);
		
		if ((Vel>200) || (Vel<-200))
		PlayRunning();
		else
		if ((Vel>10) || (Vel<-10))
		PlayWalking();
		}
		else
		{
		PlayWaiting();
		//TweenAnim('Breath1L',0.3);
		//PlayAnim('Breath1L');
		}
	}

Begin:
	// Prepare Initial Motion
	bPressedJump = false;
	
	AnimEnd();
		
	DefaultGroundSpeed = GroundSpeed;
	GroundSpeed = Vehicle.GroundSpeed;
	ValidVehicle();
}


//////////////////////////
// Vehicle Exit
//
function LeaveVehicle()
{
	// Return Rider to Normal
	Vehicle = None;
		
	// If in a water zone currently, swim, otherwise goto walking and act from there.
	ReturnToNormalState();
}


///////////////////////////////////////////////////////////////////////////////////////////////
// Player Inventory															INVENTORY
///////////////////////////////////////////////////////////////////////////////////////////////
//
replication
{
	reliable if( Role<ROLE_Authority )
		InventoryMenu,NewInventoryItem;
}

exec function InventoryMenu()
{
	JazzHUD(myHUD).DoInventoryMenu();
}

// New JazzInventoryItem Found
//
event NewInventoryItem()
{
	JazzHUD(myHUD).NewInventoryItem();
}

function SetInventorySelection( int Group, Inventory Inv )
{
	if (Group==0)	// Weapon Cell Selection
	{
	DeSelectCurrentWeapon();
	if (JazzWeapon(Inv) != None)
		InventorySelections[Group]=None;
		else
		InventorySelections[Group]=Inv;
	SelectCurrentWeapon();
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////
// Player Inventory															INVENTORY
///////////////////////////////////////////////////////////////////////////////////////////////
//
function AddScore(int ScoreAdd)
{
	if (ScoreAdd != 0)
	{
		PlayerReplicationInfo.Score += ScoreAdd;
		JazzHUD(MyHUD).UpdateScore();
	}
}

function ChangeLives(int LifeAdd,optional int LifeTo)
{
	JazzHUD(MyHUD).UpdateComponent(7,20);
	
	if (LifeTo>0)
	{
		Lives = LifeTo;
	}
	else
	{
		Lives += LifeTo;
	}
}

// Weapon Powerup (Add an entire level(s))
//
function AddPowerLevel()
{
	JazzWeapon(Weapon).AddPowerLevel();
}

// Weapon Experience Increase
// 
function AddWeaponExperience( int XP )
{
	JazzWeapon(Weapon).AddWeaponExperience(XP);
	JazzHUD(MyHUD).UpdateWeaponExperience();
}

// Food Eaten
//
function EatFood( bool Poison )
{
	if (Poison==true)
	VoicePackActor.DoSound(Self,VoicePackActor.Poisoned);
	else
	VoicePackActor.EatSound(Self);
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// Weapon Selection
//////////////////////////////////////////////////////////////////////////////////////////////	
//
// Switch to next weapon
//
exec function NextWeapon()
{
	JazzWeapon(Weapon).ChangeWeapon(1);
}

// Switch to previous weapon
//
exec function PrevWeapon()
{
	JazzWeapon(Weapon).ChangeWeapon(-1);
}

// Switch to next weapon
//
exec function NextCell()
{
	JazzWeapon(Weapon).ChangeCell(1);
}

// Switch to previous weapon
//
exec function PrevCell()
{
	JazzWeapon(Weapon).ChangeCell(-1);
}

// Tell Current Weapon It Is Being Deselected
//
function DeSelectCurrentWeapon()
{
	if (InventorySelections[0] == None)
		JazzWeapon(Weapon).DeSelectWeapon();
	else
		JazzWeaponCell(InventorySelections[0]).DeSelectWeapon();
}

// Tell Current Weapon It Is Being Selected
//
function SelectCurrentWeapon()
{
	if (InventorySelections[0] == None)
		JazzWeapon(Weapon).SelectWeapon();
	else
		JazzWeaponCell(InventorySelections[0]).SelectWeapon();
}

//////////////////////////////////////////////////////////////////////////////////////////////	
// HUD Displays															HUD COMMANDS
//////////////////////////////////////////////////////////////////////////////////////////////	
//
function UpdateCarrot()	// Money
{
	JazzHUD(MyHUD).UpdateCarrots();
}
function UpdateKeys()
{
}
function AddHealth( int AddHealth )
{
	if (AddHealth != 0)
	{
	JazzHUD(MyHUD).UpdateHealth();
	Health += AddHealth;
	if (Health > HealthMaximum)	Health = HealthMaximum;
	}
}
function bool NeedHealth()
{
	return (Health<HealthMaximum);
}


///////////////////////////////////////////////////////////////////////////////////////////////
// Player Input																INPUT
///////////////////////////////////////////////////////////////////////////////////////////////
//
// Override PlayerInput to add support for mini-menus like the input display.
//
event PlayerInput( float DeltaTime )
{
	local float SmoothTime, MouseScale;
	//local bool  JazzWindowsHasControl;
	
	if (( (bShowMenu) && (myHud != None) ) || (bShowTutorial) || (Conversation)) // Patch change - lock the controls if we have a conversation!
	{
		if ((bShowMenu) && ( myHud.MainMenu != None ))
		{
			myHud.MainMenu.MenuTick( DeltaTime );
		}
		else
		if (bShowTutorial)
		{
			JazzHud(myHud).TutorialTick( DeltaTime );
		}
		
		// clear inputs
		bEdgeForward = false;
		bEdgeBack = false;
		bEdgeLeft = false;
		bEdgeRight = false;
		bWasForward = false;
		bWasBack = false;
		bWasLeft = false;
		bWasRight = false;
		aStrafe = 0;
		aTurn = 0;
		aForward = 0;
		aLookUp = 0;
		return;
	}
	else if ( bDelayedCommand )
	{
		bDelayedCommand = false;
		ConsoleCommand(DelayedCommand);
	}
				
	// Check for Dodge move
	bEdgeForward = (bWasForward ^^ (aBaseY > 0));
	bEdgeBack = (bWasBack ^^ (aBaseY < 0));
	bEdgeLeft = (bWasLeft ^^ (aBaseX < 0));
	bEdgeRight = (bWasRight ^^ (aBaseX > 0));
	bWasForward = (aBaseY > 0);
	bWasBack = (aBaseY < 0);
	bWasLeft = (aStrafe > 0);
	bWasRight = (aStrafe < 0);
	
	if (aLookUp != 0)
		bKeyboardLook = true;
	if (bSnapLevel != 0)
		bKeyboardLook = false;


	// Additional Code
	//
	// (1) If Mouse was being moved forward or backward a large amount and not side-to-side, slow
	// the X axis down considerably at first.
	// Patch change - why!?
	//if ((abs(aMouseY)>100) && (aMouseX==0))
	//	aMouseX = aMouseX/5;
	
	// Smooth and amplify mouse movement
	SmoothTime = FMin(0.2, 3 * DeltaTime);
	MouseScale = MouseSensitivity * DesiredFOV * 0.0111;
	aMouseX = aMouseX * MouseScale;
	aMouseY = aMouseY * MouseScale;
	
	SmoothMouseX = aMouseX*2;
	SmoothMouseY = aMouseY*2;

	aMouseX = 0;
	aMouseY = 0;

	// Remap raw x-axis movement.
	if( bStrafe!=0 )
	{
		// Strafe.
		aStrafe += aBaseX + SmoothMouseX;
		aBaseX   = 0;
	}
	else
	{
		// Forward.
		aTurn  += aBaseX + SmoothMouseX;// }
		aBaseX  = 0;
	}

	// Remap mouse y-axis movement.
	if( (bAlwaysMouseLook || (bLook!=0)) && !Conversation ) // Patch change - allow the player to look up and down at all times
	{
		// Look up/down.
		bKeyboardLook = false;
		if ( bInvertMouse )
		{ aLookUp -= SmoothMouseY; }
		else
		{ aLookUp += SmoothMouseY; }
	}

	// Remap other y-axis movement.
	aForward += aBaseY;
	aBaseY    = 0;

	// Handle walking.
	HandleWalking();

	// Inventory Menu Input
	if (JazzHUD(myHud) != None)
	JazzHUD(myHud).UpdateInventoryTick(DeltaTime);
	
	if (bShowInventory)
	{
		// clear inputs
		bEdgeForward = false;
		bEdgeBack = false;
		bEdgeLeft = false;
		bEdgeRight = false;
		bWasForward = false;
		bWasBack = false;
		bWasLeft = false;
		bWasRight = false;
		bPressedJump = false;
		aStrafe = 0;
		aTurn = 0;
		aForward = 0;
		aLookUp = 0;
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////
// UnrealL Menu Overrides													INVENTORY
///////////////////////////////////////////////////////////////////////////////////////////////
//
exec function ShowLoadMenu()
{
	if (JazzGameInfo(Level.Game).SinglePlayerGame==true)
	{
		bSpecialMenu = true;
		SpecialMenu = class'JazzDeadMenu';
		ShowMenu();
	}
	else
	{
		ServerRestartPlayer();
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////
// Tutorial System															TUTORIAL
///////////////////////////////////////////////////////////////////////////////////////////////
//
// Every time some event happens in Jazz which corresponds to a tutorial #, that event should
// send a call to EventNum to see if this event has been handled before.  If not, the correct
// tutorial actor is called (JazzTutorial.u) to display the new information.
//
function TutorialCheck ( TutorialNumType EventNum )
{

	if (TutorialActive)		// Tutorials on?
	{
		if (Tutorial[EventNum] == 0)
		{
			JazzHUD(MyHUD).NewTutorial(TutorialText[EventNum],TutorialTitle[EventNum]);
			//JazzHUD(MyHUD).NewTutorial(TutorialText[1]);
			Tutorial[EventNum]++;
		}
	}
}

function NewTutorial ( string Text, string Title, optional bool Centered )
{
	JazzHUD(MyHUD).NewTutorial(Text,Title,Centered);
}
//
//
function DoEvent ( int Type, float Duration, string Message )
{
	JazzHUD(MyHUD).AddEvent(Type,Duration,Message);
}

// New Tutorial
//
//function NewExternalTutorialMessage ( TutorialDisplay Instigator, string TutorialDesc )
//{
	//JazzHUD(MyHUD).AddEvent(0,20,"Tutorial");
	//LastTutorialActor = Instigator;
//}

function TutorialEnd()
{
	JazzHUD(myHUD).TutorialEnd();
}

// Dancing Message
//
function ScreenMessage (string Message)
{
	JazzHUD(myHUD).ScreenMessage(Message,10);
}

//
//
exec function ActivateHelp ( )
{
	// No longer in use

	//local TutorialDisplay T;
	
	// First check if an In-Level tutorial is desiring to be displayed.  Otherwise go ahead and check for the last 
	// tutorial library # to display.
	//
	/*if (LastTutorialActor != None)
	{
		TutorialWindow.DoTutorial(Self,LastTutorialActor);
	}
	else
	if (LastTutorial>-1)
	{
		if (TutorialDisp[LastTutorial] != None)
		{
			T = spawn(TutorialDisp[LastTutorial]);
			T.DoTutorial(Self);
			T.Destroy();
		}
	}*/
}

///////////////////////////////////////////////////////////////////////////////////////////////
// Multiplayer Handling														MULTIPLAYER
///////////////////////////////////////////////////////////////////////////////////////////////
//
state TreasureHuntFinish
{
ignores SeePlayer, HearNoise, KilledBy, Bump, HitWall, HeadZoneChange, FootZoneChange, ZoneChange, Falling, TakeDamage;

	function BeginState()
	{
		bShowScores = true;
		SetPhysics(PHYS_None);
		/*
		THPlayerReplicationInfo(PlayerReplicationInfo).TreasureTime = TreasureHunt(Level.Game).GameTime;
		THPlayerReplicationInfo(PlayerReplicationInfo).TreasureFinish = true;
		*/
		HidePlayer();
	}
}

function PickUpFlag(CTFFlag Flag)
{
	bHasFlag = true;
	TeamFlag = Flag;
}

function GainLeader(float DrawScaleChange, float JumpZChange, bool bTLand)
{
	// Duration of effect
	LeaderGrowEffectTime = 2;

	// We are now the leader, do stuff
	OriginalScale = Default.DrawScale;
	LeaderDesiredScale = Default.DrawScale * DrawScaleChange;
	
	JumpZ *= JumpZChange;
	bThunderLand = bTLand;
	bLeader = true;
}

function LeaderEffectTick ( float DeltaTime )
{
	local float ScaleDelta;
	local float LeaderDelta;

	LeaderGrowEffectTime -= DeltaTime;
	ScaleDelta = LeaderDesiredScale - DrawScale;
	
	LeaderDelta = LeaderGrowEffectTime/2;
	
	if (bLeader==true)
	{
		// Effect To Leader
		DrawScale = OriginalScale + ScaleDelta*(1-LeaderDelta);
	}
	else
	{
		// Effect away from Leader
		DrawScale = OriginalScale + ScaleDelta*(LeaderDelta);
	}
	
	Style = STY_Translucent;
	ScaleGlow = abs(LeaderGrowEffectTime-1);
	
	// Return to normal when done
	if (LeaderGrowEffectTime<0)
	{
		Style = STY_Normal;
		ScaleGlow = 1;
		if (bLeader==true)
		{
		DrawScale = LeaderDesiredScale;
		}
		else
		{
		DrawScale = OriginalScale;
		}
	}

	SetCollisionSize(default.CollisionRadius*(DrawScale/OriginalScale), 
					 default.CollisionHeight*(DrawScale/OriginalScale));
}

function LoseLeader()
{
	// Duration of effect
	LeaderGrowEffectTime = 2;

	// We lost the leader status
	JumpZ = default.JumpZ;
	bThunderLand = default.bThunderLand;
	bLeader = false;
}

simulated function ThunderLandToss(vector TLLocation)
{
	local float dist, shake;
	local PlayerPawn aPlayer;
	local vector Momentum;


	dist = VSize(TLLocation - Location);
	shake = FMax(500, 1500 - dist);
	ShakeView( FMax(0, 0.35 - dist/20000), shake, 0.015 * shake);
	if ( Physics != PHYS_Walking )
		return;

	Momentum = -0.5 * Velocity + 100 * VRand();
	Momentum.Z =  7000000.0/((0.4 * dist + 350) * Mass);
	AddVelocity(Momentum);
}

function BecomeSpectator()
{
	GotoState('Spectate');
}

function LeaveSpectator()
{
	GotoState('Dying');
}

// Use for entering games before joining a team
state Spectate
{
	// Over-ride all movement and firing functions for now
	// Only leave mouse/menu for selecting team/player info

	event FootZoneChange(ZoneInfo newFootZone);
	event HeadZoneChange(ZoneInfo newHeadZone);
	exec function BehindView( Bool B );
	exec function Walk();
	function AnimEnd();
	exec function Grab();	
	function ServerChangeSkin(coerce string SkinName, coerce string FaceName, byte TeamNum);	
	exec function SwitchWeapon (byte F );
	exec function NextItem();
	exec function PrevItem();
	exec function ActivateItem();	
	
	exec function TeamChange(int n)
	{
		ChangeTeam(N);
	}

	function ProcessMove(float DeltaTime, vector NewAccel, eDodgeDir DodgeMove, rotator DeltaRot)	
	{
		Acceleration = NewAccel;
		MoveSmooth(Acceleration * DeltaTime);

		if (bPressedJump)		
		ViewClass(class'Pawn');
	}

	function Timer()
	{
		bFrozen = false;
		//bShowScores = true;	// TODO: Remove because it is annoying.  Add something else back in to show scores and not remove team select message.
		bPressedJump = false;
	}
	
	function ShowTeamMenu()
	{
		ShowMenu();
	}

	event PlayerTick( float DeltaTime )
	{
		if ( bUpdatePosition )
			ClientUpdatePosition();

		PlayerMove(DeltaTime);
	}

	function PlayerMove(float DeltaTime)
	{
		local rotator newRotation;
		local vector X,Y,Z;

		GetAxes(ViewRotation,X,Y,Z);

		aForward *= 0.1;
		aStrafe  *= 0.1;
		aLookup  *= 0.24;
		aTurn    *= 0.24;
		aUp		 *= 0.1;
	
		Acceleration = aForward*X + aStrafe*Y + aUp*vect(0,0,1);  

		UpdateRotation(DeltaTime, 1);

		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
		else
			ProcessMove(DeltaTime, Acceleration, DODGE_None, rot(0,0,0));
	}

	function BeginState()
	{
		EyeHeight = BaseEyeHeight;
		SetPhysics(PHYS_None);
		self.Mesh = None;
		self.SetCollision(false,false,false);
		bCollideWorld = true;		
		if  ( !IsAnimating() ) PlaySwimming();
	}
	
	function ClientReStart()
	{
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		BaseEyeHeight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;
	}
	
	function PlayerTimeOut()
	{
		if (Health > 0)
			Died(None, 'dropped', Location);
	}
	
	// Send a message to all players.
	exec function Say( string S )
	{
		if ( !Level.Game.bMuteSpectators )
			BroadcastMessage( PlayerReplicationInfo.PlayerName$":"$S, true );
	}
	
	//=============================================================================
	// functions.
	
	exec function RestartLevel()
	{
	}
	
	// This pawn was possessed by a player.
	function Possess()
	{
		bIsPlayer = true;
		DodgeClickTime = FMin(0.3, DodgeClickTime);
		EyeHeight = BaseEyeHeight;
		NetPriority = 8;
		Weapon = None;
		Inventory = None;
	}
	
	//=============================================================================
	// Inventory-related input notifications.
	
	// The player wants to switch to weapon group numer I.
	
	exec function Fire( optional float F )
	{
		ShowTeamMenu();
	}
	
	// The player wants to alternate-fire.
	exec function AltFire( optional float F )
	{
		Viewtarget = None;
		ClientMessage("Now viewing from own camera", 'Event', true);
	}
	
	//=================================================================================

	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, name damageType)
	{
	}
	
	function EndState()
	{
		self.mesh = default.mesh;
		self.bBlockActors = default.bBlockActors;
		self.bBlockPlayers = default.bBlockPlayers;
		self.bCollideWorld = default.bCollideWorld;
		self.SetCollision(true,true,true);
		self.bProjTarget = self.bProjTarget;
		Viewtarget = None;
	}
}

// Change Team
function ChangeTeam( int N )
{
	Level.Game.ChangeTeam(self, N);
	
	if ( Level.Game.bTeamGame )
		Died( None, '', Location );
}

function ThunderLand()
{
	local Pawn aPawn;
	local actor Other;
	local jazzPlayer aJazz;
	local vector Momentum;
	local float dist;
	
	// Possibly change 'Pawn' to 'Actor' to throw decorations and the like
	foreach RadiusActors(class'Actor', Other, 1500)
	{
		if ( Other.mass > 500 )
			return;
			
		dist = VSize(Other.Location - Location);
		
		aJazz = jazzPlayer(Other);
		
		if ( aJazz != None )
		{	
			aJazz.ThunderLandToss(Location);
			return;
		}
		
		
		// Some checking will need to be done to see what should be thrown
		/*
		Momentum = -0.5 * Other.Velocity + 100 * VRand();
		Momentum.Z =  7000000.0/((0.4 * dist + 350) * Other.Mass);
		Momentum.Z *= 5.0;
		Other.Velocity += Momentum;
		*/
	}
}

function Died(pawn Killer, name damageType, vector HitLocation)
{
	local vector Vel;
	
	// Reset Weapon
	if (InventorySelections[0] != None)
	{
		JazzWeaponCell(InventorySelections[0]).ChargeEnd();
		JazzWeaponCell(InventorySelections[0]).GotoState('Idle');
	}
	
	VoicePackActor.DeathSound(Self);
	
	/*if (Weapon == None)
	JazzWeapon(Weapon).ChangeWeapon(0);
	if (Weapon == None)
	JazzWeapon(Weapon).ChangeCell(0);*/
	
	
	
	if(bHasFlag)
	{
		Vel.X = (FRand()*1000)-500;
		Vel.Y = (FRand()*1000)-500;
	
		Vel.Z = (FRand()*500)+250;
	
		TeamFlag.GotoState('OnGround');
		
		TeamFlag.SetPhysics(PHYS_Falling);
		
		TeamFlag.Velocity = Vel;
	}

	bHasFlag = false;
	TeamFlag = none;
	Super.Died(Killer, damageType, HitLocation);
}

// Handle In-Air Motion
//
function PlayInAir() // Patch change - this is enabled again so Jazz plays his falling animation just as he falls off the edge.
// This also is no longer needed because the pullup animation is scrapped. If problems appear, this will be changed.
{
	if (Velocity.Z>0)
	{ PlayFlyingUp(); }
	else
	{ PlayFallingDown(); }
}

function PlayFlyingUp();
function PlayFallingDown();

function TweenToTreading(float tweentime);
function PlayTreading();

function TweenToFlyingUp(float tweentime);
function TweenToFallingDown(float tweentime);

//
// Multiplayer Messaging
//
event ClientMessage( coerce string S, optional name Type, optional bool bBeep )
{
	//if (Type == 'DeathMessage') 		// Ignore Message
		//return;

	if (Type=='')
		return;

	if (JazzGameInfo(Level.Game).SinglePlayerGame==false)
	if (JazzHUD(MyHUD) != None)	
	JazzHUD(MyHUD).AddEvent(1,10,S);
}

// Return to correct state
//
function ReturnToNormalState()
{
	if (Region.Zone.bWaterZone == true)
	{
		SetPhysics(PHYS_Swimming);
		GotoState('PlayerSwimming');
	}
	else if (!bNoclip)
	{
		SetPhysics(PHYS_Falling);
		GotoState('PlayerWalking');
	}
}

// Running Animation
//
function PlayRunning()
{
	// Extract forward/backward motion and strafing.
	//
	// Any strafing motion should take precedence over forward/backward, generally
	// because it will be displayed less and his motion will seem more accurate,
	// probably.  Regardless, just whatever looks ok.
	//
	
	if ( OldaStrafe != 0 )	// Strafing
	{
		if (OldaStrafe < 0)
		{ PlayStrafeLeft(); }
		else if (OldaStrafe > 0)
		{ PlayStrafeRight(); }
	}
	else
	{
		if (OldaForward>0)
		{ PlayRunForward(); }
		else
		if (OldaForward<0)
		{ PlayRunBackward(); }
		else
		{ PlayWaiting(); }
	}
}

function UpdateRunning ()
{
	if ( GetAnimGroup(AnimSequence) == 'Running' )
	{
		if ((aForward != 0) || (aStrafe != 0))
		{
			if (Physics != PHYS_Falling)
			{
				OldRunContinue=true;
				PlayRunning();
				OldRunContinue=false;
			}
		}
	}
}

// Redefined and Separated Movement Animations
//
function PlayStrafeLeft();
function PlayStrafeRight();
function PlayRunForward();
function PlayRunBackward();

// Dying state
//
state Dying
{
	function Timer()
	{
		bFrozen = false;
		//bShowScores = true;	// TODO: Remove until 'Press Fire to Play' message is displayed ok.
		bPressedJump = false;
	}
}

//
// Devon Special Effects
//
exec function BurnMe()
{
	local JazzFireEffect Fire;
	
	Fire = Spawn(class'JazzFireEffect',self);
	Fire.SetBase(Self);
	Fire.Activate(5,1.5,120,60,true, 0.2);
}

// The player wants to switch to weapon group numer I.
exec function SwitchWeapon (byte F )
{
	local weapon newWeapon;

	if ( bShowMenu || Level.Pauser!="" )
	{
		if ( myHud != None )
			myHud.InputNumber(F);
		return;
	}
	if ( Inventory == None )
		return;
	if ( (Weapon != None) && (Weapon.Inventory != None) )
		newWeapon = Weapon.Inventory.WeaponChange(F);
	else
		newWeapon = None;	
	if ( newWeapon == None )
		newWeapon = Inventory.WeaponChange(F);
	if ( newWeapon == None )
		return;

	if ( Weapon == None )
	{
		PendingWeapon = newWeapon;
		ChangedWeapon();
	}
	else
		Weapon = newWeapon;
		
/*	else if ( (Weapon != newWeapon) && Weapon.PutDown() )
		PendingWeapon = newWeapon;*/
}

// Used for the transition effect between levels
//
function DoTransitionMotion( optional string NewURL )
{
	if (TransitionTime <= 0)
	{
		TransitionTime = 2;
		URL = NewURL;
		GotoState('TronWalk');
	}
}

state TronWalk
{
	event PlayerTick( float DeltaTime )
	{
		Global.PlayerTick(DeltaTime);
		ViewFlash(DeltaTime);
	}

	event Timer ()
	{
		SetToBlack();
		if (URL != "")
		{
			TransitionBlack = true;
			Level.Game.SendPlayer(Self, URL);
			URL = "";
		}
		GotoState('PlayerWalking');
	}
	
	function ClientFlash( float scale, vector fog )
	{
	}

	function ClientInstantFlash( float scale, vector fog )
	{
	}

Begin:
	Acceleration = 10 * Normal(Acceleration);
	Velocity = 100 * Normal(Acceleration);
	SetTimer(TransitionTime,false);
	SetToNormal();
	FadeToBlack(30);
}

// Patch change - You only need one actor for a footstep decal
/*simulated function PlayFootStep(vector vOffset, rotator rOffset, class<Decal> FootClass, float left)
{	
	local vector HitLocation, HitNormal;
	local Rotator NewRot;
	local Actor Hit;
	
	Log("JazzPlayer) FootStep");

	if(JazzAdvancedZone(Region.Zone) != None)
	{
		PlaySound (JazzAdvancedZone(Region.Zone).JazzFootStep,SLOT_Misc,2.5);
	}
	else
	{
		PlaySound (VoicePackActor.FootStep,SLOT_Misc,2.5);
	}
	
	vOffset = vOffset << Rotation;
	vOffset = vOffset << rOffset;	
	
	// make footstep
	Hit = Trace( HitLocation, HitNormal, Location+vect(0,0,-400)+vOffset, Location+vOffset);
	
	if(Hit != None)
	{
		NewRot = rotator(HitNormal);
		//NewRot.Roll = Rotation.Roll;
		NewRot.Yaw = Rotation.Yaw+rOffset.Yaw;
		//spawn(FootClass,,,HitLocation,NewRot);
		FootStepDec = Spawn(class'JazzFootStep',self);
		FootStepDec.setrotation(NewRot);
		FootStepDec.setlocation(HitLocation);
		if (left == 1)
		{ FootStepDec.Texture = Texture'JazzArt.Decal.FootPrintLeft'; }
		else
		{ FootStepDec.Texture = Texture'JazzArt.Decal.FootPrintRight'; }

	}	
}*/


/* // Patch change - Footstep decals have been axed. They look a bit out of place,
// can't be used very well and overall just don't work right.
simulated function SpawnFootStepLeft(rotator NewRot)
{
	local rotator OldRot;
	Log("JazzPlayer) FootStep");

	if(JazzAdvancedZone(Region.Zone) != None)
	{ PlaySound(JazzAdvancedZone(Region.Zone).JazzFootStep,SLOT_Misc,2.5); }
	else
	{ PlaySound(VoicePackActor.FootStep,SLOT_Misc,2.5); }
	NewRot = rotation;
	
	
	// make footstep
	FootStepDec = Spawn(class'JazzFootStep',self);
	FootStepDec.Left = True;
	OldRot = FootStepDec.Rotation;
	OldRot.Yaw = NewRot.Yaw;
	FootStepDec.SetRotation(OldRot);
}

simulated function SpawnFootStepRight(rotator NewRot)
{
	local rotator OldRot;
	Log("JazzPlayer) FootStep");

	if(JazzAdvancedZone(Region.Zone) != None)
	{ PlaySound(JazzAdvancedZone(Region.Zone).JazzFootStep,SLOT_Misc,2.5); }
	else
	{ PlaySound(VoicePackActor.FootStep,SLOT_Misc,2.5); }
	
	// make footstep
	FootStepDec = Spawn(class'JazzFootStep',self);
	FootStepDec.Left = False;
	OldRot = FootStepDec.Rotation;
	OldRot.Yaw = NewRot.Yaw;
	FootStepDec.SetRotation(OldRot);
}*/

// Patch change - ...So instead of Footprints, Jazz now spawns smoke particles - most characters eventually will use this as well.
simulated function SpawnFootstepParticles()
{		
	// Make our footstep particles
	/*
	local int i;
	local vector FootPartLocation;

	Log("JazzPlayer) FootStep");
	
	FootPartLocation = Location;
	FootPartLocation.Z = Location.Z-40;
	for(i = 3; i > 0; i--)
	{
		JazzDirtPart = Spawn(class'JazzDirtSmoke',self);
		JazzDirtPart.NewLocation = FootPartLocation;
		if ( DashTime > 0 )
		{
			JazzDirtPart.Velocity.Z = sqrt(abs(velocity.X)+abs(Velocity.Y))*0.05;
			JazzDirtPart.DrawScale = 0.2+Rand(0.2);
		}
	}*/
	
	if (JazzAdvancedZone(Region.Zone) != None)
	{ PlaySound(JazzAdvancedZone(Region.Zone).JazzFootStep,SLOT_Misc,2.5); }
	else
	{ PlaySound(VoicePackActor.FootStep,SLOT_Misc,2.5); }
}

simulated function FootStepRight()
{
	SpawnFootstepParticles(); //PlayFootStep(vect(0,11,0),rot(0,0,0),class'JazzFootstep',0);
}

simulated function FootStepLeft()
{
	SpawnFootstepParticles(); //PlayFootStep(vect(0,-11,0),rot(0,0,0),class'JazzFootStep',1); // Orig - Left
}

Simulated function FootStepRightRight()
{
	SpawnFootstepParticles(); //PlayFootStep(vect(0,11,0),rot(0,16384,0),class'JazzFootStep',0);
}

Simulated function FootStepLeftRight()
{
	SpawnFootstepParticles(); //PlayFootStep(vect(0,-11,0),rot(0,16384,0),class'JazzFootStep',1); // Orig - Left
}

Simulated function FootStepRightLeft()
{
	SpawnFootstepParticles(); //PlayFootStep(vect(0,11,0),rot(0,-16384,0),class'JazzFootStep',0);
}

Simulated function FootStepLeftLeft()
{
	SpawnFootstepParticles(); //PlayFootStep(vect(0,-11,0),rot(0,-16384,0),class'JazzFootStep',1); // Orig - Left
}

Simulated function FootStepRightBack()
{
	SpawnFootstepParticles(); //PlayFootStep(vect(0,11,0),rot(0,32768,0),class'JazzFootStep',0);
}

Simulated function FootStepLeftBack()
{
	SpawnFootstepParticles(); //PlayFootStep(vect(0,-11,0),rot(0,32768,0),class'JazzFootStep',1); // Orig - Left
}

//
// This function Updates Jazz's visibility to other enemies.  Primarily so he can hide with the GizmoGun.
//
function UpdateVisibility ()
{
	Visibility = 128;
	
	if (TransmuteTime != 0)
	    if (VSize(Velocity)>50)
	    Visibility = 50;
	    else
		Visibility = 5;
}

function PlayAnimation( name Sequence, optional float Rate, optional float TweenTime )
{
//	if (TransmuteTime == 0)
	PlayAnim(Sequence,Rate,TweenTime);
}

defaultproperties
{
     PoisonTexture=Texture'JazzArt.Effects.NMurky'
     FrozenTexture=Texture'JazzArt.Effects.NWater2'
     PetrifyTexture=Texture'JazzArt.Effects.NRock'
     ManaAmmo=10.000000
     TransmuteSoundOn=Sound'JazzSounds.Weapons.gizmo1'
     TransmuteSoundOff=Sound'JazzSounds.Weapons.gizmo1'
     CameraInUse=CAM_Behind
     TargetIcon=Texture'JazzArt.Interface.target1'
     AirSpeed=800.000000
     PlayerReplicationInfoClass=Class'CalyGame.JazzPlayerReplicationInfo'
     bActorShadows=True
}
