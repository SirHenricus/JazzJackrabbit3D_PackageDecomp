//=============================================================================
// JazzIntroHUD.
//=============================================================================
class JazzIntroHUD expands HUD;

var() float HUDExistTime;
var() float HUDAnimTime;

var() 	string	Introductions[20];			// Credits-style text
var() 	int			IntroductionNum;
var     float		Scale; // Patch change - Scale is now a global variable because we want cool looking stuff to happen with it!
var     float		TitleY; // Patch change - a new variable used to move the title around the screen... because it's awesome!
var		float		TitleX; // Patch change - same as above... doh.
var		float		ScreenYMid; // Patch change - this is used to find the middle Y position of the screen... Cheap, but fun stuff!
var		float		ScreenXMid; // Patch change - Same as above... again, doh.

var 	DummySelectedChar		ChSelDummy; // Patch change - this is used for the character selection screen.

//////////////////////////////////////////////////////////////////////////////////////////////////
// HUD Initialization														INITIALIZE
//////////////////////////////////////////////////////////////////////////////////////////////////
// Initialize our Hud interface and go from there.
//
// We'll want to set the interface window defauls.
//
//
function PostBeginPlay()
{
	// DEMO Text
	//ScreenMessage("JAZZ 3 DEMO V4",10);
	Owner.PlaySound(sound'welcome');
}
function BeginPlay()
{
	local vector newloc;
	local rotator newrot;
	
	// Yeah I know, it's kinda hacky, but hey, it works!
	newloc.X = -288;
	newloc.Y = 1200;
	newloc.Z = -56;
	Newrot.Roll = 0;
	Newrot.Yaw = -40;
	Newrot.Pitch = 0;
	
	// Let's create the fake character dummy on the treadmill!
	ChSelDummy = Spawn(class'DummySelectedChar',self);
	ChSelDummy.SetOwner(self);
	ChSelDummy.SetLocation(newloc);
	ChSelDummy.SetRotation(Newrot);
	
	PlayerOwner.ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$int(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume")));
}
// PreRender calls to other associated inventory displays
//
function PreRender ( canvas Canvas )
{
	Super.PreRender(Canvas);
}

simulated function ChangeCrosshair(int d)
{
	// Unused for JazzHUD
}

// New Menu Desired
//
simulated function CreateMenu()
{
	if ( PlayerPawn(Owner).bSpecialMenu && (PlayerPawn(Owner).SpecialMenu != None) )
	{
		MainMenu = Spawn(PlayerPawn(Owner).SpecialMenu, self);
		PlayerPawn(Owner).bSpecialMenu = false;
		MainMenu.SetOwner(Self); // Patch change - Just... don't even ask.
	}
	
	if ( MainMenu == None )
		MainMenu = Spawn(MainMenuType, self);
		MainMenu.SetOwner(Self); // Patch change
		
	if ( MainMenu == None )
	{
		PlayerPawn(Owner).bShowMenu = false;
		Level.bPlayersOnly = false;
		return;
	}
	else
	{
		MainMenu.PlayerOwner = PlayerPawn(Owner);
		MainMenu.PlayEnterSound();
	}
}

// System which displays the credit text and handles events associated with the HUD time which affect the credits
//
function DisplayCredits ( canvas Canvas )
{
	local int		CreditNum;
	local float		CreditTime;
	local bool		LocationLeft;
	local int		Brightness;
	local float		X,Y;
	
	CreditNum = HUDExistTime / 4;				// Duration of each credit display
	CreditTime = HUDExistTime - CreditNum*4;	// Current display time
	
	CreditNum = CreditNum % (IntroductionNum+2);
	
	//Edited - the title will always stay in place. Also, the other 2d title in the map file is removed now.
	//if (CreditNum<2)
	//{
		// Title Screen
		//if (Canvas.SizeX<513)
		//Scale=0.5;
		//else
		
		//Scale=1;
		
		//if (CreditNum==1)
		//{
			//if (CreditTime>1)
			//Scale = Scale * (1-((CreditTime-1)/3));
		//}
		
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
		
		Canvas.bNoSmooth = true;
		Canvas.Style = 1;
		Canvas.SetPos(TitleX+Canvas.SizeX/2-256*Scale+2,TitleY+Canvas.SizeY/2-256*Scale+2+20);
		Canvas.DrawIcon(texture'title1',Scale);
		Canvas.SetPos(TitleX+Canvas.SizeX/2,TitleY+Canvas.SizeY/2-256*Scale+2+20);
		Canvas.DrawIcon(texture'title2',Scale);
		Canvas.SetPos(TitleX+Canvas.SizeX/2-256*Scale+2,TitleY+Canvas.SizeY/2+20);
		Canvas.DrawIcon(texture'title3',Scale);
		Canvas.SetPos(TitleX+Canvas.SizeX/2,TitleY+Canvas.SizeY/2+20);
		Canvas.DrawIcon(texture'title4',Scale);
		Canvas.Style = 3;
		Canvas.SetPos(TitleX+Canvas.SizeX/2-80*Scale,TitleY+Canvas.SizeY/2-110*Scale);
		Canvas.DrawIcon(texture'jj3titlesmoke',Scale);
		Canvas.bNoSmooth = false;
		
		ScreenYMid = Canvas.SizeY*0.5;
	//}
	//else
	//{
		// Location alternates left/right
		
		// Patch change - only sorta. this is my old code - it was used to show the credits even when the menu is open.
		// It was a bit out of place since I intend to actually use different parts of the map for representing different menus.
		/*if ( PlayerPawn(Owner).bShowMenu != True )
		{ LocationLeft = (CreditNum % 2)==0; }
		else
		{
			if ( MainMenu.LeftSide == True )
			{ LocationLeft = False; }
			else
			{ LocationLeft = True; }
		}*/
		
		
		Brightness = 255*(1-abs(CreditTime-2)/2);
		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = Brightness;
		Canvas.DrawColor.B = Brightness/2;
		
		if (Canvas.SizeX>600)
		Canvas.Font = font'DLFont';
		else
		Canvas.Font = font'DSFont';
		
		Canvas.Style = 3;
		
		if (LocationLeft)
		{ Canvas.SetPos(Canvas.SizeX*0.1,Canvas.SizeY*0.6); }
		else
		{
			Canvas.StrLen(Caps(Introductions[CreditNum]),X,Y);
			Canvas.SetPos(Canvas.SizeX*0.95-X,Canvas.SizeY*0.6);
		}
		Canvas.DrawText( Caps(Introductions[CreditNum]) );
		
		// Patch change - a "Press Continue" type of text at the bottom of the screen
		if ( !PlayerPawn(Owner).bShowMenu ) // We also want this to disappear once the menu has appeared!
		{
			Canvas.DrawColor.R = 0;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 50;
			Canvas.SetPos(Canvas.SizeX*0.5-150,Canvas.SizeY-50);
			Canvas.DrawText( "PRESS ESCAPE" );
		}
	//}
}

// Draw the HUD
// 
simulated function PostRender( canvas Canvas )
{
	// Credits display
	//
	DisplayCredits( Canvas );

	//HUDSetup(canvas);

	if ( PlayerPawn(Owner) != None )
	{
		// Player Menu Entering
		//
		if ( PlayerPawn(Owner).bShowMenu )
		{
			HUDExistTime = 0;
		
			if ( MainMenu == None )
				CreateMenu();
			if ( MainMenu != None )
				MainMenu.DrawMenu(Canvas);
			return;
		}
		
		// Player Score Display
		//
		if ( PlayerPawn(Owner).bShowScores )
		{
			if ( (PlayerPawn(Owner).Scoring == None) && (PlayerPawn(Owner).ScoringType != None) )
				PlayerPawn(Owner).Scoring = Spawn(PlayerPawn(Owner).ScoringType, PlayerPawn(Owner));
			if ( PlayerPawn(Owner).Scoring != None )
			{ 
				PlayerPawn(Owner).Scoring.ShowScores(Canvas);
				return;
			}
		}
		else if ( (PlayerPawn(Owner).Weapon != None) && (Level.LevelAction == LEVACT_None) )
			DrawCrossHair(Canvas, 0.5 * Canvas.ClipX - 8, 0.5 * Canvas.ClipY - 8);

		// Prepare HUD coordinates for displaying actors
		ReadyDisplayMesh(Canvas,Canvas.SizeX * 0.9,Canvas.SizeY * 0.4, 0.5);
			
		// Player Progress Message
		//
		//if ( PlayerPawn(Owner).ProgressTimeOut > Level.TimeSeconds )
			//DisplayProgressMessage(Canvas);	
	}
	
	// Draw HUD Type based on HUDStyle variable
	//
	/*switch (HUDStyle)
	{
	case HUDKinetic:
		// Dancing Carrot at top-right
		ProcessComponent(0,Canvas.SizeX+50,0,Canvas.SizeX-40,40);	// Component 0 - Carrots / Money
		DancingCarrot	(Canvas,ComponentX,ComponentY);
		ProcessComponent(1,Canvas.SizeX+10,-50,Canvas.SizeX-40,4);
		DancingScore	(Canvas,ComponentX,ComponentY);
		DancingMessage	(Canvas,Canvas.SizeX/2,Canvas.SizeY/2);
		
		ProcessComponent(2,-50,-50,1,1);	// Component 2 - Health
		HeartHealthBar	(Canvas,ComponentX,ComponentY,JazzPlayer(Owner).Health,5);
		break;
	}*/
	
	// Update Subsystem Drawing
	//UpdateInventoryDisplay( Canvas );
	
	// Update Subsystem Drawing
	//UpdateConversationDisplay( Canvas );
	
	DrawJazzIcon( Canvas );
	
}

function DrawJazzIcon( canvas Canvas )
{
	local float y;

	y = (Canvas.ClipY - HUDExistTime*100);
	if (y<Canvas.ClipY-60)
		y = Canvas.ClipY-60;
	Canvas.Style = 3;
	Canvas.SetPos(Canvas.ClipX-120,y);
	//Canvas.DrawIcon(Texture'JazzTitle3',0.25);		// Jazz3 Texture
}


// Patch Change - the Tick event is updated so it does some cool stuff with the title screen!
event Tick ( float DeltaTime )
{
	Local vector NewTargetLocation;
	local vector NewCameraLocation;
	local vector RoamAnimationLoc;
	local float RoamAmount;
	
	RoamAmount = 10;
	HUDExistTime += DeltaTime;
	HUDAnimTime += DeltaTime;
	
	// Make the PlayerPawn completely non-solid
	JazzPlayer(Owner).bBlockActors = False;
	JazzPlayer(Owner).bBlockPlayers = False;
	JazzPlayer(Owner).bCollideWorld = False;
	JazzPlayer(Owner).SetCollisionSize( 0, 0 );
	
	JazzPlayer(Owner).ExternalCameraOverride.bBlockActors = False;
	JazzPlayer(Owner).ExternalCameraOverride.bBlockPlayers = False;
	JazzPlayer(Owner).ExternalCameraOverride.bCollideWorld = False;
	JazzPlayer(Owner).ExternalCameraOverride.SetCollisionSize( 0, 0 );
	
	// Set new locations;
	NewTargetLocation = PlayerPawn(Owner).Location; // Set the new Target location (It's actually the player)
	NewCameraLocation = JazzPlayer(Owner).ExternalCameraOverride.Location; // Set the new Camera location!	
	
	// Menu types:
	// 0 - Main view to the ruins
	// 1 - Options Menu (View to the Cogs)
	// 2 - Multiplayer/Other game modes (View to the swords)
	// 3 - Save / Load (Close up to the ruins)
	// 4 - Key settings (View to the sky)
	// 5 - Controls Options menu (View to the Atari joystick)
	// 6 - Audio Options menu (View to the trumpets)
	// 7 - Graphics Options menu (View to the Monitor)
	// 8 - Exit (View to the sky)
	// 9 - Single Player Campagin (View to the ruins, but this time - lower)
	// 10 - Battle mode character select (The treadmill running Jazz is back!!!)
	if ( PlayerPawn(Owner).bShowMenu )
	{
		if ( (MainMenu.Menutype != 3) && (MainMenu.Menutype != 4) && (MainMenu.Menutype != 8) )
		{			
			if ( MainMenu.LeftSide == True )
			{ TitleX += ( (ScreenXMid)*0.25+256*Scale - TitleX ) * DeltaTime * 2.5; }
			else
			{ TitleX += ( -(ScreenXMid)*0.25-256*Scale - TitleX ) * DeltaTime * 2.5; }
			
			TitleY += ( -(ScreenYMid)+256*Scale - TitleY ) * DeltaTime * 2;
			Scale += (0.5-Scale) * DeltaTime * 2;
		}
		else
		{
			TitleX -= TitleX * DeltaTime * 2;
			TitleY -= TitleY * DeltaTime * 2;
			Scale += (0.1-Scale) * DeltaTime * 2;
		}
		
		
		if ( MainMenu.Menutype == 1 ) // Settings
		{
			if  ( MainMenu.Selection == 4 ) // Graphics
			{
				NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*1.03)-20 - NewCameraLocation.X ) * DeltaTime * 2;
				NewCameraLocation.Y += ( (sin(HUDAnimTime)*RoamAmount)+2110 - NewCameraLocation.Y ) * DeltaTime * 2;
				NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-40 - NewCameraLocation.Z ) * DeltaTime * 2;
				NewTargetLocation.X += (200 - NewTargetLocation.X) * DeltaTime*1.8;
				NewTargetLocation.Y += (2110 - NewTargetLocation.Y) * DeltaTime*1.8;
				NewTargetLocation.Z += (-10 - NewTargetLocation.Z) * DeltaTime*1.8;
			}
			else if  ( MainMenu.Selection == 3 ) // Audio
			{
				NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*1.03)-20 - NewCameraLocation.X ) * DeltaTime * 2;
				NewCameraLocation.Y += ( (sin(HUDAnimTime)*RoamAmount)+1710 - NewCameraLocation.Y ) * DeltaTime * 2;
				NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-40 - NewCameraLocation.Z ) * DeltaTime * 2;
				NewTargetLocation.X += (200 - NewTargetLocation.X) * DeltaTime*1.8;
				NewTargetLocation.Y += (1710 - NewTargetLocation.Y) * DeltaTime*1.8;
				NewTargetLocation.Z += (-10 - NewTargetLocation.Z) * DeltaTime*1.8;
			}
			else if  ( MainMenu.Selection == 2 ) // Controls
			{
				NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*1.03)-20 - NewCameraLocation.X ) * DeltaTime * 2;
				NewCameraLocation.Y += ( (sin(HUDAnimTime)*RoamAmount)+1310 - NewCameraLocation.Y ) * DeltaTime * 2;
				NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-40 - NewCameraLocation.Z ) * DeltaTime * 2;
				NewTargetLocation.X += (200 - NewTargetLocation.X) * DeltaTime*1.8;
				NewTargetLocation.Y += (1310 - NewTargetLocation.Y) * DeltaTime*1.8;
				NewTargetLocation.Z += (-10 - NewTargetLocation.Z) * DeltaTime*1.8;
			}
			else // Advanced/Back
			{
				NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*1.03)-20 - NewCameraLocation.X ) * DeltaTime * 2;
				NewCameraLocation.Y += ( (sin(HUDAnimTime)*RoamAmount)+930 - NewCameraLocation.Y ) * DeltaTime * 2;
				NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-40 - NewCameraLocation.Z ) * DeltaTime * 2;
				NewTargetLocation.X += (200 - NewTargetLocation.X) * DeltaTime*1.8;
				NewTargetLocation.Y += (930 - NewTargetLocation.Y) * DeltaTime*1.8;
				NewTargetLocation.Z += (-10 - NewTargetLocation.Z) * DeltaTime*1.8;
			}
		}
		else if ( MainMenu.Menutype == 2 ) // Multiplayer and Other game modes besides the Campagin
		{
			NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*1.03)+20 - NewCameraLocation.X ) * DeltaTime;
			NewCameraLocation.Y += ( (sin(HUDAnimTime)*RoamAmount)+930 - NewCameraLocation.Y ) * DeltaTime;
			NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-40 - NewCameraLocation.Z ) * DeltaTime;
		
		
			NewTargetLocation.X += (-200 - NewTargetLocation.X) * DeltaTime * 2;
			NewTargetLocation.Y += (930 - NewTargetLocation.Y) * DeltaTime * 2;
			NewTargetLocation.Z += (-10 - NewTargetLocation.Z) * DeltaTime * 2;
		}
		else if ( MainMenu.Menutype == 3 ) // Save / Load
		{
			NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*0.25) - NewCameraLocation.X ) * DeltaTime;
			NewCameraLocation.Y += ( 500 - NewCameraLocation.Y ) * DeltaTime;
			NewCameraLocation.Z += ( (sin(HUDAnimTime)*RoamAmount*0.25)-20 - NewCameraLocation.Z ) * DeltaTime;

		
			NewTargetLocation.X -= NewTargetLocation.X * DeltaTime * 2;
			NewTargetLocation.Y += (400 - NewTargetLocation.Y) * DeltaTime * 2;
			NewTargetLocation.Z += (-40 - NewTargetLocation.Z) * DeltaTime * 2;
		}
		else if ( MainMenu.Menutype == 4 ) // Key settings (Key binds)
		{
			NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*1.03)-20 - NewCameraLocation.X ) * DeltaTime;
			NewCameraLocation.Y += ( (sin(HUDAnimTime)*RoamAmount)+1310 - NewCameraLocation.Y ) * DeltaTime;
			NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)+10 - NewCameraLocation.Z ) * DeltaTime;
			
			
			NewTargetLocation.X += (100 - NewTargetLocation.X) * DeltaTime * 2;
			NewTargetLocation.Y += (1310 - NewTargetLocation.Y) * DeltaTime * 2;
			NewTargetLocation.Z += (100 - NewTargetLocation.Z) * DeltaTime * 2;
		}
		else if ( MainMenu.Menutype == 5 ) // Controls menu
		{
			NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*1.03)-20 - NewCameraLocation.X ) * DeltaTime * 2;
			NewCameraLocation.Y += ( (sin(HUDAnimTime)*RoamAmount)+1310 - NewCameraLocation.Y ) * DeltaTime * 2;
			NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-40 - NewCameraLocation.Z ) * DeltaTime * 2;
		
		
			NewTargetLocation.X += (200 - NewTargetLocation.X) * DeltaTime*1.8;
			NewTargetLocation.Y += (1310 - NewTargetLocation.Y) * DeltaTime*1.8;
			NewTargetLocation.Z += (-10 - NewTargetLocation.Z) * DeltaTime*1.8;
		}
		else if ( MainMenu.Menutype == 6 ) // Audio menu
		{
			NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*1.03)-20 - NewCameraLocation.X ) * DeltaTime * 2;
			NewCameraLocation.Y += ( (sin(HUDAnimTime)*RoamAmount)+1710 - NewCameraLocation.Y ) * DeltaTime * 2;
			NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-40 - NewCameraLocation.Z ) * DeltaTime * 2;
		
		
			NewTargetLocation.X += (200 - NewTargetLocation.X) * DeltaTime*1.8;
			NewTargetLocation.Y += (1710 - NewTargetLocation.Y) * DeltaTime*1.8;
			NewTargetLocation.Z += (-10 - NewTargetLocation.Z) * DeltaTime*1.8;
		}
		else if ( MainMenu.Menutype == 7 ) // Graphics menu
		{
			NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*1.03)-20 - NewCameraLocation.X ) * DeltaTime * 2;
			NewCameraLocation.Y += ( (sin(HUDAnimTime)*RoamAmount)+2110 - NewCameraLocation.Y ) * DeltaTime * 2;
			NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-40 - NewCameraLocation.Z ) * DeltaTime * 2;
		
		
			NewTargetLocation.X += (200 - NewTargetLocation.X) * DeltaTime*1.8;
			NewTargetLocation.Y += (2110 - NewTargetLocation.Y) * DeltaTime*1.8;
			NewTargetLocation.Z += (-10 - NewTargetLocation.Z) * DeltaTime*1.8;
		}
		else if ( MainMenu.Menutype == 8 ) // Quit game menu
		{
			NewCameraLocation.X += ( sin(HUDAnimTime)*RoamAmount*0.5 - NewCameraLocation.X ) * DeltaTime*0.5;
			NewCameraLocation.Y += ( (cos(HUDAnimTime)*RoamAmount*0.5)+800 - NewCameraLocation.Y ) * DeltaTime*0.5;
			NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*0.5)+80 - NewCameraLocation.Z ) * DeltaTime*0.5;
		
		
			NewTargetLocation.X -= NewTargetLocation.X * DeltaTime*0.5;
			NewTargetLocation.Y += (700 - NewTargetLocation.Y) * DeltaTime*0.5;
			NewTargetLocation.Z += (300 - NewTargetLocation.Z) * DeltaTime*0.5;
		}
		else if ( MainMenu.Menutype == 9 ) // Single Player Campagin menu
		{
			NewCameraLocation.X += ( sin(HUDAnimTime)*RoamAmount - NewCameraLocation.X ) * DeltaTime;
			NewCameraLocation.Y += ( (cos(HUDAnimTime)*RoamAmount*1.03)+750 - NewCameraLocation.Y ) * DeltaTime;
			NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-150 - NewCameraLocation.Z ) * DeltaTime;


			NewTargetLocation.X -= NewTargetLocation.X * DeltaTime;
			NewTargetLocation.Y += (650 - NewTargetLocation.Y) * DeltaTime;
			NewTargetLocation.Z += ( -150 - NewTargetLocation.Z) * DeltaTime;
		}
		else if ( MainMenu.Menutype == 10 ) // Battle mode character select
		{
			NewCameraLocation.X += ( (cos(HUDAnimTime)*RoamAmount*1.03)-90 - NewCameraLocation.X ) * DeltaTime;
			NewCameraLocation.Y += ( (sin(HUDAnimTime)*RoamAmount)+1240 - NewCameraLocation.Y ) * DeltaTime;
			NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-55 - NewCameraLocation.Z ) * DeltaTime;
		
		
			NewTargetLocation.X += (-200 - NewTargetLocation.X) * DeltaTime * 2;
			NewTargetLocation.Y += (1240 - NewTargetLocation.Y) * DeltaTime * 2;
			NewTargetLocation.Z += (-35 - NewTargetLocation.Z) * DeltaTime * 2;
		}
		else // Else if something is wrong - 0 value is default anyway.
		{
			NewCameraLocation.X += ( sin(HUDAnimTime)*RoamAmount - NewCameraLocation.X ) * DeltaTime;
			NewCameraLocation.Y += ( (cos(HUDAnimTime)*RoamAmount*1.03)+800 - NewCameraLocation.Y ) * DeltaTime;
			NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-20 - NewCameraLocation.Z ) * DeltaTime;
	
		
			NewTargetLocation.X -= NewTargetLocation.X * DeltaTime * 2;
			NewTargetLocation.Y += (700 - NewTargetLocation.Y) * DeltaTime * 2;
			NewTargetLocation.Z += ( -20 - NewTargetLocation.Z) * DeltaTime * 2;
		}
	}
	else // This stuff happens when the menu is not open
	{
		NewCameraLocation.X += ( sin(HUDAnimTime)*RoamAmount - NewCameraLocation.X ) * DeltaTime;
		NewCameraLocation.Y += ( (cos(HUDAnimTime)*RoamAmount*1.03)+800 - NewCameraLocation.Y ) * DeltaTime;
		NewCameraLocation.Z += ( (cos(HUDAnimTime)*RoamAmount*1.09)-20 - NewCameraLocation.Z ) * DeltaTime;

	
		NewTargetLocation.X -= NewTargetLocation.X * DeltaTime * 2;
		NewTargetLocation.Y += (700 - NewTargetLocation.Y) * DeltaTime * 2;
		NewTargetLocation.Z += ( -20 - NewTargetLocation.Z) * DeltaTime;
			
		TitleX -= TitleX * DeltaTime * 2;
		TitleY -= TitleY * DeltaTime * 2;
		Scale += (1-Scale) * DeltaTime * 2;
	}
	
	// The roaming animation is now here instead of the camera actor.
	// This was done due to many reasons, coding stuff, don't need to explain in detail.
	// This has been hard-coded in though. Remember this - I love making games, but I am not a great programmer.
	// At least I think I'm not...
	/*RoamAnimationLoc = vect(0,0,1)*sin(HUDExistTime)*RoamAmount + 
				vect(1,0,0)*cos(HUDExistTime)*RoamAmount*1.03 +
				vect(0,1,0)*sin(HUDExistTime)*RoamAmount*1.09;*/

	
	PlayerPawn(Owner).setlocation(NewTargetLocation);
	JazzPlayer(Owner).ExternalCameraOverride.SetLocation(NewCameraLocation);
}


