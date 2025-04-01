//=============================================================================
// MissileLauncher.
//=============================================================================
class MissileLauncher expands JazzWeapon;

function WeaponAnimationNormal()
{
	PlayAnim('WeaponAnim',1.0);
}

defaultproperties
{
     WeaponSwitchNumber=2
     WeaponTypeNumber=2
     Bobbing=True
     PickupMessage="Gizmo Gun"
     ItemName="Gizmo Gun"
     PlayerViewMesh=LodMesh'JazzObjectoids.Jazzweapon2'
     PickupViewMesh=LodMesh'JazzObjectoids.Jazzweapon2'
     ThirdPersonMesh=LodMesh'JazzObjectoids.Jazzweapon2'
     Icon=Texture'JazzArt.Interface.GunGizmo'
     Mesh=LodMesh'JazzObjectoids.Jazzweapon2'
     LightBrightness=102
     RotationRate=(Yaw=30000)
}
