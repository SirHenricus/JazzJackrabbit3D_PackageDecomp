//=============================================================================
// splash1.
//=============================================================================
class splash1 expands JazzMeshes;

#exec MESH IMPORT MESH=splash1 ANIVFILE=MODELS\splash1_a.3d DATAFILE=MODELS\splash1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=splash1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=splash1 SEQ=All                      STARTFRAME=0 NUMFRAMES=40
#exec MESH SEQUENCE MESH=splash1 SEQ=splash1                  STARTFRAME=0 NUMFRAMES=40

#exec MESHMAP NEW   MESHMAP=splash1 MESH=splash1
#exec MESHMAP SCALE MESHMAP=splash1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jsplash1_01 FILE=Textures\splash1_01.PCX GROUP=Skins FLAGS=2	//twosided

#exec MESHMAP SETTEXTURE MESHMAP=splash1 NUM=1 TEXTURE=Jsplash1_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.splash1'
}
