//=============================================================================
// jazz.
//=============================================================================
class jazz expands PlayerPawn;

#ForceExec MESH IMPORT MESH=jazz ANIVFILE=..\MODELS\jazz_a.3d DATAFILE=..\MODELS\jazz_d.3d X=0 Y=0 Z=0 Package=Jazz3
#ForceExec MESH ORIGIN MESH=jazz X=0 Y=0 Z=0

#ForceExec MESH SEQUENCE MESH=jazz SEQ=All                      STARTFRAME=0 	NUMFRAMES=402
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzfall                 STARTFRAME=0 	NUMFRAMES=19	GROUP=Falling
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzfallshooting         STARTFRAME=19 	NUMFRAMES=19	GROUP=Falling
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzforwardjump          STARTFRAME=38 	NUMFRAMES=17	GROUP=Falling
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzidle1                STARTFRAME=55 	NUMFRAMES=29	GROUP=Waiting
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzledgegrab            STARTFRAME=84 	NUMFRAMES=10	GROUP=Ledge
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzledgehang            STARTFRAME=94 	NUMFRAMES=1	GROUP=Ledge
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzledgepullup          STARTFRAME=95 	NUMFRAMES=35	GROUP=Ledge
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzrun                  STARTFRAME=130 	NUMFRAMES=19	GROUP=Running
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzrunshooting          STARTFRAME=149 	NUMFRAMES=19	GROUP=Running
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzstill                STARTFRAME=168 	NUMFRAMES=1	GROUP=Waiting
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzswimforward          STARTFRAME=169 	NUMFRAMES=39	GROUP=Swimming
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzswimforwardshooting  STARTFRAME=208 	NUMFRAMES=40	GROUP=Swimming
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzland                 STARTFRAME=248 	NUMFRAMES=7	GROUP=Waiting
#ForceExec MESH SEQUENCE MESH=jazz SEQ=runbacknoshoot           STARTFRAME=255 	NUMFRAMES=19  	GROUP=Running
#ForceExec MESH SEQUENCE MESH=jazz SEQ=runbackshoot             STARTFRAME=274 	NUMFRAMES=19  	GROUP=Running
#ForceExec MESH SEQUENCE MESH=jazz SEQ=runleftnoshoot           STARTFRAME=293 	NUMFRAMES=19  	GROUP=Running
#ForceExec MESH SEQUENCE MESH=jazz SEQ=runleftshoot             STARTFRAME=312 	NUMFRAMES=19  	GROUP=Running
#ForceExec MESH SEQUENCE MESH=jazz SEQ=runrightnoshoot          STARTFRAME=331 	NUMFRAMES=19  	GROUP=Running
#ForceExec MESH SEQUENCE MESH=jazz SEQ=runrightshoot            STARTFRAME=350 	NUMFRAMES=19  	GROUP=Running
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzidle1shoot           STARTFRAME=369 	NUMFRAMES=29	GROUP=Waiting
#ForceExec MESH SEQUENCE MESH=jazz SEQ=jazzstillshoot           STARTFRAME=398 	NUMFRAMES=4	GROUP=Waiting
#ForceExec MESH SEQUENCE MESH=jazz SEQ=crouch		        STARTFRAME=402 	NUMFRAMES=2	GROUP=Waiting
#ForceExec MESH SEQUENCE MESH=jazz SEQ=crouchshoot	        STARTFRAME=404 	NUMFRAMES=2	GROUP=Waiting
#ForceExec MESH SEQUENCE MESH=jazz SEQ=flip	        	STARTFRAME=406 	NUMFRAMES=1	GROUP=Falling
#ForceExec MESH SEQUENCE MESH=jazz SEQ=stand		        STARTFRAME=407 	NUMFRAMES=2	GROUP=Waiting
#ForceExec MESH SEQUENCE MESH=jazz SEQ=standshoot	        STARTFRAME=409 	NUMFRAMES=2	GROUP=Waiting

#ForceExec MESH NOTIFY   MESH=Jazz SEQ=jazzrun		   	TIME=0.25			FUNCTION=FootStepRight
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=jazzrun		   	TIME=0.75			FUNCTION=FootStepLeft
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=jazzrunshooting	   	TIME=0.25			FUNCTION=FootStepRight
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=jazzrunshooting	   	TIME=0.75			FUNCTION=FootStepLeft
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runbackshoot		TIME=0.25			FUNCTION=FootStepRightBack
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runbackshoot		TIME=0.75			FUNCTION=FootStepLeftBack
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runbacknoshoot	   	TIME=0.25			FUNCTION=FootStepRightBack
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runbacknoshoot	   	TIME=0.75			FUNCTION=FootStepLeftBack
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runleftshoot		TIME=0.25			FUNCTION=FootStepRightLeft
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runleftshoot		TIME=0.75			FUNCTION=FootStepLeftLeft
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runleftnoshoot	   	TIME=0.25			FUNCTION=FootStepRightLeft
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runleftnoshoot	   	TIME=0.75			FUNCTION=FootStepLeftLeft
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runrightshoot		TIME=0.25			FUNCTION=FootStepRightRight
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runrightshoot		TIME=0.75			FUNCTION=FootStepLeftRight
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runrightnoshoot	   	TIME=0.25			FUNCTION=FootStepRightRight
#ForceExec MESH NOTIFY   MESH=Jazz SEQ=runrightnoshoot	   	TIME=0.75			FUNCTION=FootStepLeftRight

