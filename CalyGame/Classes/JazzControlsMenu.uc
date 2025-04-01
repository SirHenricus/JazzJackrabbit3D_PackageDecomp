//=============================================================================
// JazzControlsMenu.
//=============================================================================
class JazzControlsMenu expands JazzMenu;

var		int		MenuRightSide;

// Joystick Variable
var	  bool bJoystick;

// Name of the camera types
var() localized string CameraName[3];

// Targeting Icons
var   int TargetIconSel;
var() int    TargetIconNum;
var() texture  TargetIcons[6];

var bool bFirst;

// Find the current Crosshair target
function DetermineCurrentTargetIcon()
{
	local int x;

	if (JazzPlayer(PlayerOwner).TargetIcon==None)
	TargetIconSel=0;
	else
	{	// Search for Current Target Icon
		for (x=0; x<TargetIconNum; x++)
		if (TargetIcons[x]==JazzPlayer(PlayerOwner).TargetIcon)
		TargetIconSel=x;
	}
}

// Currently assume initial values are defaults
//
function PostBeginPlay()
{
	ResetMenu();
	
	// Detects if joystick in use	
	bJoystick =	bool(PlayerOwner.ConsoleCommand("get windrv.windowsclient usejoystick"));
	JazzPlayer(PlayerOwner).bUseJoystick = bJoystick;
	
	bFirst = true;
}

function ResetMenu()
{
	// Plays sounds as menus move across the screen
	MenuSoundNum = 0;
	MenuExistTime = 0;
}

function bool ProcessLeft()
{
	if ( Selection == 2 )
	{
		JazzPlayer(PlayerOwner).MouseSensitivity-=1;
		if (JazzPlayer(PlayerOwner).MouseSensitivity<1)
			JazzPlayer(PlayerOwner).MouseSensitivity=15;
	}
	/*else
	if (Selection == 3)
	{
		JazzPlayer(PlayerOwner).MouseStiffness-=0.1;
		if (JazzPlayer(PlayerOwner).MouseStiffness<0.1)
			JazzPlayer(PlayerOwner).MouseStiffness=1;
	}*/
	if (Selection == 3)
	{
		TargetIconSel--;
		if (TargetIconSel<0) TargetIconSel=TargetIconNum-1;
	}
}
	
function bool ProcessRight()
{
	if ( Selection == 2 )
	{
		JazzPlayer(PlayerOwner).MouseSensitivity+=1;
		if (JazzPlayer(PlayerOwner).MouseSensitivity>15)
			JazzPlayer(PlayerOwner).MouseSensitivity=1;
	}
	/*else
	if (Selection == 3)
	{
		JazzPlayer(PlayerOwner).MouseStiffness+=0.1;
		if (JazzPlayer(PlayerOwner).MouseStiffness>1)
			JazzPlayer(PlayerOwner).MouseStiffness=0.1;
	}*/
	else
	if (Selection == 3)
	{
		TargetIconSel++;
		if (TargetIconSel>=TargetIconNum) TargetIconSel=0;
	}
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
	
	if ( Selection == 1 )
	{
		bJoystick = !bJoystick;
		PlayerOwner.ConsoleCommand("set windrv.windowsclient usejoystick "$int(bJoystick));
		JazzPlayer(PlayerOwner).bUseJoystick = bJoystick;
	}
	else
	if (Selection == 2)
	{
		JazzPlayer(PlayerOwner).MouseSensitivity+=1;
		if (JazzPlayer(PlayerOwner).MouseSensitivity>15)
			JazzPlayer(PlayerOwner).MouseSensitivity=1;
	}
	else
	//if (Selection == 3)
	//{ JazzPlayer(PlayerOwner).NextCameraType(); }
	if (Selection == 3)
	{ TargetIconSel++; if (TargetIconSel>=TargetIconNum) TargetIconSel=0; }
	else
	if (Selection == 4)
	{ ChildMenu = spawn(class'JazzKeyMoveMenu', owner); }
	else
	if (Selection == 5)
	{ ChildMenu = spawn(class'JazzKeyboard2Menu', owner); }//HUD(Owner).GameHud = !HUD(Owner).GameHud; }
	else
	if (Selection == 6)
	{ ExitMenu(); return(false); }
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
	
	// Find out what targeting icon we're currently using
	if (bFirst)
	{
		DetermineCurrentTargetIcon();
		bFirst = false;
	}
	
	MenuStart(Canvas);
	
	DrawBackgroundARight(Canvas);

	TextMenuRight(Canvas);
	
	DrawTitle(Canvas);
	
	// Joystick Used
	if (bJoystick)
	MenuSelections[0]="ENABLED";
	else
	MenuSelections[0]="DISABLED";

	// Mouse Sensitivity
	MenuSelections[1]=string(int(JazzPlayer(PlayerOwner).MouseSensitivity));
	
	// Mouse Stiffness
	//MenuSelections[2]=string(int(JazzPlayer(PlayerOwner).MouseStiffness*10));

	// Camera Name
	//MenuSelections[3]=CameraName[JazzPlayer(PlayerOwner).CameraInUse];
	
	// HUD Toggling
	/*if (HUD(Owner).GameHud)
	MenuSelections[5]="VISIBLE";
	else
	MenuSelections[5]="INVISIBLE";*/
	
	// Targeting Icon
	StartY = Canvas.SizeY*0.1;
	Spacing = Canvas.SizeY*0.095;
	if (Spacing<23) Spacing = 23;
	Canvas.SetPos(Canvas.SizeX*0.15,StartY+Spacing*2);
	Canvas.Style = 2;
	Canvas.DrawIcon(TargetIcons[TargetIconSel],1);
	
	JazzPlayer(PlayerOwner).Targeting.Texture = TargetIcons[TargetIconSel];
	JazzPlayer(PlayerOwner).TargetIcon = TargetIcons[TargetIconSel];
	
	TextMenuLeftSelections(Canvas);

	MenuEnd(Canvas);

}

// Background
//
//function DrawBackGround(canvas Canvas)
//{
//}

defaultproperties
{
     TargetIconNum=5
     TargetIcons(0)=Texture'JazzArt.Interface.target1'
     TargetIcons(1)=Texture'JazzArt.Interface.target2'
     TargetIcons(2)=Texture'JazzArt.Interface.target3'
     TargetIcons(3)=Texture'JazzArt.Interface.target4'
     MenuSelectSound=Sound'JazzSounds.Interface.menuhit'
     MenuEnterSound=Sound'JazzSounds.Interface.menuhit'
     MenuModifySound=Sound'JazzSounds.Interface.menuhit'
     MenuLength=6
     MenuList(0)="JOYSTICK"
     MenuList(1)="MOUSE SPEED"
     MenuList(2)="TARGET"
     MenuList(3)="MOVEMENT CONTROLS"
     MenuList(4)="ACTION CONTROLS"
     MenuList(5)="BACK"
     MenuTitle="CONTROLS"
     Menutype=5.000000
}
