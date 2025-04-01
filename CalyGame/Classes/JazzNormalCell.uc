//=============================================================================
// JazzNormalCell.
//=============================================================================
class JazzNormalCell expands JazzWeaponCell;

// Use this item.
//
var actor TransmuteObject;

//
// This is the 'normal' weapon for Jazz Jackrabbit to use.
//
// NOTE: This cell dies when the actor is killed.  It does not drop.  It should also only
// be added or found when starting a game, as it's actually (while not in code) the actual
// weapon.  It's merely broken into a cell to make coding a heckuva lot easier to support one
// cell type.  When a weapon is spawned, a weapon cell is also spawned and added to the
// inventory to reflect the weapon's firing capability.
//

var 	int		ShotCounter;


// Destroy item if it is to become a pickup item.
//
function DropFrom(vector StartLocation)
{
	Destroy();
}

///////////////////////////////////////////////////////////////////////////////////////
// Normal Fire : Weapon JackrabbitGun									FIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state FireStateJazz
{
	// Gizmo
	Missile:
	switch (CurrentPowerLevel)
	{

	// Blue Grenade
	// 	
	case 0:
		if (CheckAvailableAmmo(10)==false) CheckContinueFire();
		AimError = 0;
		ProjectileFire(class'JazzBlueGrenade', 400, true);
		AnimateWeapon(0);
		UseAmmo(10);
		
		MainFireDelay(0.4);		// Main Reload 0.2 seconds
		//Sleep(0.4);				// Weapon reload time
	break;

	}
	CheckContinueFire();	// Check if fire held down
	
	// Perform actual firing here
	Begin:

	switch (CurrentPowerLevel)
	{
	
	///////////////////////////
	// No Orb : Level 0
	//
	//
	//
	case 0:
		AimError = 500;

		//for (ShotCounter=0; ShotCounter<3; ShotCounter++)
		//{
			// Projectile JazzNormal / Speed 600 / Warns target
			if (CheckAvailableAmmo(2)==false) CheckContinueFire();
			ProjectileFire(class'JazzNormal', 600, true);
			AnimateWeapon(0);
			UseAmmo(2);
			//Sleep(0.1);
		//}
	
		MainFireDelay(0.2);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time
	break;


	///////////////////////////
	// No Orb : Level 1
	//
	//
	//
	case 1:
		AimError = 600;

		for (ShotCounter=0; ShotCounter<5; ShotCounter++)
		{
			// Projectile JazzNorma2 / Speed 700 / Warns target
			ProjectileFire(class'JazzNormal2', 700, true);
			AnimateWeapon(0);
			Sleep(0.09);
		}
	
		MainFireDelay(0.5);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time
	break;
	
	///////////////////////////
	// No Orb : Level 2
	//
	//
	//
	case 2:
		AimError = 700;

		for (ShotCounter=0; ShotCounter<7; ShotCounter++)
		{
			// Projectile JazzNorma2 / Speed 700 / Warns target
			ProjectileFire(class'JazzNormal3', 700, true);
			AnimateWeapon(0);
			Sleep(0.08);
		}
	
		MainFireDelay(0.5);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time
	break;
	
	///////////////////////////
	// No Orb : Level 3
	//
	//
	//
	case 3:
		AimError = 600;

		for (ShotCounter=0; ShotCounter<9; ShotCounter++)
		{
			// Projectile JazzNorma2 / Speed 700 / Warns target
			ProjectileFire(class'JazzNormal4', 700, true);
			AnimateWeapon(0);
			Sleep(0.07);
		}
	
		MainFireDelay(0.5);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time
	break;
	
	}
	
	CheckContinueFire();	// Check if fire held down
}

