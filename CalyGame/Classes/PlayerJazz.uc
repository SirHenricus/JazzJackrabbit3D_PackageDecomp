//=============================================================================
// DudeJazz.
//=============================================================================
class PlayerJazz expands JazzPlayer;

// Animation
var name	CurrentAnimation;
var int		LandDone;

//-----------------------------------------------------------------------------
// Animation functions


function SpecialChangeSkin( byte Color )
{
	switch (Color)
	{
		case 1:
			Skin = texture'Jazz_Blue_BB';
		break;

		case 2:
			Skin = texture'Jazz_Green_RB';
		break;
		
		case 3:
			Skin = texture'Jazz_Yellow_PB';
		break;
		
		case 4:
			Skin = texture'Jazz_Grey_BB';
		break;
		
		case 5:
			Skin = texture'Jazz_Red_GB';
		break;
		
		case 6:
			Skin = texture'Jazz_Purple_PB';
		break;
	}
	
	Super.SpecialChangeSkin(Color);
}

function bool AnimateOk()
{
	return(Mesh == Default.Mesh);
}

function PlayTurning()
{
}

function TweenToWalking(float tweentime)
{
	if (AnimateOk())
	if (WeaponPointingCheck())
	{ TweenAnim('JazzRunShooting',tweentime); }
	else
	{ TweenAnim('JazzRun',tweentime); }
}

function TweenToRunning(float tweentime)
{
	if ((AnimSequence != 'JazzLand') || (LandDone == 0))
	{
		if (AnimateOk())
		if (WeaponPointingCheck())
		{ TweenAnim('JazzRunShooting',tweentime); }
		else
		{ TweenAnim('JazzRun',tweentime); }
	}
}

function PlayWalking()
{
	if ((AnimSequence != 'JazzLand') || (LandDone == 0))
	{
		if (AnimateOk())
		if (WeaponPointingCheck())
		{ PlayAnim('JazzRunShooting',RunningAnimationSpeed); }
		else
		{ LoopAnim('JazzRun',RunningAnimationSpeed); }
	}
}

function PlayRunForward()
{
	if ((AnimSequence != 'JazzLand') || (LandDone == 0))
	{
		if (DashTime>0)
		{ RunningAnimationSpeed += (2-RunningAnimationSpeed)*0.05; }
		else
		{ RunningAnimationSpeed = 1; }
	
		if (OldRunContinue)
		{
			if ((AnimSequence == 'JazzRunShooting') || (AnimSequence == 'JazzRun'))
			return;
		}
	
		if (AnimateOk())
		if ((AnimSequence != 'JazzRunShooting') && (AnimSequence != 'JazzRun') &&
			(AnimSequence != 'RunBackShoot') && (AnimSequence != 'RunBackNoShoot')
			)
		{
			if (WeaponPointingCheck())
			{ TweenAnim('JazzRunShooting',0.1); }
			else
			{ TweenAnim('JazzRun',0.1); }
		}
		else
		{
			if (WeaponPointingCheck())
			{ PlayAnim('JazzRunShooting',RunningAnimationSpeed); }
			else
			{ LoopAnim('JazzRun',RunningAnimationSpeed); }
		}
	}
}

function PlayRunBackward()
{
	if ((AnimSequence != 'JazzLand') || (LandDone == 0))
	{
		if (DashTime>0)
		{ RunningAnimationSpeed += (2-RunningAnimationSpeed)*0.05; }
		else
		{ RunningAnimationSpeed = 1; }
		
		if (OldRunContinue)
		{
			if ((AnimSequence == 'RunBackShoot') || (AnimSequence == 'RunBackNoShoot'))
			return;
		}
		
		if (AnimateOk())
	/*	if ((AnimSequence != 'RunBackShoot') && (AnimSequence != 'RunBackNoShoot'))
		{
			if(WeaponPointingCheck())
			{ TweenAnim('RunBackShoot',0.05); }
			else
			{ TweenAnim('RunBackNoShoot',0.05); }
		}
		else*/
		{
			if (WeaponPointingCheck())
			{ PlayAnim('RunBackShoot',RunningAnimationSpeed); }
			else
			{ LoopAnim('JazzRun',RunningAnimationSpeed);
			//LoopAnim('RunBackNoShoot',RunningAnimationSpeed);
			}
		}
	}
}

function PlayStrafeLeft()
{
	if ((AnimSequence != 'JazzLand') || (LandDone == 0))
	{
		if (DashTime>0)
		{ RunningAnimationSpeed += (2-RunningAnimationSpeed)*0.05; }
		else
		{ RunningAnimationSpeed = 1; }
	
		if (OldRunContinue)
		{
			if ((AnimSequence == 'RunLeftShoot') || (AnimSequence == 'RunLeftNoShoot') || (AnimSequence == 'JazzRun'))
			return;
		}
		
		if (AnimateOk())
		if ((AnimSequence != 'RunLeftShoot') && (AnimSequence != 'RunLeftNoShoot') && (AnimSequence != 'JazzRun'))
		{
			if (WeaponPointingCheck())
			{ TweenAnim('RunLeftShoot',0.1); }
			else
			{
			TweenAnim('JazzRun',0.1);
			//TweenAnim('RunLeftNoShoot',0.1);
			}
		}
		else
		{
			if (WeaponPointingCheck())
			{ PlayAnim('RunLeftShoot',RunningAnimationSpeed); }
			else
			{
			LoopAnim('JazzRun',RunningAnimationSpeed);
			//LoopAnim('RunLeftNoShoot',RunningAnimationSpeed);
			}
		}
	}
}

