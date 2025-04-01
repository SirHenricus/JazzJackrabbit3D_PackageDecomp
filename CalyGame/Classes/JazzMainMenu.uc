//=============================================================================
// JazzMainMenu.
//=============================================================================
class JazzMainMenu expands JazzMenu;


///////////////// THIS IS THE REAL PAUSE MENU ///////////////////////

// Determines what map starts a new game.
//
// This is hardcoded right now until we have the capability to edit the C code.
//
var string StartMap;


function bool ProcessSelection()
{
	local Menu ChildMenu;

	ChildMenu = None;
	if ( ! bBegun )
	{
		PlayEnterSound();
		bBegun = true;
	}

	if ( Selection == 1 )
	{
		// Patch Change - Game Type screen has been replaced with the difficulty screen now.
		// This is only temporary due to the battle mode being quite incomplete.
		//ChildMenu = spawn(class'JazzNewGameMenu', owner);
		
		//ChildMenu = spawn(class'JazzDifficultyMenu', owner);
		ChildMenu = spawn(class'JazzNewGameMenu', owner);
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
		JazzCharacterSelectMenu(ChildMenu).StartMap = StartMap;
	}
	else
	if ( (Selection == 2 ) && (Level.NetMode == NM_Standalone)
		&& !Level.Game.IsA('BattleMode') )
		ChildMenu = spawn(class'JazzSaveMenu', owner);
	else if ( Selection == 3 )
		ChildMenu = spawn(class'JazzLoadMenu', owner);
	else if ( Selection == 4 )
		ChildMenu = spawn(class'JazzSettingsMenu', owner);
	else
		ChildMenu = spawn(class'JazzQuitMenu', owner);

	if ( ChildMenu != None )
	{
		// Reset Menu Movement in preparation for return to this menu
		PostBeginPlay();
	
		HUD(Owner).MainMenu = ChildMenu;
		ChildMenu.ParentMenu = self;
		ChildMenu.PlayerOwner = PlayerOwner;
	}
	return true;
}

function DrawMenu (canvas Canvas)
{
	local int	i,x,y,MinX;
	local int	spacing,StartY;
	
	MenuStart(Canvas);
	
	DrawBackgroundA(Canvas);

	TextMenuLeft(Canvas);

	// Draw Jazz Graphic
	// 
	y = (Canvas.ClipY - MenuExistTime*100);
	if (y<Canvas.ClipY-80)
		y = Canvas.ClipY-80;
	Canvas.Style = 3;
	Canvas.SetPos(Canvas.SizeX-120,y);
	//Canvas.DrawIcon(Texture'JazzTitle3',0.25);	// Jazz3 Texture
	
	MenuEnd(Canvas);
}

defaultproperties
{
     MenuSelectSound=Sound'JazzSounds.Weapons.shot1'
     MenuModifySound=Sound'JazzSounds.Weapons.shot1'
     SwooshMenuInSound=Sound'JazzSounds.Interface.menuhit'
     MenuLength=5
     MenuList(0)="GAME"
     MenuList(1)="OPTIONS"
     MenuList(2)="AUDIO/VIDEO"
     MenuList(3)="QUIT"
     MenuTitle="PAUSED"
     LeftSide=True
}
