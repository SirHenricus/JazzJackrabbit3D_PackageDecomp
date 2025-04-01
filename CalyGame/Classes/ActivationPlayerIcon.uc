//=============================================================================
// ActivationPlayerIcon.
//=============================================================================
class ActivationPlayerIcon expands JazzEffects;

//
// This icon is intended to display above any object or person that can be activated.  While
// it may not be used ultimately, it may be quite interesting if done well.
//
//

var 	actor	Focus;
var		float	ActivationTime;

// Set initially to hidden when created
//
function PreBeginPlay()
{
	local rotator Rot;

	Rot.Pitch = 65536/2;
	SetRotation(Rot);
	
	//bHidden = true;

	Hide();
}

// Set to show over an actor
//
function Show ( actor Other )
{
	local vector V;

	Focus = Other;
	//bHidden = false;
	
	//Log("DisplayActivationIcon) "$Other);
}

function Hide ()
{
	//bHidden = true;
	Focus = None;
}

event Tick ( float DeltaTime )
{
	local vector V;
	local rotator NewRotation;
	NewRotation = Rotation;
	
	// Patch change - the icon now has a nice transition between
	if (Focus != None)
	{
		bHidden = false;
		LightRadius += ( 32 - LightRadius ) * 0.1;
		LightBrightness += ( 64 - LightBrightness ) * 0.1;
		LightType = LT_Steady;
		
		DrawScale += ( 0.2 - DrawScale) * 0.1;
		//SoundVolume += (40 - SoundVolume) * 0.1;
	}
	else
	{
		LightRadius += ( -1 - LightRadius ) * 0.1;
		LightBrightness += ( -1 - LightBrightness ) * 0.1;
		LightType = LT_Steady;

		DrawScale += (-0.1 - DrawScale) * 0.1;
		if (DrawScale <= 0)
		{ bHidden = true; SoundVolume = 0; }//LightType = LT_None; }
		//SoundVolume = SoundVolume * 0.1;
	}
	
	
	// Display activation icon
	//
	if (bHidden == false)
	{
		// Patch change - rotate the icon!
		NewRotation.Yaw += 250;
	
		ActivationTime = ActivationTime + DeltaTime;
		V = Focus.Location;
		V.Z += Focus.CollisionHeight + 35 + sin(ActivationTime*2)*2.5;
		//LightBrightness = sin(ActivationTime*1.5)*200;
		//LightType = LT_Steady;
		SetLocation(V);
	}
	else
	{ NewRotation.Yaw = 0; }
	
	SetRotation(NewRotation);
}


//
// Pass on Activation Event
//
function DoActivate ()
{
	//Log("ActivationIcon) Activate Passthru "$Focus);
	if (Focus != None)
	Focus.Trigger(Self,Pawn(Owner));
	
	//
	// A Trigger whose Other component is of type ActivationPlayerIcon must be an
	// activation request to the item or NPC.
	//
}

defaultproperties
{
     DrawType=DT_Mesh
     Texture=Texture'JazzSpecial.gem3_01'
     Skin=Texture'JazzSpecial.gem3_01'
     Mesh=LodMesh'JazzObjectoids.Arrow'
     DrawScale=0.250000
     bUnlit=True
     bMeshEnviroMap=True
     SoundVolume=0
     AmbientSound=Sound'JazzSounds.Event.gemhit'
     LightType=LT_SubtlePulse
     LightEffect=LE_TorchWaver
     LightHue=204
     LightSaturation=102
     LightRadius=15
}
