//=============================================================================
// JazzAdvancedTrigger.
//=============================================================================
class JazzAdvancedTrigger expands Trigger;

var() sound TriggerSound;
var() sound UnTriggerSound;


// Broadcast Trigger
//
function BroadcastTrigger( actor Other, Pawn OtherB )
{
	local actor A;

	// Play Triggered Sound	
	PlaySound(TriggerSound);
	
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Other, OtherB );
}

// Broadcast Untrigger
//
function BroadcastUnTrigger( actor Other, Pawn OtherB )
{
	local actor A;
	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.UnTrigger( Other, OtherB );
}

//
// Called when something touches the trigger.
//
function Touch( actor Other )
{
	if( IsRelevant( Other ) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		BroadcastTrigger(Other,Other.Instigator);

		if ( Other.IsA('Pawn') && (Pawn(Other).SpecialGoal == self) )
			Pawn(Other).SpecialGoal = None;
				
		if( Message != "" )
			// Send a string message to the toucher.
			Other.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
		else if ( RepeatTriggerTime > 0 )
			SetTimer(RepeatTriggerTime, false);
	}
}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, name damageType)
{
	if ( bInitiallyActive && (TriggerType == TT_Shoot) && (Damage >= DamageThreshold) && (instigatedBy != None) )
	{
		if ( ReTriggerDelay > 0 )
		{
			if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
				return;
			TriggerTime = Level.TimeSeconds;
		}
		// Broadcast the Trigger message to all matching actors.
		BroadcastTrigger(instigatedBy,instigatedBy);

		if( Message != "" )
			// Send a string message to the toucher.
			instigatedBy.Instigator.ClientMessage( Message );

		if( bTriggerOnceOnly )
			// Ignore future touches.
			SetCollision(False);
	}
}

//
// When something untouches the trigger.
//
function UnTouch( actor Other )
{
	if( IsRelevant( Other ) )
	{
		// Untrigger all matching actors.
		BroadcastUnTrigger(Other,Other.Instigator);
	}
}

defaultproperties
{
}
