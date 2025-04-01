//=============================================================================
// Red Rocket.
//=============================================================================
class RedRocket expands JazzMeshes;

#ForceExec MESH IMPORT MESH=RedRocket ANIVFILE=..\MODELS\RedRocket_a.3d DATAFILE=..\MODELS\RedRocket_d.3d X=0 Y=0 Z=0
#ForceExec MESH ORIGIN MESH=RedRocket X=0 Y=0 Z=0 PITCH=-64 ROLL=0 YAW=0

#ForceExec MESH SEQUENCE MESH=RedRocket SEQ=All                      STARTFRAME=0 NUMFRAMES=15
#ForceExec MESH SEQUENCE MESH=RedRocket SEQ=static                   STARTFRAME=0 NUMFRAMES=15

#ForceExec MESHMAP NEW   MESHMAP=RedRocket MESH=RedRocket
#ForceExec MESHMAP SCALE MESHMAP=RedRocket X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=JRedRocket_01 FILE=Textures\..\RedRocket_01.PCX GROUP=Skins FLAGS=2	//Skin

#ForceExec MESHMAP SETTEXTURE MESHMAP=RedRocket NUM=0 TEXTURE=JRedRocket_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.RedRocket'
}
