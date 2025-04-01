//=============================================================================
// JazzFish.
//=============================================================================
class JazzFish expands JazzPawnAI;

var vector PreLoc;
var vector HitNor,HitLoc;
var vector avoid;
var vector sloc;
var bool bavoid;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	
	LoopAnim(AnimSequence,AnimRate);
}

auto state Life
{
	Begin:
	SetPhysics(PHYS_Swimming);
	FriendTarget = None;
	AfraidTarget = None;
	
	Sloc = Location;
	
	MoveTimer = 1;
	avoid = vect(0,0,0);
	bavoid = false;
	
	GotoState('Decision');
}

event ZoneChange( ZoneInfo NewZone )
{
	local rotator newRotation;
	
	// log("Zonechange");
	
	if (NewZone.bWaterZone)
	{
		if ( !Region.Zone.bWaterZone && (Physics != PHYS_Swimming) )
		{
			newRotation = Rotation;
			newRotation.Roll = 0;
			SetRotation(newRotation);
		}
		SetPhysics(PHYS_Swimming);
	}
	else
	{
		avoid = Destination;
		bavoid = true;
		//GotoState('ReturnToWater');
		SetPhysics(PHYS_Falling);
	}
}

// Override to stop the fish from jumping off of eachother
singular event BaseChange()
{
	// do nothing
	SetBase(Level);
}

// Override bump so the fish don't jump off of eachother
function Bump( actor Other )
{
	// do nothing
}

/////////////////////////////////////////////////////////////////////////////////////
// DECISION 															STATES
/////////////////////////////////////////////////////////////////////////////////////
//
state Decision
{
	// Choose an action when there's nothing to do.
	//

	Begin:

	//Sleep(1);		// Originally here to avoid infinite Decision loop
	GotoState('Wander','Random');
}


/////////////////////////////////////////////////////////////////////////////////
// Wander - Swim around aimlessly									STATES
/////////////////////////////////////////////////////////////////////////////////
//
state Wander
{

    event HitWall( vector HitNormal, actor HitWall )
    {
    	// move away from wall
    	Destination = Location + (( Destination dot HitNormal ) * HitNormal * (-2.0));
    	
    	// log("The Fish has hit a wall");
    	
    	GotoState('wander','followrandom');
    }
    
	Begin:
	
	Random:

		if(bavoid)
		{
			Destination = Sloc;
		}
		else
		{
			hitloc.x = 1;
			hitloc.y = frand()*50-25;
			hitloc.z = frand()*10-5;
			
			hitloc = hitloc >> rotation;
			
			Destination = Location + ((vector(rotation)/vsize(vector(rotation))*hitloc)*Frand()*30);
			
			Trace(Destination,HitNor,Destination,Location,false);			
		}
		

		PreLoc = Location;
		
	FollowRandom:
	
		/*
		if ( !Region.Zone.bWaterZone)
		{
			avoid = Destination;
			bavoid = true;
			GotoState('ReturnToWater');
		}
		*/	
	
		 MoveTo(Destination,WalkingSpeed);
		//StrafeTo(Destination,Destination);
		
		if(VSize(Destination-Location) > 10)
		{
			Goto('FollowRandom');
		}
		else
		{
			bAvoid = false;
		}
		
		GotoState('Decision');
	
}

defaultproperties
{
     WalkingSpeed=50.000000
     RushSpeed=50.000000
     VoicePack=None
     GroundSpeed=50.000000
     WaterSpeed=50.000000
     bIsKillGoal=False
     bNetOptional=True
     Physics=PHYS_Swimming
     AnimSequence=fish1anim
     AnimRate=2.000000
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.Jfish1_01'
     Mesh=LodMesh'JazzObjectoids.fish1'
     bMeshCurvy=True
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bBlockActors=False
     bBlockPlayers=False
     bProjTarget=False
     bRotateToDesired=False
     RotationRate=(Pitch=500,Yaw=20000,Roll=200)
}