///////////////////////////////////////////////////////////////////////////////////////
// Alt Fire : Weapon JackrabbitGun										FIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state AltFireStateJazz
{
	// Trace to vector V and see if anything is in the way.
	//
	function bool VectorTrace( vector V )
	{
		local vector 	HitLocation,HitNormal;
		local actor 	Result;
		local bool		ActorFound;
		local float		NewDist;
		local float 	TraceDistance;
		local vector 	TraceLocation;
	
		Result = Trace( HitLocation, HitNormal,	V, Location );

		TraceDistance = VSize(HitLocation-Location);
		TraceLocation = HitLocation;

		// Return true if trace is not blocked.
	
		return(HitLocation == V);
	}

	function FindTransmuteObject()
	{
		local float Distance;
		local JazzObject O;
		local Inventory I;
	
		// Scan for nearby JazzObjects
		Distance = 15000;
		TransmuteObject = None;
		
		SetLocation(Owner.Location);
		foreach VisibleActors(class'JazzObject',O,15000)
		{
			if (O.DrawType!=DT_Sprite)
			if (VSize(Owner.Location-O.Location)<Distance)
			{
				TransmuteObject = O;
				Distance = VSize(Owner.Location-O.Location);
			}
		}

		if (I==None)
		foreach VisibleActors(class'Inventory',I,15000)
		{
			if (I.DrawType!=DT_Sprite)
			if (VSize(Owner.Location-I.Location)<Distance)
			{
				TransmuteObject = I;
				Distance = VSize(Owner.Location-I.Location);
			}
		}
	}
	
	// Level 1
	ChargeNormalA:
		StopChargeSound();
		AimError=0;
		ProjectileFire(class'JazzCharge1', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		UseAmmo(2);
		CheckContinueFire();
	
	ChargeNormalB:
		StopChargeSound();
		AimError=0;
		ProjectileFire(class'JazzCharge2', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		UseAmmo(10);
		CheckContinueFire();
		
	ChargeNormalC:
		StopChargeSound();
		AimError=0;
		ProjectileFire(class'JazzCharge3', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		UseAmmo(30);
		CheckContinueFire();
		
	// Level 2
	ChargeNormal2A:
		StopChargeSound();
		AimError=0;
		ProjectileFire(class'JazzCharge1B', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	ChargeNormal2B:
		StopChargeSound();
		AimError=0;
		ProjectileFire(class'JazzCharge2B', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	// Level 3
	ChargeNormal3A:
		StopChargeSound();
		AimError=0;
		ProjectileFire(class'JazzCharge1C', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	ChargeNormal3B:
		StopChargeSound();
		AimError=0;
		ProjectileFire(class'JazzCharge2C', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	// Level 4
	ChargeNormal4A:
		StopChargeSound();
		AimError=0;
		ProjectileFire(class'JazzCharge1D', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	
	ChargeNormal4B:
		StopChargeSound();
		AimError=0;
		ProjectileFire(class'JazzCharge2D', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();


	// Perform actual firing here
	Missile:
	switch (CurrentPowerLevel)
	{
	
	case 0:
		// Transmute Self
		//
		// Find an object somewhere in the vicinity and shimmer Jazz a bit, 
		// then turn him into that object.
		//
		
		if (CheckAvailableAmmo(10)==false) CheckContinueFire();
		// (1) Find nearby object visible to transmute to.
		FindTransmuteObject();

		// (2) Transmute player command
		if ((TransmuteObject!=None) && (TransmuteObject.Mesh!=None))
		{
			// Successful transmutation
			JazzPlayer(Owner).TransmuteToMesh(TransmuteObject.Mesh,TransmuteObject.Skin,TransmuteObject.AnimSequence,TransmuteObject.AnimFrame,10);
		}
		else
		{
			// Failed Transmutation - Nothing nearby to scan
			JazzPlayer(Owner).TransmuteToMesh(Owner.Mesh,Owner.Skin,Owner.AnimSequence,Owner.AnimFrame,-1);
		}

		AltFireDelay(1.0);	// Main reload 1.0 seconds
		UseAmmo(10);
	break;
	}
	CheckContinueFire();
	
	// Normal weapon
	// Perform actual firing here
	Begin:
	
	switch (CurrentPowerLevel)
	{
	
	///////////////////////////
	// No Orb : Level 0
	//
	case 0:
		if (CheckAvailableAmmo(2)==false) CheckContinueFire();
		//ChargeStart('ChargeNormalA',class'ChargeEffect1',true,0.0,1,0.05);
		ChargeStart('ChargeNormalA',class'JazzChargeEffect',true,3,1,20,10,20,0,0.2);
		Sleep(1);
		if (CheckAvailableAmmo(10)==false) Goto('ChargeNormalA');
		ChargeStart('ChargeNormalB',class'ChargeEffect1',true,10,2,25,20,40,0.2,0.4);
		Sleep(2);
		if (CheckAvailableAmmo(30)==false) Goto('ChargeNormalB');
		ChargeStart('ChargeNormalC',class'ChargeEffect1',true,10,20,35,40,40,0.4,0.6);
		Sleep(20);
		Goto('ChargeNormalB');
	break;

	///////////////////////////
	// No Orb : Level 1
	//
	case 1:
		ChargeStart('ChargeNormal2A',class'ChargeEffect1B',true,0.02,3,0.1);
		Sleep(3);
		ChargeStart('ChargeNormal2B',class'ChargeEffect1B',true,0.1);
		Sleep(20);
		Goto('ChargeNormal2B');
	break;

	///////////////////////////
	// No Orb : Level 2
	//
	case 2:
		ChargeStart('ChargeNormal3A',class'ChargeEffect1C',true,0.02,3,0.1);
		Sleep(3);
		ChargeStart('ChargeNormal3B',class'ChargeEffect1C',true,0.1);
		Sleep(20);
		Goto('ChargeNormal3B');
	break;

	///////////////////////////
	// No Orb : Level 4
	//
	case 3:
		ChargeStart('ChargeNormal4A',class'ChargeEffect1D',true,0.02,3,0.1);
		Sleep(3);
		ChargeStart('ChargeNormal4B',class'ChargeEffect1D',true,0.1);
		Sleep(20);
		Goto('ChargeNormal4B');
	break;
	}
	
	CheckContinueFire();	// Check if fire held down
}


// Special for Normal cell
//
function Touch ( actor Other )
{
	// Just ignore it - there's no way it should be an item and we don't want
	// misplaced displays or messages occurring.
	bHidden = true;
}

function BecomeItem()
{
	Super.BecomeItem();
	bHidden = true;
}

function NewItemDisplay()
{
	bHidden = true;
}

// Rate Cell
//
function float	RateCell ()
{
	// Override this function in subclasses
	return (1);
}

defaultproperties
{
     ExperienceNeeded(0)=500
     ExperienceNeeded(1)=2000
     ExperienceNeeded(2)=10000
     FireButtonDesc="Jazz Pulser"
     WeaponCapable(1)=255
     WeaponCapable(2)=255
     WeaponCapable(5)=255
     ChargeSound=Sound'JazzSounds.Weapons.chargeloop2'
     Bobbing=True
     PickupMessage="Normal Cell"
     Icon=Texture'JazzArt.Interface.Hud3Dreamcell640norm'
     DrawType=DT_None
     Mesh=None
}
