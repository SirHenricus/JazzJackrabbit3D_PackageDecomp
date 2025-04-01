//=============================================================================
// JazzFireCell.
//=============================================================================
class JazzFireCell expands JazzWeaponCell;

var int	RepeatShot;


///////////////////////////////////////////////////////////////////////////////////////
// Normal Fire : Weapon JackrabbitGun									FIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state FireStateJazz			// Jazz Jackrabbit's Weapon
{
	// Missile launcher
	// Perform actual firing here
	Missile:
		// Projectile JazzNormal / Speed 600 / Warns target
		if (CheckAvailableAmmo(20)==false) CheckContinueFire();
		UseAmmo(20);
		ProjectileFire(class'JazzHomingMissile', 600, true);
		
		// Patch change - let's make Jazz bounce backwards once he shoots this badass stuff!
		if ((JazzPlayer(Owner).bIsCrouching == false) && (JazzPlayer(Owner).Physics == PHYS_Walking) )
		{
			JazzPlayer(Owner).Velocity.Z = JazzPlayer(Owner).Velocity.Z+300;
			JazzPlayer(Owner).PlayFallingDown();
		}
		JazzPlayer(Owner).aForward = JazzPlayer(Owner).aForward-150;
		JazzPlayer(Owner).SetPhysics(PHYS_Falling);	
		if ( JazzPlayer(Owner).Base != JazzPlayer(Owner).Level )
			{ JazzPlayer(Owner).Velocity.Z += JazzPlayer(Owner).Base.Velocity.Z; } 
		
		AnimateWeapon(0);
		Sleep(0.3);
	
		MainFireDelay(0.85);	// Main reload 0.5 seconds
		//Sleep(0.5);			// Weapon reload time	
	
	CheckContinueFire();	// Check if fire held down


	// Perform actual firing here
	Begin:

	switch (CurrentPowerLevel)
	{
	
	///////////////////////////
	// Fire Orb : Level 0
	//
	//
	//
	case 0:
		if (CheckAvailableAmmo(10)==false) CheckContinueFire();
		UseAmmo(10);
		ProjectileFire(class'JazzNapalm', 600, true);
		AnimateWeapon(0);
		Sleep(0.3);
	
		MainFireDelay(0.85);	// Main reload 0.5 seconds
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
	// Level 1
	ChargeNormalA:
		AimError=0;
		ProjectileFire(class'JazzFire', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		UseAmmo(10);
		CheckContinueFire();
	
	ChargeNormalB:
		AimError=0;
		ProjectileFire(class'JazzFireLarge', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		UseAmmo(30);
		CheckContinueFire();
		
	ChargeNormalC:
		AimError=0;
		ProjectileFire(class'JazzFireLarge', 700, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		UseAmmo(30);
		CheckContinueFire();

	// Missile Launcher
	//		
	Missile:
		//Log("MissileLauncher) Special");
		for (RepeatShot=0; RepeatShot<=2; RepeatShot++)
		{
			AimError=0;
			if (CheckAvailableAmmo(10)==false) CheckContinueFire();
			UseAmmo(10);
			ProjectileFire(class'JazzMissile', 700, true);
			
			// Patch change - let's make Jazz bounce backwards once he shoots this badass stuff!
			if ((JazzPlayer(Owner).bIsCrouching == false) && (JazzPlayer(Owner).Physics == PHYS_Walking) )
			{
				JazzPlayer(Owner).Velocity.Z = JazzPlayer(Owner).Velocity.Z+200;
				JazzPlayer(Owner).PlayFallingDown();
			}
			if (JazzPlayer(Owner).Physics != PHYS_Swimming)
			{
				JazzPlayer(Owner).aForward = JazzPlayer(Owner).aForward-25;
				JazzPlayer(Owner).SetPhysics(PHYS_Falling);
				if ( JazzPlayer(Owner).Base != JazzPlayer(Owner).Level )
					{ JazzPlayer(Owner).Velocity.Z += JazzPlayer(Owner).Base.Velocity.Z; } 
			}
			//
			AnimateWeapon(0);
			Sleep(0.1);
		}
		AltFireDelay(0.5);	// Main reload 0.5 seconds
		CheckContinueFire();
	

	// Normal weapon
	// Perform actual firing here
	Begin:
		///////////////////////////
		// No Orb : Level 0
		//
		if (CheckAvailableAmmo(10)==false) CheckContinueFire();
		ChargeStart('ChargeNormalA',class'ChargeEffect1',true,0.0,1,0.05);
		Sleep(1);
		if (CheckAvailableAmmo(30)==false) Goto('ChargeNormalA');
		ChargeStart('ChargeNormalB',class'ChargeEffect1',true,0.05,1,0.15);
		Sleep(1);
		if (CheckAvailableAmmo(30)==false) Goto('ChargeNormalB');
		ChargeStart('ChargeNormalC',class'ChargeEffect1',true,0.15);
		Sleep(20);
		Goto('ChargeNormalC');
	
	CheckContinueFire();	// Check if fire held down
}

function bool	HasAltFire()
{
	return (true);
}

defaultproperties
{
     FireButtonDesc="Sticky Fireball"
     Flaming=True
     WeaponCapable(1)=255
     WeaponCapable(2)=255
     WeaponCapable(5)=255
     ItemName="Fire Energy"
     Bobbing=True
     PickupMessage="Fire Cell"
     PlayerViewMesh=LodMesh'JazzObjectoids.FireCell'
     PickupViewMesh=LodMesh'JazzObjectoids.FireCell'
     Icon=Texture'JazzArt.Interface.Hud3Dreamcell640fire'
     Physics=PHYS_Rotating
     AnimSequence=FireCell
     AnimRate=10.000000
     Mesh=LodMesh'JazzObjectoids.FireCell'
     LightType=LT_Steady
     LightEffect=LE_TorchWaver
     LightBrightness=255
     LightRadius=5
     RotationRate=(Yaw=10000)
}
