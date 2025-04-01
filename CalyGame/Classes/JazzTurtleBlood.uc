//=============================================================================
// JazzTurtleBlood.
//=============================================================================
class JazzTurtleBlood expands JazzEffects;

var float Life;
var rotator RandRot;

function BeginPlay ()
{
	Life = 1+rand(2);
	RandRot.Yaw = rand(65536);
	RandRot.Roll = rand(65536);
	RandRot.Pitch = rand(65536);
}

function Tick( float DeltaTime )
{
	Life -= DeltaTime;
	if ( Life <= 0 )
	{
		//Style = STY_Translucent;
		DrawScale -= DeltaTime*2;
		if ( DrawScale < 0 )
		{ Destroy(); }
	}
	
	SetRotation(RandRot);
}


simulated function HitWall( vector HitNormal, actor Wall )
{
	Velocity = vect(0,0,0);
	//Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	//if ( Velocity.Z > 400 )
		//Velocity.Z = 0.5 * (400 + Velocity.Z);
}

defaultproperties
{
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Texture=Texture'JazzyTextures.plantwall1a'
     Skin=Texture'JazzyTextures.plantwall1a'
     Mesh=LodMesh'JazzObjectoids.exball'
     DrawScale=3.000000
     MultiSkins(0)=Texture'JazzyTextures.plantwall1a'
     MultiSkins(1)=Texture'JazzyTextures.plantwall1a'
     CollisionRadius=2.000000
     CollisionHeight=2.000000
     bCollideWorld=True
}
