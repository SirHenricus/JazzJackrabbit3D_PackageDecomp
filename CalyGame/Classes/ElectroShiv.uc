//=============================================================================
// ElectroShiv.
//=============================================================================
//
// Weapon found in the game.
//
class ElectroShiv expands JazzWeapon;

//
// Also known as the 'gizmo gun'
//

function WeaponAnimationNormal()
{
	PlayAnim('WeaponAnim',1.0);
}

function AnimEnd()
{
	PlayAnim('Weaponidle',1.0);
}

function PlayIdleAnim()
{
	PlayAnim('Weaponidle',1.0);
}

defaultproperties
{
     NormalWeaponCell=Class'CalyGame.JazzNormalCell'
     WeaponSwitchNumber=0
     WeaponTypeNumber=5
     Bobbing=True
     AIRating=2.000000
     bRotatingPickup=False
     PickupMessage="Electro Shiv"
     ItemName="Electro Shiv"
     PlayerViewMesh=LodMesh'JazzObjectoids.Jazzweapon2'
     PickupViewMesh=LodMesh'JazzObjectoids.Jazzweapon2'
     ThirdPersonMesh=LodMesh'JazzObjectoids.Jazzweapon2'
     Icon=Texture'JazzArt.Interface.GunGizmo'
     Texture=Texture'JazzObjectoids.Skins.Jpumptip_01'
     Mesh=LodMesh'JazzObjectoids.Jazzweapon2'
     LightType=LT_Steady
     LightEffect=LE_SlowWave
     LightBrightness=255
     LightHue=153
     LightSaturation=35
     LightRadius=8
}
