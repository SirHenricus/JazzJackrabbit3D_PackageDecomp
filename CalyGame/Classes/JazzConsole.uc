//=============================================================================
// JazzConsole.
//=============================================================================
class JazzConsole expands Console;

var JWindowMain JWindows;
var bool		bMessage;

var bool		bJWindowTyping;
var string JTyped;

// Called by the engine when a single key is typed.
event bool KeyType( EInputKey Key );

// Called by the engine when a key, mouse, or joystick button is pressed
// or released, or any analog axis movement is processed.
event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
{
	if( Action!=IST_Press )
	{
		return false;
	}
	else if( Key==IK_Tilde )
	{
		if( ConsoleDest==0.0 )
		{
			ConsoleDest=0.3;
			GotoState('Typing');
		}
		else GotoState('');
		return true;
	}
	else if( Key == IK_F5 )
	{
		GotoState('JWindow');
		return true;
	}
	else return false;
}

state JWindow
{
	event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		switch(Action)
		{
			case IST_Axis:
				// The only axis movement should be the mouse
				switch(Key)
				{
					case IK_MouseX:
						JWindows.MouseInput(Delta, 0);
						return true;
					break;
					case IK_MouseY:
						JWindows.MouseInput(0, Delta);
						return true;
					break;
					default:
					break;
				}
			break;
			case IST_Press:
				switch(Key)
				{
					case IK_F5:
						// Currently used to get in and out of windowing system
						GotoState('');
						return true;
					break;
					case IK_LeftMouse:
						JWindows.MouseButton(true,false);
						return true;
					break;
					case IK_RightMouse:
						JWindows.MouseButton(false,false);
						return true;
					break;
					default:
					break;
				}
			break;
			case IST_Release:
				switch(Key)
				{
					case IK_LeftMouse:
						JWindows.MouseButton(true,true);
						return true;
					break;
					case IK_RightMouse:
						JWindows.MouseButton(false,true);
						return true;
					break;
					default:
					break;
				}
			break;
			case IST_Hold:
			break;
			case IST_None:
			break;
		}
		return false;
	}
	
	event PostRender(canvas C)
	{
		Super.PostRender(C);
		
		DrawWindow(C);
	}
	
	function EndState()
	{
		/*
		if(JWindows != None)
		{
			JWindows.ShutDown();
		}
		
		JWindows = None;
		*/
	}
}

state JWindowTyping
{
	function bool KeyType( EInputKey Key )
	{
		if( Key>=0x20 && Key<0x80)
		{
			JTyped = JTyped $ Chr(Key);
			return true;
		}
	}
	
	event bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local string Temp;	
		if( global.KeyEvent( Key, Action, Delta ) || Action!=IST_Press )
		{
			return true;
		}	
		else if( Key==IK_Escape )
		{
			if( JTyped!="" )
			{
				JTyped="";
			}
			else
			{
				GotoState( 'JWindow' );
			}
		}
		else if( Key==IK_Enter )
		{
			if( JTyped!="" )
			{
				// Make a local copy of the string.
				Temp=JTyped;
				JTyped="";
			}
			GotoState('JWindow');
		}
		else if( Key==IK_Backspace || Key==IK_Left )
		{
			if( Len(JTyped)>0 )
				JTyped = Left(JTyped,Len(JTyped)-1);
		}
		else
		{
			switch(Action)
			{
				case IST_Axis:
					// The only axis movement should be the mouse
					switch(Key)
					{
						case IK_MouseX:
							JWindows.MouseInput(Delta, 0);
							return true;
						break;
						case IK_MouseY:
							JWindows.MouseInput(0, Delta);
							return true;
						break;
						default:
						break;
					}
				break;
				case IST_Press:
					switch(Key)
					{
						case IK_F5:
							// Currently used to get in and out of windowing system
							GotoState('');
							return true;
						break;
						case IK_LeftMouse:
							GotoState('JWindow');;
							return true;
						break;
						case IK_RightMouse:
							GotoState('JWindow');
							return true;
						break;
						default:
						break;
					}
				break;
				case IST_Release:
					switch(Key)
					{
						case IK_LeftMouse:
							GotoState('JWindow');
							return true;
						break;
						case IK_RightMouse:
							GotoState('JWindow');
							return true;
						break;
						default:
						break;
					}
				break;
				case IST_Hold:
				break;
				case IST_None:
				break;
			}
		}
		return true;
	}
	
	event PostRender(canvas C)
	{
		Super.PostRender(C);
		
		DrawWindow(C);
	}
	
	function BeginState()
	{
		bJWindowTyping = true;
	}
	
	function EndState()
	{
		bJWindowTyping = false;
		
		/*
		if(JWindows != None)
		{
			JWindows.ShutDown();
		}
		
		JWindows = None;
		*/
	}
}

