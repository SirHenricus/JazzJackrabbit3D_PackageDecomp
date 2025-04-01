//=============================================================================
// Homing Rocket.
//=============================================================================
class HomingRocket expands JazzMeshes;

#ForceExec MESH IMPORT MESH=HomingRocket ANIVFILE=..\MODELS\HomingRocket_a.3d DATAFILE=..\MODELS\HomingRocket_d.3d X=0 Y=0 Z=0
#ForceExec MESH ORIGIN MESH=HomingRocket X=0 Y=0 Z=0 PITCH=-64 ROLL=0 YAW=0

#ForceExec MESH SEQUENCE MESH=HomingRocket SEQ=All                      STARTFRAME=0 NUMFRAMES=15
#ForceExec MESH SEQUENCE MESH=HomingRocket SEQ=static                   STARTFRAME=0 NUMFRAMES=15

#ForceExec MESHMAP NEW   MESHMAP=HomingRocket MESH=Homing Rocket
#ForceExec MESHMAP SCALE MESHMAP=HomingRocket X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=JHomingRocket_01 FILE=..\Textures\HomingRocket_01.PCX GROUP=Skins FLAGS=2	//Skin

#ForceExec MESHMAP SETTEXTURE MESHMAP=HomingRocket NUM=0 TEXTURE=JHomingRocket_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.HomingRocket'
}
