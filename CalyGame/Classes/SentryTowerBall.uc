//=============================================================================
// SentryTowerBall.
//=============================================================================
class SentryTowerBall expands JazzPawnAI;

/////////////////////////////////////////////////////////////////////////////////////
// LIFE		 															STATES
/////////////////////////////////////////////////////////////////////////////////////
//
auto state Life
{
	Begin:
	SetPhysics(PHYS_Projectile);
	GotoState('Decision');
}

/////////////////////////////////////////////////////////////////////////////////////
// STATIONARY FIRING												ANIMATIONS
//
function PlayFiring() // Patch change - the firing animation should be a bit quicker
{ PlayAnim('spoot',2); }

event AnimEnd()
{
	AnimRate = 0;
}

// Patch Change - a new flashing effect when an actor is hurt.
function PlayHit(float Damage, vector HitLocation, name damageType, vector Momentum)
{
	local ActorShieldHitEffect Image;
	Image = spawn(class'ActorShieldHitEffect');
	Image.SetOwner(Self);
}


state AttackTarget
{
function FireProjectile( int ProjNum )
{
	ViewRotation = Rotation;
	
	// Check Weapon Cell Inventory Slot (0)
	if (Weapon != None)
	{
		Weapon.bPointing = true;
		JazzWeaponCell(InventorySelections[0]).Fire(0);
		PlayFiring();
	}
	else
	{
		VoicePackActor.DoSound(Self,VoicePackActor.ProjectileAttack);
		spawn(class<actor>(ProjAttackType[ProjNum]),,,Location+vector(Rotation)*20+vect(0,0,-20)); // Patch Change - Corrected the projectile's location a bit
		PlayFiring();
	}
}
}

defaultproperties
{
     TriggerHappy=INT_Vicious
     ProjAttack=True
     ProjAttackType(0)=Class'CalyGame.JazzNormal'
     ProjAttackDesire(0)=1
     DeathEffect=Class'CalyGame.JazzSentryBallDead'
     EnergyDamage=1.200000
     FireDamage=0.900000
     WaterDamage=1.300000
     SharpPhysicalDamage=0.500000
     BluntPhysicalDamage=1.200000
     bFreezeable=True
     FreezeSkin=Texture'JazzSpecial.gem1_01'
     VoicePack=None
     GroundSpeed=0.000000
     Visibility=130
     Health=50
     NameArticle="バ"
     AnimSequence=spoot
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.JSentryTurret_01'
     Skin=Texture'JazzObjectoids.Skins.JSentryTurret_01'
     Mesh=LodMesh'JazzObjectoids.SentryTurret'
     CollisionRadius=35.000000
     CollisionHeight=20.000000
     RotationRate=(Pitch=65536,Yaw=65536,Roll=65536)
}