function CreateWindows(canvas C)
{
	JWindows = New class'JWindowMain';
	JWindows.StartUp(self, C);
}

function DrawWindow( canvas C)
{
	if(JWindows == None)
	{
		CreateWindows(C);
	}
	
	JWindows.Draw(C);
}

// Called before rendering the world view.
event PreRender( canvas C )
{
	C.DrawColor.r = 50;
	C.DrawColor.g = 50;
	C.DrawColor.b = 50;
}

// Add localization to hardcoded strings!!
// Called after rendering the world view.
event PostRender( canvas C )
{
	// Patch change - Added "C.Style = 1;" when drawing the console window, so it is never transparent due to some sort of bug.
	local string BigMessage;
	local font LargeFont;
	local float XL, YL;
	local int YStart, YEnd, Y, I, J, Line, iLine;
	local float Scale;

	if(bNoDrawWorld)
	{
		C.Style = 1;
		C.SetPos(0,0);
		C.DrawPattern( Texture'Border', C.ClipX, C.ClipY, 1.0 );
	}

	if( bTimeDemo )
	{
		TimeDemoCalc();
		TimeDemoRender( C );
	}

	LargeFont = C.LargeFont;
	
	if (( Viewport.Actor.bShowMenu) || (JazzPlayer(Viewport.Actor).bShowTutorial ) || (JazzPlayer(Viewport.Actor).bShowPurchase))
		BigMessage = "";
	else if ( Viewport.Actor.Level.LevelAction == LEVACT_Saving )
		BigMessage = SavingMessage;
	else if ( Viewport.Actor.Level.LevelAction == LEVACT_Connecting )
		BigMessage = ConnectingMessage;
	else if ( Viewport.Actor.Level.Pauser != "" )
	{
		LargeFont = C.MedFont;
		BigMessage = PausedMessage; // Add pauser name?
	}
	
	bMessage = (BigMessage != "");
	if ( bMessage )
	{
		C.bCenter = false;
		C.Font = font'DLFont';
		C.StrLen( BigMessage, XL, YL );
		C.SetPos(FrameX/2 - XL/2, FrameY/2 - YL/2);
		C.DrawText( Caps(BigMessage), false );
	}

	if ( Viewport.Actor.Level.LevelAction == LEVACT_Loading )
	{
		// Display Loading 'screen'
		C.Style = 1;
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		if (C.SizeX<500)
		Scale = 0.5;
		else
		Scale = 1.0;
		
		C.bNoSmooth = true;
		C.SetPos(C.SizeX/2-256*Scale+1,C.SizeY/2-128*Scale);
		C.DrawIcon(texture'LoadingLeft',Scale);
		C.SetPos(C.SizeX/2,C.SizeY/2-128*Scale);
		C.DrawIcon(texture'LoadingRight',Scale);
		C.bNoSmooth = false;
		bMessage = true;
	}
	
	// If the console has changed since the previous frame, draw it.
	if ( ConsoleLines > 0 )
	{
		C.Style = 1;
		C.SetOrigin(0.0, ConsoleLines - FrameY*0.3);
		C.SetPos(0.0, 0.0);
		C.DrawTile( ConBackground, FrameX, FrameY*0.3, C.CurX, C.CurY - FrameY*0.3, FrameX, FrameY*0.3 );
	}

	// Draw border.
	YStart 	= BorderLines;
	YEnd 	= FrameY - BorderLines;
	if ( BorderLines > 0 || BorderPixels > 0 )
	{
		YStart += ConsoleLines;
		if ( BorderLines > 0 )
		{
			C.Style = 1;
			C.SetOrigin(0.0, 0.0);
			C.SetPos(0.0, 0.0);
			C.DrawPattern( Border, FrameX, BorderLines, 1.0 );
			C.SetPos(0.0, YEnd);
			C.DrawPattern( Border, FrameX, BorderLines, 1.0 );
		}
		if ( BorderPixels > 0 )
		{
			C.Style = 1;
			C.SetOrigin(0.0, 0.0);
			C.SetPos(0.0, YStart);
			C.DrawPattern( Border, BorderPixels, YEnd - YStart, 1.0 );
			C.SetPos( FrameX - BorderPixels, YStart );
			C.DrawPattern( Border, BorderPixels, YEnd - YStart, 1.0 );
		}
	}

	// Draw console text.
	C.SetOrigin(0.0, 0.0);
	if ( ConsoleLines > 0 )
	{
		DrawConsoleView( C );
	}
	else
	{
		DrawSingleView( C );
	}
}

defaultproperties
{
     ConBackground=Texture'JazzArt.Interface.ConsoleBack'
}
