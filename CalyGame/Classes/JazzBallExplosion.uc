//=============================================================================
// JazzBallExplosion.
//=============================================================================
class JazzBallExplosion expands JazzWeaponEffects;

var SurroundGlow S;

// Uses Alec's Ball Explosion
//
var() float LifeSpanMax;

auto state Exploding 
{
	event Tick ( float DeltaTime )
	{
		ScaleGlow = LifeSpan/LifeSpanMax;
		S.ScaleGlow = ScaleGlow;
		DrawScale = (Default.DrawScale) - (1-LifeSpan/LifeSpanMax)*Default.DrawScale;
		LightRadius = Default.LightRadius*(LifeSpan/LifeSpanMax);
		LightBrightness = Default.LightBrightness*(LifeSpan/LifeSpanMax);
	}
	
begin:

}

function PreBeginPlay ()
{
	DrawScale = 0;
	Super.PreBeginPlay();
	LifeSpan = LifeSpanMax;
	S = spawn(class'SurroundGlow',Self);
	S.SurroundGlowAmount = 0.5;
	PlayAnim('exball',0.5);
}

defaultproperties
{
     LifeSpanMax=1.000000
     LifeSpan=1.000000
     AnimSequence=exball
     AnimRate=1.000000
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=LodMesh'JazzObjectoids.exball'
     DrawScale=8.000000
     bUnlit=True
     CollisionRadius=20.000000
     CollisionHeight=20.000000
     LightType=LT_Steady
     LightBrightness=102
     LightSaturation=51
     LightRadius=28
     bSpecialLit=True
}
