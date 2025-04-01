//=============================================================================
// expring.
//=============================================================================
class expring expands JazzMeshes;

#ForceExec MESH IMPORT MESH=expring ANIVFILE=..\MODELS\expring_a.3d DATAFILE=..\MODELS\expring_d.3d X=0 Y=0 Z=0
#ForceExec MESH ORIGIN MESH=expring X=0 Y=0 Z=0

#ForceExec MESH SEQUENCE MESH=expring SEQ=All                      STARTFRAME=0 NUMFRAMES=100
#ForceExec MESH SEQUENCE MESH=expring SEQ=expring                  STARTFRAME=0 NUMFRAMES=100

#ForceExec MESHMAP NEW   MESHMAP=expring MESH=expring
#ForceExec MESHMAP SCALE MESHMAP=expring X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=Jexpring_01 FILE=..\Textures\expring_01.PCX GROUP=Skins FLAGS=2	//Material #1

#ForceExec MESHMAP SETTEXTURE MESHMAP=expring NUM=1 TEXTURE=Jexpring_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.expring'
}
