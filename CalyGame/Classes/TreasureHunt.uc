//=============================================================================
// TreasureHunt.
//=============================================================================
class TreasureHunt expands BattleMode;

var float GameTime;

var int NumberOfPlayers;

var int RemainingTime;
var	bool bGameEnded;

/*
event Tick(float DeltaTime)
{
	GameTime += DeltaTime;
}
*/

function SpawnTreasure(vector Location, pawn OldActor, int Number, int Type)
{
	local HuntGem Gem;
	local JazzCoin Coin;
	local vector Vel;
	local int x;	
	
	for(x = 0; x < Number; x++)
	{
		switch(Type)
		{
			case 0:
				// Gem 1
				Gem = Spawn(class'HuntGem',,,Location);
		
				Vel.X = (FRand()*1000)-500;
				Vel.Y = (FRand()*1000)-500;
		
				Vel.Z = (FRand()*500)+250;
		
				Gem.Velocity = Vel;
		
				Gem.SetPhysics(PHYS_Falling);				
				
			break;
			case 1:
				// Gem 2
				Gem = Spawn(class'HuntGemGreen',,,Location);
				
				Vel.X = (FRand()*1000)-500;
				Vel.Y = (FRand()*1000)-500;
		
				Vel.Z = (FRand()*500)+250;
		
				Gem.Velocity = Vel;
		
				Gem.SetPhysics(PHYS_Falling);								
				
			break;
			case 2:
				// Gem 3
				Gem = Spawn(class'HuntGemRed',,,Location);
				
				Vel.X = (FRand()*1000)-500;
				Vel.Y = (FRand()*1000)-500;
		
				Vel.Z = (FRand()*500)+250;
		
				Gem.Velocity = Vel;
		
				Gem.SetPhysics(PHYS_Falling);
				
			break;
			case 3:
				// Gold Coin
				Coin = Spawn(class'JazzCoin',,,Location);
				
				Vel.X = (FRand()*1000)-500;
				Vel.Y = (FRand()*1000)-500;
		
				Vel.Z = (FRand()*500)+250;
		
				Coin.Velocity = Vel;
		
				Coin.SetPhysics(PHYS_Falling);				
				
			break;
			case 4:
				// Red Coin
				Coin = Spawn(class'JazzCoin5',,,Location);
				
				Vel.X = (FRand()*1000)-500;
				Vel.Y = (FRand()*1000)-500;
		
				Vel.Z = (FRand()*500)+250;
		
				Coin.Velocity = Vel;
		
				Coin.SetPhysics(PHYS_Falling);				
				
			break;
			case 5:
				// Blue Coin
				Coin = Spawn(class'JazzCoin10',,,Location);
				
				Vel.X = (FRand()*1000)-500;
				Vel.Y = (FRand()*1000)-500;
		
				Vel.Z = (FRand()*500)+250;
		
				Coin.Velocity = Vel;
		
				Coin.SetPhysics(PHYS_Falling);				

			break;												
			default:
			break;
		}
	}
}

function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	if ( injured.bIsPlayer )
	{
		// log(injured $ " is losing gems");
		if(THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber > 0)
		{
			if(Damage >= 75 && THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber >= 700)
			{
				SpawnTreasure(injured.Location, injured, 7, 1);
				THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber -= 5;
			}
			else if(Damage >= 50 && THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber >= 400)
			{
				SpawnTreasure(injured.Location, injured, 5, 1);
				THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber -= 5;
			}
			else if (Damage >= 25 && THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber >= 200)
			{
				SpawnTreasure(injured.Location, injured, 3, 1);
				THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber -= 3;				
			}
			else if(THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber >= 10)
			{
				SpawnTreasure(injured.Location, injured, 10, 3);
				THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber -= 10;				
			}
			else
			{
				SpawnTreasure(injured.Location, injured, THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber, 3);
				THPlayerReplicationInfo(injured.PlayerReplicationInfo).GemNumber = 0;
			}
		}
		return 0;
	}
	else
	{
		return Super.ReduceDamage(Damage, DamageType, injured, instigatedBy);
	}
}

event playerpawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<playerpawn> SpawnClass
)
{
	local PlayerPawn      NewPlayer;

	NewPlayer =  Super.Login(Portal, Options, Error, SpawnClass);
	
	if ( NewPlayer != None )
	{
		NumberOfPlayers++;
		NewPlayer.PlayerReplicationInfo = Spawn(class'THPlayerReplicationInfo',NewPlayer);
		NewPlayer.InitPlayerReplicationInfo();
		
		JazzHUD(NewPlayer.MyHUD).LevelTime = TimeLimit*60;
	}
	else
	Log("TreasureHuntGame) No Player Was Created");
	
	return NewPlayer;
}

function bool AddBot()
{
	local NavigationPoint StartSpot;
	local JazzThinker NewBot;
	local int BotN;

	// log("JazzBotInfo: Getting New Bot");
	BotN = BotConfig.ChooseBotInfo();
	
	// Find a start spot.
	StartSpot = FindPlayerStart(NewBot,0);
	if( StartSpot == None )
	{
		log("Could not find starting spot for Bot");
		return false;
	}

	// Try to spawn the player.
	// log("JazzBotInfo: Spawning New Bot");
	NewBot = Spawn(BotConfig.GetBotClass(BotN),,,StartSpot.Location,StartSpot.Rotation);
	
	if ( NewBot == None )
		return false;

	if ( (bHumansOnly || Level.bHumansOnly) && !NewBot.bIsHuman )
	{
		NewBot.Destroy();
		log("Failed to spawn bot");
		return false;
	}
	
	NewBot.PlayerReplicationInfo = Spawn(class'THPlayerReplicationInfo',NewBot);
	NewBot.InitPlayerReplicationInfo();	

	StartSpot.PlayTeleportEffect(NewBot, true);

	// Init player's information.
	BotConfig.Individualize(NewBot, BotN, NumBots);
	NewBot.ViewRotation = StartSpot.Rotation;

	// broadcast a welcome message.
	BroadcastMessage( NewBot.PlayerReplicationInfo.PlayerName$EnteredMessage, true );

	AddDefaultInventory( NewBot );
	NumBots++;
	return true;
}

function Logout(pawn Exiting)
{
	Super.Logout(Exiting);
	if ( Exiting.IsA('PlayerPawn') )
	{
		NumberOfPlayers--;
	}
}

// Copied over from DeathMatch Game Info
function EndGame(string Reason)
{
	local actor A;
	local pawn aPawn;

	Super.EndGame(Reason);

	bGameEnded = true;
	aPawn = Level.PawnList;
	
	RemainingTime = -1; // use timer to force restart
	
	while( aPawn != None )
	{
		if ( aPawn.IsA('Bots') )
			aPawn.GotoState('GameEnded');
		aPawn = aPawn.NextPawn;
	}
}

function Timer()
{
	Super.Timer();

	/*
	if ( (RemainingBots > 0) && AddBot() )
		RemainingBots--;
	*/
	
	if ( bGameEnded )
	{
		RemainingTime--;
			
		if ( RemainingTime < -7 )
			RestartGame();
	}
}

//
// Called when pawn has a chance to pick Item up (i.e. when 
// the pawn touches a weapon pickup). Should return true if 
// he wants to pick it up, false if he does not want it.
//
function bool PickupQuery( Pawn Other, Inventory item )
{
	// JazzPawnAI Check
	if ( JazzPawnAI(Other) != None)
		{
		//Log("JazzPawnAICheck) "$JazzPawnAI(Other).CanPickupItems);
		return (JazzPawnAI(Other).CanPickupItems);
		}

	if ( Other.Inventory == None )
		return true;
//	if ( bCoopWeaponMode && item.IsA('Weapon') && !Weapon(item).bHeldItem && (Other.FindInventoryType(item.class) != None) )
//		return false;
	else
		return !Other.Inventory.HandlePickupQuery(Item);
}

defaultproperties
{
     bRestartLevel=False
     bPauseable=False
     ScoreBoardType=Class'CalyGame.TreasureHuntScoreBoard'
     GameMenuType=Class'CalyGame.JazzConTreasureMode'
     HUDType=Class'CalyGame.JazzTreasureHuntHUD'
     BeaconName="BattleMode"
}
