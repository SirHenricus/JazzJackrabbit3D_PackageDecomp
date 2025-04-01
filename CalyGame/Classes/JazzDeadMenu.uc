//=============================================================================
// JazzDeadMenu.
//=============================================================================
class JazzDeadMenu expands JazzMenu;

var		int		MenuSoundNum;
var()	sound	SwooshMenuInSound;
	
var		int		MenuRightSide;

// Joystick Variable
var	  bool bJoystick;


// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	Log("JazzMenu) PostBeginPlay");

	ResetMenu();

	// Detects if joystick in use	
	//bJoystick =	bool(PlayerOwner.ConsoleCommandResult("get windrv.windowsclient usejoystick"));
	// 220 Version
}

function ResetMenu()
{
	// Plays sounds as menus move across the screen
	MenuSoundNum = 0;
	MenuExistTime = 0;
}

function bool ProcessSelection()
{
	local Menu ChildMenu;

	ChildMenu = None;
	if ( ! bBegun )
	{
		PlayEnterSound();
		bBegun = true;
	}

	if (Selection == 1)
	{
		// Reset Audio back up
		if (JazzPlayer(PlayerOwner) != None)
		{
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$JazzPlayer(PlayerOwner).MusicVolume);
		}

		PlayerOwner.ReStartLevel(); 
		return true;
	}
	else if ( Selection == 2 ) 
		ChildMenu = spawn(class'JazzLoadMenu', owner);
	else if ( Selection == 3 )
		//ChildMenu = spawn(class'JazzDifficultyMenu', owner); // Patch change - Why would you want to save/load game after choosing a new game? We need Difficulty settings!
		ChildMenu = spawn(class'JazzNewGameMenu', owner);
	else if ( Selection == 4 )
		ChildMenu = spawn(class'JazzQuitMenu', owner);
	else
		return false;

	if ( ChildMenu != None )
	{
		// Reset Menu Movement in preparation for return to this menu
		ResetMenu();
	
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}
	return true;
}
function DrawMenu (canvas Canvas)
{
	// Patch change - A lot of the stuff has been removed simply because it caused graphical gliches.
	local int	i,x,MinX;
	local int	spacing,StartY;
	
	MenuStart(Canvas);
	
	DrawBackgroundARight(Canvas);

	TextMenuRight(Canvas);
	
	DrawTitle(Canvas);
	
	
	TextMenuLeftSelections(Canvas);

	MenuEnd(Canvas);
}

defaultproperties
{
     MenuSelectSound=Sound'JazzSounds.Interface.menuhit'
     MenuEnterSound=Sound'JazzSounds.Interface.menuhit'
     MenuModifySound=Sound'JazzSounds.Interface.menuhit'
     MenuLength=4
     MenuList(0)="RESTART LEVEL"
     MenuList(1)="LOAD GAME"
     MenuList(2)="NEW GAME"
     MenuList(3)="QUIT"
     MenuTitle="GAME OVER"
}
