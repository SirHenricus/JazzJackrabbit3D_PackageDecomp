//=============================================================================
// JazzSmoke.
//=============================================================================
class JazzSmoke expands JazzAnimSprite;

// Randomize the smoke puff generated
var() Texture SSprites[20];
var() int NumSets;

var() float RisingRate;
	
simulated function PostBeginPlay()
{
	Velocity = Vect(0,0,1)*RisingRate;
	Texture = SSPrites[int(FRand()*NumSets*0.97)];
	if (Texture == None) Texture = Texture'S_Actor';
}

defaultproperties
{
     SSprites(0)=Texture'JazzAnimated.Smoke1-1'
     SSprites(1)=Texture'JazzAnimated.Smoke1-2'
     SSprites(2)=Texture'JazzAnimated.Smoke1-3'
     SSprites(3)=Texture'JazzAnimated.Smoke1-4'
     SSprites(4)=Texture'JazzAnimated.Smoke1-5'
     SSprites(5)=Texture'JazzAnimated.Smoke1-6'
     SSprites(6)=Texture'JazzAnimated.Smoke1-7'
     SSprites(7)=Texture'JazzAnimated.Smoke1-8'
     NumSets=2
     RisingRate=50.000000
     NumFrames=8
     Pause=0.050000
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=0.400000
     DrawType=DT_SpriteAnimOnce
     Style=STY_Translucent
     Sprite=Texture'JazzAnimated.Smoke1-1'
     Texture=Texture'JazzAnimated.Smoke1-1'
     DrawScale=0.500000
}
