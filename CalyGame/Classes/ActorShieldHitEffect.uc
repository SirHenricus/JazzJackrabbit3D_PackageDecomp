//=============================================================================
// ActorShieldHitEffect.
//=============================================================================
class ActorShieldHitEffect expands JazzEffects;
/// This is a new type of effect created by the Patcher. ///

//var bool blow;
var(HitEffect) bool 			blow;
var(HitEffect) float 			GlowMultiplier;
var(HitEffect) float 			FatMultiplier;

simulated event BeginPlay()
{
	AnimFrame = Owner.AnimFrame;
	AnimRate = Owner.AnimRate;
	AnimSequence = Owner.AnimSequence;
	Mesh = Owner.Mesh;
	DrawScale = Owner.DrawScale;
	Fatness = Owner.Fatness;
	
	SetRotation(Owner.Rotation);
	SetLocation(Owner.Location);
}


simulated event Tick ( float DeltaTime )
{	
	if (blow == true)
	{ Fatness += DeltaTime*FatMultiplier; }
	
	ScaleGlow -= DeltaTime*GlowMultiplier;	
	
	if (ScaleGlow <= 0)
	{ Destroy(); }
	if (Owner == none)
	{ Destroy(); }
	
	AnimFrame = Owner.AnimFrame;
	AnimRate = Owner.AnimRate;
	AnimSequence = Owner.AnimSequence;
	Mesh = Owner.Mesh;
	DrawScale = Owner.DrawScale;
	
	SetRotation(Owner.Rotation);
	SetLocation(Owner.Location);
}

defaultproperties
{
     GlowMultiplier=5.000000
     FatMultiplier=300.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Sprite=Texture'Engine.S_Actor'
     Texture=Texture'JazzSpecial.Red'
     Skin=Texture'JazzSpecial.Red'
     bUnlit=True
}
