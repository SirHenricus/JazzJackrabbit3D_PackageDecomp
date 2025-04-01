//=============================================================================
// TreasureHuntScoreBoard.
//=============================================================================
class TreasureHuntScoreBoard expands JazzScoreBoard;

var float 		Gems[17];
var string		Names[17];
var byte		NumPlayers;


// update scores
function UpdateScores()
{
	local THPlayerReplicationInfo THP;
	local THPlayerReplicationInfo Scoring[16];
	local int i;

	NumPlayers = 0;

	// get a sorted list of the top 16 players
	foreach AllActors(class'THPlayerReplicationInfo', THP)
	{
		if(NumPlayers < 16)
		{
			Scoring[NumPlayers] = THP;
			NumPlayers++;
		}
	}

	for ( i=0; i<16; i++ )
	{
		if ( i < NumPlayers )
		{
			Names[i] = Scoring[i].PlayerName;
			
			Gems[i] = Scoring[i].GemNumber;
		}
		else
		{
			Names[i] = "";
		}
	}
}


// UpdateNext - server returns next update, and a new request offset
function UpdateNext(string CurrentName, int offset, PlayerPawn requester)
{
	UpdateScores();
}


function ShowScores( canvas Canvas )
{
	local int i, num, max, Min, Sec, PSec;
	local float Temp;

	local float BoxX,BoxY;
	local string Line1,Line2;

	UpdateScores();

	max = int(0.03725 * Canvas.ClipY);
	
	// Display it
	SmallFont(Canvas);
	
	BoxX = 5;
	BoxY = Canvas.SizeY*0.05;
	MiscObjectDisplay(Canvas,BoxX,BoxY,NumPlayers,0.25);

	// Display Name/Gems
	for ( I=0; I<NumPlayers; I++ )
	{
		MiscObjectDispIn(Canvas,BoxX,BoxY,i,None,
			Names[i]," Gems "$Digits(Gems[i],3));
	}
}

defaultproperties
{
}
