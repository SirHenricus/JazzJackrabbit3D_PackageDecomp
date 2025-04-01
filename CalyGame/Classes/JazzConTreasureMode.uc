//=============================================================================
// JazzConTreasureMode.
//=============================================================================
class JazzConTreasureMode expands JazzConMenu;

function bool ProcessLeft()
{
	switch (Selection)
	{
	case 1:
		if (BattleMode(GameType).TimeLimit>1)
		BattleMode(GameType).TimeLimit-=1;
	break;
	
	case 3:
		if (BattleMode(GameType).MaxPlayers>1)
		BattleMode(GameType).MaxPlayers--;
	break;
	
	case 4:
		if (BattleMode(GameType).InitialBots>0)
		BattleMode(GameType).InitialBots--;
	break;
	}
	
	return true;
} 

function bool ProcessRight()
{
	switch (Selection)
	{
	case 1:
		if (BattleMode(GameType).TimeLimit<60)
		BattleMode(GameType).TimeLimit+=1;
	break;
	
	case 3:
		if (BattleMode(GameType).MaxPlayers<32)
		BattleMode(GameType).MaxPlayers++;
	break;
	
	case 4:
		if (BattleMode(GameType).InitialBots<32)
		BattleMode(GameType).InitialBots++;
	break;
	}
	
	return true;
}

function DrawMenu (canvas Canvas)
{
	local BattleMode DMGame;

	DMGame = BattleMode(GameType);

	MenuStart(Canvas);
	
	DrawBackgroundA(Canvas);

	TextMenuLeft(Canvas);
	
	MenuSelections[0] = string(DMGame.TimeLimit)$" MIN";
	MenuSelections[1] = "Normal";
	MenuSelections[2] = string(DMGame.MaxPlayers);
	MenuSelections[3] = string(DMGame.InitialBots);
	
	TextMenuSelections(Canvas);
	
	Canvas.DrawColor = Canvas.Default.DrawColor;
	
	MenuEnd(Canvas);
}

defaultproperties
{
     GameClass=Class'CalyGame.TreasureHunt'
     MenuLength=5
}
