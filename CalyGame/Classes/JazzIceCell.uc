//=============================================================================
// JazzIceCell.
//=============================================================================
class JazzIceCell expands JazzWeaponCell;

///////////////////////////////////////////////////////////////////////////////////////
// Normal Fire : Weapon JackrabbitGun									FIRE
///////////////////////////////////////////////////////////////////////////////////////
//
state FireStateJazz			// Jazz Jackrabbit's Weapon
{
	// Perform actual firing here
	Begin:

	switch (CurrentPowerLevel)
	{
	
	//////////////////////////
	// Ice Orb : Level 0
	//
	//
	//
	case 0:
		if (CheckAvailableAmmo(5)==false) CheckContinueFire();
		AimError = 0;
		ProjectileFire(class'JazzIceShard', 800, true);
		AnimateWeapon(0);
		UseAmmo(5);
	
		MainFireDelay(0.5);
		//Sleep(0.5);
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
		AimError = 0;
		ProjectileFire(class'JazzIceShard', 800, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);
		UseAmmo(10);
		CheckContinueFire();
	
	ChargeNormalB:
		AimError = 0;
		ProjectileFire(class'JazzIce', 800, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);
		UseAmmo(30);
		CheckContinueFire();
		
	ChargeNormalC:
		AimError = 0;
		ProjectileFire(class'JazzIceGrenade', 800, true);
		AnimateWeapon(0);
		AltFireDelay(0.5);
		UseAmmo(60);
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
		if (CheckAvailableAmmo(10)==false) CheckContinueFire();
		ChargeStart('ChargeNormalA',class'ChargeEffect1',true,0.0,1,0.05);
		Sleep(1);
		if (CheckAvailableAmmo(30)==false) Goto('ChargeNormalA');
		ChargeStart('ChargeNormalB',class'ChargeEffect1',true,0.05,1,0.15);
		Sleep(1);
		if (CheckAvailableAmmo(60)==false) Goto('ChargeNormalB');
		ChargeStart('ChargeNormalC',class'ChargeEffect1',true,0.15);
		Sleep(20);
		Goto('ChargeNormalC');
	break;
	}
	
	CheckContinueFire();	// Check if fire held down
}

defaultproperties
{
     WeaponCapable(1)=255
     ItemName="Ice Energy"
     Bobbing=True
     PickupMessage="Ice Cell"
     PickupViewMesh=LodMesh'JazzObjectoids.IceCell'
     Icon=Texture'JazzArt.Interface.Hud3Dreamcell640ice'
     Physics=PHYS_Rotating
     AnimSequence=IceCell
     AnimRate=1.000000
     Skin=Texture'JazzObjectoids.Skins.Jicebomb_01'
     Mesh=LodMesh'JazzObjectoids.IceCell'
     LightType=LT_Steady
     LightBrightness=255
     LightHue=143
     LightRadius=10
}