function bool InterceptButton ()
{
	// Return true if button is intercepted
	
	// Bring up menu
	PlayerPawn(Owner).ShowMenu();
	
	return (true);
}


function ReadyDisplayMesh( canvas Canvas, float XPos, float YPos, float Scale, optional float YawAdd )
{
	local float XRatio,YRatio;
	local vector DrawOffset,DrawLoc;
	local rotator DrawRot,NewRot;

	XRatio = float(Canvas.SizeX)/float(Canvas.SizeY);
	YRatio = float(Canvas.SizeY)/float(Canvas.SizeX);

	XPos = ((XPos-Canvas.SizeX/2)/float(Canvas.SizeX))*2;
	YPos = ((YPos-Canvas.SizeY/2)/float(Canvas.SizeY))*2;

	// Conversion from screen coordinates (1:1 screen ratio based)
	//
	XPos =  XPos*XRatio*3.75;
	YPos = -YPos*YRatio*4.5;
	
	//Log("DrawMesh) X"$XPos$" Y"$YPos$" XR"$XRatio$" YR"$YRatio);
	
	DrawOffset.X = 5;
	DrawOffset.Y = XPos;
	DrawOffset.Z = YPos;
	
	DrawRot = JazzPlayer(Owner).MyCameraRotation;
	DrawOffset = (DrawOffset >> JazzPlayer(Owner).MyCameraRotation);
	DrawLoc = JazzPlayer(Owner).MyCameraLocation /*+ Pawn(Owner).EyeHeight * vect(0,0,1)*/;

	SetLocation(DrawLoc + DrawOffset);
	NewRot = DrawRot;
	NewRot.Yaw += YawAdd;
	NewRot.Pitch = 0;
	SetRotation(NewRot);
}

defaultproperties
{
     Introductions(0)="JJ3E Patch"
     Introductions(1)="JazzGruff"
     Introductions(2)="Jazz 3 Ver 013d"
     Introductions(3)="Do Not Distribute"
     Introductions(4)="Programming"
     Introductions(5)="Jason Emery"
     Introductions(6)="Devon Tackett"
     Introductions(7)="Artwork"
     Introductions(8)="Dean Dodrill"
     Introductions(9)="Christian Bradley"
     Introductions(10)="Modeling"
     Introductions(11)="David Carter"
     Introductions(12)="Will Sweat"
     Introductions(13)="Level Design"
     Introductions(14)="Dean Dodrill"
     Introductions(15)="Jason Emery"
     Introductions(16)="Anton Wiegert"
     Introductions(17)="John Falgate"
     Introductions(18)="Music"
     Introductions(19)="Alexander Brandon"
     IntroductionNum=20
     MainMenuType=Class'CalyGame.JazzIntroMenu'
}