function PlayStrafeRight()
{
	if ( (AnimSequence != 'JazzLand') || (LandDone == 0) ) 
	{
		if (DashTime>0)
		{ RunningAnimationSpeed += (2-RunningAnimationSpeed)*0.05; }
		else
		{ RunningAnimationSpeed = 1; }
	
		if (OldRunContinue)
		{
			if ((AnimSequence == 'RunRightShoot') || (AnimSequence == 'RunRightNoShoot') || (AnimSequence == 'JazzRun'))
			return;
		}
		
		if (AnimateOk())
		if ((AnimSequence != 'RunRightShoot') && (AnimSequence != 'RunRightNoShoot') && (AnimSequence != 'JazzRun'))
		{
			if (WeaponPointingCheck())
			{ TweenAnim('RunRightShoot',0.1); }
			else
			{
			TweenAnim('JazzRun',0.1);
			//TweenAnim('RunRightNoShoot',0.1);
			}
		}
		else
		{
			if (WeaponPointingCheck())
			{ PlayAnim('RunRightShoot',RunningAnimationSpeed); }
			else
			{
			LoopAnim('JazzRun',RunningAnimationSpeed);
			//LoopAnim('RunRightNoShoot',RunningAnimationSpeed);
			}
		}
	}
}

function PlayRising()
{
}

function PlayFeignDeath()
{
}

function PlayDying(name DamageType, vector HitLoc)
{
	if (AnimateOk())
	CurrentAnimation = '';
}

function PlayGutHit(float tweentime)
{
}

function PlayHeadHit(float tweentime)
{
}

function PlayLeftHit(float tweentime)
{
}

function PlayRightHit(float tweentime)
{
}

function PlayLanded(float impactVel)
{
	Log("JazzPlayer) Land");
	PlayAnim('JazzLand');
	LandDone = 2;
}
	
function PlayFlyingUp()
{
	if (AnimateOk())
	if (WeaponPointingCheck())
	{ LoopAnim('JazzFallShooting'); }
	else
	{ PlayAnim('JazzForwardJump'); }
}
function TweenToFlyingUp(float tweentime)
{
	if (WeaponPointingCheck())
	{ LoopAnim('JazzFallShooting'); }
	else
	{ TweenAnim('JazzForwardJump',tweentime); }
}

function PlayFallingDown()
{
	if (AnimateOk())
	if (WeaponPointingCheck())
	{ LoopAnim('JazzFallShooting'); }
	else
	{ LoopAnim('JazzFall'); }
}
function TweenToFallingDown(float tweentime)
{
	if (WeaponPointingCheck())
	{ TweenAnim('JazzFallShooting',tweentime); }
	else
	{ TweenAnim('JazzFall',tweentime); }
}

function PlayDuck()
{
	if (WeaponPointingCheck())
	{ LoopAnim('crouchshoot',0.8); }
	else
	{ LoopAnim('crouch',0.8); }
	AnimRate = 0.75;
}

function PlayCrawling()
{
	if (WeaponPointingCheck())
	{ TweenAnim('crouchshoot',0.01); }
	else
	{ TweenAnim('crouch',0.01); }
	AnimRate = 0.75;
}

function PlayWaiting()
{
	if (AnimateOk())
	{
		if ((AnimSequence != 'JazzLand') || (LandDone == 0))
		{
			if (WeaponPointingCheck())
			{ LoopAnim('StandShoot'); }
			else
			{ LoopAnim('Stand'); }
			AnimRate = 1;
		}
	}
}

function TweenToWaiting(float tweentime)
{
	if (AnimateOk())
	{
		if ((AnimSequence != 'JazzLand') || (LandDone == 0))
		{
			if (AnimateOk())
			{ TweenAnim('Stand',tweentime); }
			AnimRate = 1;
		}
	}
}
	
