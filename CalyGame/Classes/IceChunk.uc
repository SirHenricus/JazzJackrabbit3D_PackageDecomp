//=============================================================================
// IceChunk.
//=============================================================================
class IceChunk expands BaseChunk;

function Tick ( float DeltaTime )
{
	DrawScale = (LifeSpan / Default.LifeSpan * 0.8);
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	//RandSpin(sqrt(abs(Velocity.X)+abs(Velocity.Y)+abs(Velocity.Z)));
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	
	
	/*Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	if ( Velocity.Z > 400 )
		Velocity.Z = 0.5 * (400 + Velocity.Z);	*/
}

defaultproperties
{
     LifeSpan=5.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=Texture'JazzObjectoids.Skins.Jicebomb_01'
     Mesh=LodMesh'JazzObjectoids.iceshard'
     DrawScale=0.800000
     CollisionRadius=4.000000
     CollisionHeight=4.000000
     bCollideActors=True
     bCollideWorld=True
     bFixedRotationDir=True
     Buoyancy=40.000000
}
