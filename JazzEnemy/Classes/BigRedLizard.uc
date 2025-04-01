//=============================================================================
// BigRedLizard.
//=============================================================================
class BigRedLizard expands Lizard;

var actor InvulnerableGlow;
var float SpecialEffectTime;
var float drowning;

#exec TEXTURE IMPORT NAME=JLizard_02 FILE=Textures\Lizard_02.PCX GROUP=Skins FLAGS=2	//Material #1

/////////////////////////////////////////////////////////////////////////////////////
// Override Action														STATES
/////////////////////////////////////////////////////////////////////////////////////
//
//
//
state HitAnimation
{

Begin:
	IgnoreAllDecisions = true;
	StateBasedInvulnerability = true;
	InvulnerableGlow = spawn(class'SurroundGlow',Self);

	SpecialEffectTime = 4;
	InvulnerabilityTime = 4;
	
	Acceleration = vect(0,0,0);
	TweenAnim('LizardIdle',0.3);
	Sleep(0.3);
	
	PlayAnim('LizardIdle',0.3);
	Sleep(0.5);
	
	InvulnerableGlow.Destroy();
	
	IgnoreAllDecisions = false;
	GotoState('Decision');
}

function Tick ( float DeltaTime )
{
	local JazzSmokeGenerator S;
	Super.Tick(DeltaTime);
	
	if (SpecialEffectTime>0)
	{
		SpecialEffectTime -= DeltaTime;
		InvulnerableGlow.ScaleGlow = SpecialEffectTime;

		DoPlayerTrail();
	}
	else
	{
		StateBasedInvulnerability = false;
		
		if (InvulnerableGlow != None)
		InvulnerableGlow.Destroy();
	}
	
	if (drowning == 1)
	{
		Health = -100;
		
		S = spawn(class'JazzSmokeGenerator');
		S.TotalNumPuffs = 5;
		S.RisingVelocity = 50;
		S.GenerationType = class'JazzSmoke';
		S.Trigger(None,None);
			
		//PlaySound(WaterFizzleSound);
		//GotoState('Fizzling');
	}
}

simulated function ZoneChange( ZoneInfo NewZone )
{ drowning = 1;	}

function DoPlayerTrail ()
{
	local JazzPlayerTrailImage Image;
	Image = spawn(class'JazzPlayerTrailImage');
	Image.AnimFrame = AnimFrame;
	Image.AnimRate = 0;
	Image.AnimSequence = AnimSequence;
	Image.Mesh = Mesh;
	Image.Skin = Skin;
	Image.DrawScale = DrawScale;
}

defaultproperties
{
     ProjRecharge=3.000000
     RushSpeed=320.000000
     DeathEffect=Class'CalyGame.ParticleExplosion'
     JumpOnDamage=5
     JumpOnTakeDamage=True
     JumperDamage=5
     JumperTakeDamage=True
     FireDamage=0.500000
     WaterDamage=1.500000
     bBurnable=False
     bPetrify=True
     GroundSpeed=340.000000
     Health=200
     HitSound1=None
     HitSound2=None
     Die=None
     Texture=Texture'JazzEnemy.Skins.JLizard_02'
     DrawScale=2.300000
     CollisionRadius=30.000000
     CollisionHeight=66.599998
}
