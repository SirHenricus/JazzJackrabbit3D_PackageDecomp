//=============================================================================
// JazzNew.
//=============================================================================
class JazzNew expands JazzMeshes;

#ForceExec MESH IMPORT MESH=JazzNew ANIVFILE=..\MODELS\JazzNew_a.3d DATAFILE=..\MODELS\JazzNew_d.3d X=0 Y=0 Z=0 Package=Jazz3
#ForceExec MESH ORIGIN MESH=JazzNew X=0 Y=0 Z=0

#ForceExec SEQUENCE MESH=JazzNew SEQ=All                      	STARTFRAME=0 NUMFRAMES=1
#ForceExec SEQUENCE MESH=JazzNew SEQ=JazzNew               	STARTFRAME=0 NUMFRAMES=1

#ForceExec MESHMAP NEW   MESHMAP=JazzNew MESH=JazzNew
#ForceExec MESHMAP SCALE MESHMAP=JazzNew X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=JazzFurGreen       FILE=..\Textures\Jazz.BMP        FLAGS=2
#ForceExec MESHMAP SETTEXTURE MESHMAP=JazzNew NUM=0 TEXTURE=JazzFurGreen

defaultproperties
{
     DrawType=DT_Mesh
     Texture=Texture'JazzyTextures.plantwall1a'
     Mesh=LodMesh'Jazz3.JazzNew'
     DrawScale=50.000000
}