#ForceExec MESHMAP NEW   MESHMAP=jazz MESH=jazz
#ForceExec MESHMAP SCALE MESHMAP=jazz X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=Jjazz_01       FILE=..\Textures\jazz_01.PCX        FLAGS=2	//twosided
#ForceExec TEXTURE IMPORT NAME=Jjazz_02       FILE=..\Textures\jazz_02.PCX        FLAGS=2	//weapon
#exec TEXTURE IMPORT NAME=jazz_blue_bb 	 FILE=Textures\jazz_blue_bb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_blue_gb 	 FILE=Textures\jazz_blue_gb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_blue_pb 	 FILE=Textures\jazz_blue_pb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_blue_rb 	 FILE=Textures\jazz_blue_rb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_blue_yb 	 FILE=Textures\jazz_blue_yb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_green_bb  FILE=Textures\jazz_green_bb.pcx  FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_green_gb  FILE=Textures\jazz_green_gb.pcx  FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_green_pb  FILE=Textures\jazz_green_pb.pcx  FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_green_rb  FILE=Textures\jazz_green_rb.pcx  FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_green_yb  FILE=Textures\jazz_green_yb.pcx  FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_grey_bb 	 FILE=Textures\jazz_grey_bb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_grey_gb 	 FILE=Textures\jazz_grey_gb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_grey_pb 	 FILE=Textures\jazz_grey_pb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_grey_rb 	 FILE=Textures\jazz_grey_rb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_grey_yb 	 FILE=Textures\jazz_grey_yb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_purple_bb FILE=Textures\jazz_purple_bb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_purple_gb FILE=Textures\jazz_purple_gb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_purple_pb FILE=Textures\jazz_purple_pb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_purple_rb FILE=Textures\jazz_purple_rb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_purple_yb FILE=Textures\jazz_purple_yb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_red_bb 	 FILE=Textures\jazz_red_bb.pcx    FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_red_gb 	 FILE=Textures\jazz_red_gb.pcx    FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_red_pb 	 FILE=Textures\jazz_red_pb.pcx    FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_red_rb 	 FILE=Textures\jazz_red_rb.pcx    FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_red_yb 	 FILE=Textures\jazz_red_yb.pcx    FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_teal_bb 	 FILE=Textures\jazz_teal_bb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_teal_gb 	 FILE=Textures\jazz_teal_gb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_teal_pb 	 FILE=Textures\jazz_teal_pb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_teal_rb 	 FILE=Textures\jazz_teal_rb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_teal_yb 	 FILE=Textures\jazz_teal_yb.pcx   FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_yellow_bb FILE=Textures\jazz_yellow_bb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_yellow_gb FILE=Textures\jazz_yellow_gb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_yellow_pb FILE=Textures\jazz_yellow_pb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_yellow_rb FILE=Textures\jazz_yellow_rb.pcx FLAGS=2
#exec TEXTURE IMPORT NAME=jazz_yellow_yb FILE=Textures\jazz_yellow_yb.pcx FLAGS=2


#ForceExec MESHMAP SETTEXTURE MESHMAP=jazz NUM=0 TEXTURE=Jjazz_01
#ForceExec MESHMAP SETTEXTURE MESHMAP=jazz NUM=1 TEXTURE=Jjazz_01
#ForceExec MESHMAP SETTEXTURE MESHMAP=jazz NUM=2 TEXTURE=Jjazz_02

/*//
// Defines the animation and any overridden motion systems Jazz needs.
//
//

//-----------------------------------------------------------------------------
// Animation functions

function PlayTurning()
{
}

function TweenToWalking(float tweentime)
{
}

function TweenToRunning(float tweentime)
{
	TweenAnim('JazzRun',tweentime);
}

function PlayWalking()
{
	LoopAnim('JazzRun');
}

function PlayRunning()
{
	LoopAnim('JazzRun');
}

function PlayRising()
{
}

function PlayFeignDeath()
{
}

function PlayDying(name DamageType, vector HitLoc)
{
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
}
	
function PlayFlyingUp()
{
	LoopAnim('JazzFall');
}

function PlayFallingDown()
{
	LoopAnim('JazzFall');
}

function PlayDuck()
{
}

function PlayCrawling()
{
}

function TweenToWaiting(float tweentime)
{
	TweenAnim('JazzIdle1',tweentime);
}
	
function PlayWaiting()
{
	if (AnimSequence != 'JazzIdle1')
	LoopAnim('JazzIdle1');
}	

function PlayFiring()
{
}

function PlayWeaponSwitch(Weapon NewWeapon)
{
}

function PlaySwimming()
{
}

function TweenToSwimming(float tweentime)
{
}*/

defaultproperties
{
     JumpZ=700.000000
     BaseEyeHeight=-20.000000
     AnimSequence=jazzidle1
     AnimRate=0.200000
     DrawType=DT_Mesh
     Texture=Texture'Jazz3.Jjazz_01'
     Skin=Texture'Jazz3.Jjazz_01'
     Mesh=LodMesh'Jazz3.Jazz'
     CollisionRadius=20.000000
     CollisionHeight=40.000000
}