/*function PlayWaiting()
{
	if (AnimateOk())
	{
		if ((AnimSequence != 'JazzLand') || (LandDone == 0))
		{
			if (WeaponPointingCheck())
			{ LoopAnim('StandShoot'); } // PlayAnim('JazzIdle1Shoot'); }
			else
			{ PlayAnim('Stand'); } // LoopAnim('JazzIdle1'); }
			AnimRate = 0.75;
		}
	}
	
	if ((AnimSequence != 'JazzLand') || (LandDone == 0))
	if ((AnimSequence != 'JazzIdle1Shoot') && (AnimSequence != 'JazzIdle1'
		&& AnimSequence != 'StandShoot') && (AnimSequence != 'Stand'))
	{
		if (WeaponPointingCheck())
		{ TweenAnim('StandShoot',0); } //TweenAnim('JazzIdle1Shoot',0.1); }
		else
		{ TweenAnim('Stand',0.1); } //TweenAnim('JazzIdle1',0.1); }
	}
	else
	{
		if (WeaponPointingCheck())
		{ PlayAnim('StandShoot'); } // PlayAnim('JazzIdle1Shoot'); }
		else
		{ LoopAnim('Stand',0.1); } // LoopAnim('JazzIdle1'); }
	}
}

function TweenToWaiting(float tweentime)
{
	//TweenAnim('JazzIdle1',tweentime);
	if (AnimateOk())
	{
		if ((AnimSequence != 'JazzLand') || (LandDone == 0))
		{
			if (WeaponPointingCheck())
			{ LoopAnim('StandShoot'); } // PlayAnim('JazzIdle1Shoot'); }
			else
			{ TweenAnim('Stand',0.01); } // LoopAnim('JazzIdle1'); }
			AnimRate = 0.75;
		}
	}
}
*/

function PlayFiring()
{
	if (AnimateOk())
	switch (AnimSequence)
	{
		case 'Stand':
			PlayAnim('StandShoot'); //PlayAnim('JazzIdle1Shoot');
		break;
		
		case 'JazzRun':
			PlayAnim('JazzRunShooting',RunningAnimationSpeed);
		break;
	
		case 'jazzfall':
			PlayAnim('JazzFallShooting');
		break;
		
		case 'RunLeftNoShoot':
			PlayAnim('RunLeftShoot',RunningAnimationSpeed);
		break;
		
		case 'RunRightNoShoot':
			PlayAnim('RunRightShoot',RunningAnimationSpeed);
		break;
		
		case 'RunBackNoShoot':
			PlayAnim('RunBackShoot',RunningAnimationSpeed);
		break;
		
		case 'JazzSwimForward':
			PlayAnim('JazzSwimForwardShooting',SwimmingAnimationSpeed);
		break;
	}
}

function PlayWeaponSwitch(Weapon NewWeapon)
{
}

function PlaySwimming()
{
	//SwimmingAnimationSpeed = 0.1 + sqrt(abs(Velocity.X * Velocity.X + Velocity.Y * Velocity.Y)) * 0.01;
	if (WeaponPointingCheck())
	{ PlayAnim('JazzSwimForwardShooting',SwimmingAnimationSpeed); }
	else
	{ PlayAnim('JazzSwimForward',SwimmingAnimationSpeed); }
}

function TweenToSwimming(float tweentime)
{
	if (WeaponPointingCheck())
	{ TweenAnim('JazzSwimForwardShooting',tweentime); }
	else
	{ TweenAnim('JazzSwimForward',tweentime); }
}

function PlayTreading()
{
	if (WeaponPointingCheck())
	{ PlayAnim('JazzSwimForwardShooting',SwimmingAnimationSpeed); }
	else
	{ PlayAnim('JazzSwimForward',SwimmingAnimationSpeed); }
}

function TweenToTreading(float tweentime)
{
	if (WeaponPointingCheck())
	{ TweenAnim('JazzSwimForwardShooting',tweentime); }
	else
	{ TweenAnim('JazzSwimForward',tweentime); }
}

function PlayGrabbing(float tweentime)
{

}

// Ledge Functionality
// 
function PlayLedgePullup(float tweentime)
{
	if (AnimateOk())
	PlayAnim('JazzLedgePullup');
}

function PlayLedgeHang()
{
	if (AnimateOk())
	PlayAnim('JazzLedgeHang');
}

function PlayLedgeGrab()
{
	if (AnimateOk())
	PlayAnim('JazzLedgeGrab');
}

function PlaySwimBigStroke(float tweentime)
{

}

function PlaySwimSteadyStroke(float tweentime)
{

}

function PlaySwimTread(float tweentime)
{

}

function bool WeaponPointingCheck()
{
	if (Weapon == None)
	return false;
	else
	return Weapon.bPointing;
}

state PlayerWalking
{
	event AnimEnd()
	{
		if (AnimSequence == 'JazzLand')
		{
		if (LandDone>0) LandDone--;
		PlayWaiting();
		}
		
		Super.AnimEnd();
	}
}

defaultproperties
{
     HealthMaximum=100
     RunningAnimationSpeed=1.000000
     MaxSwimmingJumpDuration=1.000000
     VoicePack=Class'CalyGame.VoiceJazzJackrabbit'
     EnergyDamage=1.000000
     FireDamage=1.000000
     WaterDamage=1.000000
     SoundDamage=1.000000
     SharpPhysicalDamage=1.000000
     BluntPhysicalDamage=1.000000
     WaterSpeed=300.000000
     JumpZ=650.000000
     BaseEyeHeight=-20.000000
     Physics=PHYS_Falling
     AnimSequence=jazzidle1
     LODBias=100.000000
     DrawType=DT_Mesh
     Texture=Texture'Jazz3.Jjazz_01'
     Skin=Texture'Jazz3.Jjazz_01'
     Mesh=LodMesh'Jazz3.Jazz'
     CollisionRadius=18.000000
     CollisionHeight=36.000000
     bActorShadows=False
}
