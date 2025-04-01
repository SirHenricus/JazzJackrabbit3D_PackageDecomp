//=============================================================================
// JazzBoulder.
//=============================================================================
class JazzBoulder expands JazzPlainObjects;

var()	bool		BreakFromFall;


simulated function HitWall( vector HitNormal, actor Wall ) // Landed( vector HitNormal )
{
	local int x;
	local BaseChunk Chunk;
	local vector ChunkLocation;
	local vector NewVel;
	local vector RVel;

	if ( BreakFromFall == True )// && (sqrt(abs(Velocity.X*Velocity.X + Velocity.Y*Velocity.Y + Velocity.Z*Velocity.Z)) > 0
	{
		// Chunk Effect
		if (ChunkClass != None)
		{
			SmokePart = Spawn(class'RockExplosion',self);
			SmokePart.DrawScale = DrawScale + 3;
				
			for(x = NumberOfChunks; x > 0; x--)
			{
				// Patch change - Improved chunk generator. Now randomizes the size and location.
				ChunkLocation = Location + VRand()*Drawscale*30;
				Chunk = spawn(ChunkClass,,,ChunkLocation);
				Chunk.Size = DrawScale*5/NumberOfChunks;//SizeOfChunks;
				Chunk.RandSize = 0.5;//RandSizeOfChunks;
				
				NewVel = Velocity;
				RVel = VRand() * 200;
				Chunk.Velocity = RVel+NewVel;
			}
		}
			
		// Destroy Effect
		if (DestroyEffect != None)
		spawn(class<actor>(DestroyEffect),None,,Location,Rotation);
			
		if (DestroySound !=None)
		PlaySound(DestroySound);
		
		Destroy();
	}
}

function CenterOfGravityCheck ( float DeltaTime )
{
	local vector NewLocation,OriginLocation;
	local float LocSlide;
	local vector XSpeed,YSpeed;
	
	if ((Physics == PHYS_Walking) || (Physics == PHYS_Rolling))
	{
		// Moving already?
		NewLocation = Location;
		NewLocation.Z -= CollisionHeight + 5;

		// Center blocked?
		if (VectorTrace(NewLocation,Location)==false)
		return;
			
		// Continue to move object in direction that is not blocked.
		OriginLocation = Location;

		LocSlide = 100*DeltaTime;
		XSpeed.X += LocSlide;
		YSpeed.Y += LocSlide;

		NewLocation.X += CollisionRadius;
		OriginLocation.X += CollisionRadius;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// E
		{
			Velocity += XSpeed;
			Acceleration += XSpeed;
		}

		NewLocation.X -= CollisionRadius*2;
		OriginLocation.X -= CollisionRadius*2;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// W
		{
			Velocity -= XSpeed;
			Acceleration -= XSpeed;
		}

		NewLocation.X += CollisionRadius;
		NewLocation.Y += CollisionRadius;
		OriginLocation.X += CollisionRadius;
		OriginLocation.Y += CollisionRadius;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// S
		{
			Velocity += YSpeed;
			Acceleration += YSpeed;
		}

		NewLocation.Y -= CollisionRadius*2;
		OriginLocation.Y -= CollisionRadius*2;
		if (VectorTrace(OriginLocation,NewLocation)==true)	// N
		{
			Velocity -= YSpeed;
			Acceleration -= YSpeed;
		}
	}
}

defaultproperties
{
     ObjectMaterial=OBJ_Mineral
     Health=20
     Destroyable=True
     DestroyEffect=Class'CalyGame.RockExplosion'
     ChunkClass=Class'CalyGame.RockChunk'
     NumberOfChunks=4
     bPushable=True
     bGlides=True
     bRotates=True
     FrictionSlowdown=3.000000
     FallOffEdge=True
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     Texture=Texture'JazzObjectoids.Skins.Jplatform_01'
     Mesh=LodMesh'JazzObjectoids.rock1'
     CollisionRadius=30.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bBounce=True
}
