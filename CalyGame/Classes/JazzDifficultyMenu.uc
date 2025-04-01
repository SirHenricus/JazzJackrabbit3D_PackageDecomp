//=============================================================================
// JazzDifficultyMenu.
//=============================================================================
class JazzDifficultyMenu expands JazzMenu;

var		int		MenuRightSide;
var string	ClassString;
var string	PreferredSkin;
var string	StartMap;

var() localized string 	PlayerClasses[8];
var() localized string 	PlayerSkins[8];

// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	ResetMenu();
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
	
	if ((Selection == 1) || (Selection == 2) || (Selection == 3) || (Selection == 4))
	{
		//bExitAllMenus = true;
		
		if (Selection == 1) // Easy
		{ Level.Game.Difficulty = 0; }
		else
		if (Selection == 2) // Medium
		{ Level.Game.Difficulty = 1; }
		else
		if (Selection == 3) // Hard
		{ Level.Game.Difficulty = 2; }
		else
		if (Selection == 4) // Turbo
		{ Level.Game.Difficulty = 3; }
		
		Level.Game.SaveConfig();
		SaveConfigs();
	
		ClassString = PlayerClasses[0];
		PreferredSkin = PlayerSkins[0];
		
		StartMap = StartMap
		$"?Class="$ClassString
		$"?Game=CalyGame.JazzSinglePlayer"
		$"?Skin="$PreferredSkin
		$"?Name="$PlayerOwner.PlayerReplicationInfo.PlayerName		
		$"?Team="$PlayerOwner.PlayerReplicationInfo.TeamName;
		//$"?Rate="$PlayerOwner.NetSpeed;

		Log("StartMap) "$StartMap);
		
		PlayerOwner.ClientTravel("jvillage.unr", TRAVEL_Absolute, false);
		return true;
	}
	else
	if (Selection == 5)
	{ ExitMenu(); }
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
	local int	i,x,MinX;
	local int	spacing,StartY;

	// Globals	
	MenuStart(Canvas);
	
	DrawBackGroundARight(Canvas);
	
	DrawTitle(Canvas);		// 220 Version
	
	TextMenuRight ( Canvas );

	// Globals	
	MenuEnd(Canvas);
}

// Background
//
//function DrawBackGround(canvas Canvas)
//{
//}

defaultproperties
{
     MenuLength=5
     MenuList(0)="EASY"
     MenuList(1)="MEDIUM"
     MenuList(2)="HARD"
     MenuList(3)="TURBO"
     MenuList(4)="BACK"
     MenuTitle="SELECT DIFFICULTY"
     Menutype=9.000000
}
