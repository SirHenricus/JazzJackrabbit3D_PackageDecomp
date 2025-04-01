//=============================================================================
// JazzVideoMenu.
//=============================================================================
class JazzVideoMenu expands JazzMenu;

var float	brightness;
var string 	CurrentRes;
var string 	AvailableRes;
var string 	MenuValues[20];
var string 	Resolutions[48];
var int 	resNum;
var float 	TextureDetail;

var localized string TxtRoaming;
var localized string TxtFixed;
var localized string TxtLow;
var localized string TxtMid;
var localized string TxtHigh;

function PostBeginPlay()
{	
	if (bool(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.ViewportManager LowDetailTextures")))
	{ TextureDetail = 1; }
	else if (bool(PlayerOwner.ConsoleCommand("get ini:Engine.Engine.ViewportManager MediumDetailTextures")))
	{ TextureDetail = 2; }
	else
	{ TextureDetail = 3; }
}

function GetInformation()
{
	if ( CurrentRes == "" )
		GetAvailableRes();
	else if ( AvailableRes == "" )
		GetAvailableRes();
}


function GetAvailableRes()
{
	local int p,i;
	local string ParseString;

	AvailableRes = PlayerOwner.ConsoleCommand("GetRes");
	resNum = 0;
	ParseString = AvailableRes;
	p = InStr(ParseString, " ");
	while ( (ResNum < ArrayCount(Resolutions)) && (p != -1) ) 
	{
		Resolutions[ResNum] = Left(ParseString, p);
		ParseString = Right(ParseString, Len(ParseString) - p - 1);
		p = InStr(ParseString, " ");
		ResNum++;
	}

	Resolutions[ResNum] = ParseString;
	for ( i=ResNum+1; i< ArrayCount(Resolutions); i++ )
		Resolutions[i] = "";

	CurrentRes = PlayerOwner.ConsoleCommand("GetCurrentRes");
	MenuValues[1] = CurrentRes;
	for ( i=0; i< ResNum+1; i++ )
		if ( MenuValues[1] ~= Resolutions[i] )
		{
			ResNum = i;
			return;
		}

	ResNum = 0;
	MenuValues[1] = Resolutions[0];
}

function bool ProcessLeft()
{
	if ( Selection == 1 )
	{
		Brightness = FMax(0.0, Brightness - 0.1);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$Brightness);
		PlayerOwner.ConsoleCommand("FLUSH");
		return true;
	}
	else if ( Selection == 2 )
	{
		ResNum--;
		if ( ResNum < 0 )
		{
			ResNum = ArrayCount(Resolutions) - 1;
			While ( Resolutions[ResNum] == "" )
				ResNum--;
		}
		MenuValues[1] = Resolutions[ResNum];
		return true;
	}	
	else if ( Selection == 3 )
	{
		if (TextureDetail > 1)
		{ TextureDetail -= 1; }
		else
		{ TextureDetail = 1; }
		
		if (TextureDetail == 1)
		{ PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail Low"); }
		else if (TextureDetail == 2)
		{ PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail Medium"); }
		else if (TextureDetail == 3)
		{ PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail High"); }
		/*bLowTextureDetail = !bLowTextureDetail;
		if (bLowTextureDetail)
			PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail Medium");
		else
			PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail High");*/
		return true;
	}
/*	else if ( Selection == 8 )
	{
		if (JazzPlayer(PlayerOwner).KevinCameraAvailable)
		JazzPlayer(PlayerOwner).UseKevinCamera = !JazzPlayer(PlayerOwner).UseKevinCamera;
		return true;
	}*/

	return false;
}

function bool ProcessRight()
{
	if ( Selection == 1 )
	{
		Brightness = FMin(1, Brightness + 0.1);
		PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$Brightness);
		PlayerOwner.ConsoleCommand("FLUSH");
		return true;
	}
	else if ( Selection == 2 )
	{
		ResNum++;
		if ( (ResNum >= ArrayCount(Resolutions)) || (Resolutions[ResNum] == "") )
			ResNum = 0;
		MenuValues[1] = Resolutions[ResNum];
		return true;
	}	
	else if ( Selection == 3 )
	{
		if (TextureDetail < 3)
		{ TextureDetail += 1; }
		else
		{ TextureDetail = 3; }
		
		if (TextureDetail == 1)
		{ PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail Low"); }
		else if (TextureDetail == 2)
		{ PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail Medium"); }
		else if (TextureDetail == 3)
		{ PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail High"); }
		
		/*bLowTextureDetail = !bLowTextureDetail;
		if (bLowTextureDetail)
			PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail Medium");
		else
			PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail High");*/
		return true;
	}
/*	else if ( Selection == 8 )
	{
		if (JazzPlayer(PlayerOwner).KevinCameraAvailable)
		JazzPlayer(PlayerOwner).UseKevinCamera = !JazzPlayer(PlayerOwner).UseKevinCamera;
		return true;
	}*/

	return false;
}		

function bool ProcessSelection()
{
	if ( Selection == 4 )
	{
		PlayerOwner.ConsoleCommand("TOGGLEFULLSCREEN");
		CurrentRes = PlayerOwner.ConsoleCommand("GetCurrentRes");
		GetAvailableRes();
		return true;
	}
	else if ( Selection == 2 )
	{
		PlayerOwner.ConsoleCommand("SetRes "$MenuValues[1]);
		CurrentRes = PlayerOwner.ConsoleCommand("GetCurrentRes");
		GetAvailableRes();
		return true;
	}
	/*else if ( Selection == 3 )
	{
		if (TextureDetail < 4)
		{ TextureDetail += 1; }
		else
		{ TextureDetail = 3; }
		
		if (TextureDetail == 1)
		{ PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail Low"); }
		else if (TextureDetail == 2)
		{ PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail Medium"); }
		else if (TextureDetail == 3)
		{ PlayerOwner.ConsoleCommand("set ini:Engine.Engine.ViewportManager TextureDetail High"); }
	}*/
	else if ( Selection == 5 )
	{
		ExitMenu();
	}
		
	return false;
}

function DrawMenu (canvas Canvas)
{
	GetInformation();

	MenuStart(Canvas);
	
	DrawBackgroundARight(Canvas);

	DrawTitle(Canvas);

	TextMenuRight(Canvas);
	
	MenuEnd(Canvas);
}

// General function to return a string based on an integer with the correct # of digits (0s on front)
//
function string Digits ( int Value, int Digit )
{
	local string S;
	
	S = string(Value);

	if (InStr(S,"-")>=0)
	{
	S = Mid(S,1,9999);
	while (Len(S)<Digit-1)	S = "0"$S;
	S = "-"$S;
	}
	else
	while (Len(S)<Digit)	S = "0"$S;
	
	return S;
}

// Text Menu Draw Routines
//
function TextMenuRight ( canvas Canvas )
{
	local float spacing,StartY;
	local int i,x,y;
	local float MenuRightSide;
	local string TempS;
	
	MenuRightSide = Canvas.SizeX;
	
	StartY = Canvas.SizeY*0.1;
	Spacing = Canvas.SizeY*0.095;
	if (Spacing<19) Spacing = 19;
	
	FontMenu(Canvas);
	
	for (i=0; i<MenuLength; i++)
	{
		SetFontBrightness(Canvas, (i == Selection - 1) );
		x = (MenuExistTime*500)-200-(i*40);
		if (x>20) x=20;
		
		// Check if menu across x threshold point to make a sound
		if ((x>-50) && (MenuSoundNum<i+1))
		{
			PlayerOwner.PlaySound(SwooshMenuInSound);
			MenuSoundNum = i+1;
		}
		
		// Menu is ready once all motion done
		if ((x>=20) && (i>=MenuLength-1))
			bMenuReadyForInput = true;
		
		DancingTextRight(Canvas, MenuRightSide-x, StartY + Spacing * i, MenuList[i],i);
		
		Canvas.SetPos(MenuRightSide-x-Canvas.SizeX*0.8,StartY+Spacing*i);
		
		switch (i)
		{
		case 0: // Brightness
			DancingText(Canvas, Digits(Brightness*100,1)$"%", i);
			break;
			
		case 1: // Resolution
			if ( MenuValues[1] ~= CurrentRes )
				DancingText(Canvas,"["$Caps(MenuValues[1])$"]");
			else
				DancingText(Canvas," "$Caps(MenuValues[1]));
			break;

		case 2: // Texture Detail
			if (TextureDetail == 1)			
			{ DancingText(Canvas, "LOW", i); }
			else if (TextureDetail == 2)			
			{ DancingText(Canvas, "MEDIUM", i); }
			else if (TextureDetail == 3)			
			{ DancingText(Canvas, "HIGH", i); }
			break;
			
/*		case 4: // Music Volume
			DancingText(Canvas, Digits(MusicVol*100/255,1)$"%", i);
			break;
			
		case 5: // Sound Volume
			DancingText(Canvas, Digits(SoundVol*100/255,1)$"%", i);
			break;
			
		case 6: // Sound Quality
			if (bLowSoundQuality)
			DancingText(Canvas, TxtLow, i);
			else
			DancingText(Canvas, TxtHigh, i);
			break;*/
			
/*		case 7: // Camera Style
			if (JazzPlayer(PlayerOwner).UseKevinCamera)
			DancingText(Canvas, TxtRoaming, i);
			else
			DancingText(Canvas, TxtFixed, i);
			break;*/
		}
	}
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
}

defaultproperties
{
     MenuSelectSound=Sound'JazzSounds.Weapons.shot1'
     MenuModifySound=Sound'JazzSounds.Weapons.shot1'
     MenuLength=5
     MenuList(0)="BRIGHTNESS"
     MenuList(1)="TOGGLE FULLSCREEN MODE"
     MenuList(2)="RESOLUTION"
     MenuList(3)="TEXTURE DETAIL"
     MenuList(4)="MUSIC VOLUME"
     MenuList(5)="SOUND VOLUME"
     MenuList(6)="SOUND QUALITY"
     MenuList(7)="CAMERA"
     MenuTitle="VIDEO"
     Menutype=7.000000
}
