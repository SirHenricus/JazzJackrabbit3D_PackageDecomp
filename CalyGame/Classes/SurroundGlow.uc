//=============================================================================
// SurroundGlow.
//=============================================================================
class SurroundGlow expands JazzEffects;

var() float SurroundGlowAmount;

function Tick ( float DeltaTime )
{
	if (Owner == None)
	Destroy();

	Mesh = Owner.Mesh;
	DrawScale = Owner.DrawScale*SurroundGlowAmount;
	Texture = Owner.Texture;
	Skin = Owner.Skin;
	AnimSequence = Owner.AnimSequence;
	AnimFrame = Owner.AnimFrame;
	SetLocation(Owner.Location);
	SetRotation(Owner.Rotation);
}

defaultproperties
{
     SurroundGlowAmount=1.030000
     DrawType=DT_Mesh
     Style=STY_Translucent
     bUnlit=True
}
