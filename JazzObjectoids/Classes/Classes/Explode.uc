//=============================================================================
// explode.
//=============================================================================
class explode expands JazzMeshes;

#exec MESH IMPORT MESH=explode ANIVFILE=MODELS\explode_a.3d DATAFILE=MODELS\explode_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=explode X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=explode SEQ=All                      STARTFRAME=0 NUMFRAMES=30
#exec MESH SEQUENCE MESH=explode SEQ=explode                  STARTFRAME=0 NUMFRAMES=30

#exec MESHMAP NEW   MESHMAP=explode MESH=explode
#exec MESHMAP SCALE MESHMAP=explode X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jexplode_01 FILE=Textures\explode_01.PCX GROUP=Skins FLAGS=2	//Material #1
#exec TEXTURE IMPORT NAME=Jexplode_02 FILE=Textures\explode_02.PCX GROUP=Skins FLAGS=2	//DEFAULT
#exec TEXTURE IMPORT NAME=Jexplode_03 FILE=Textures\explode_03.PCX GROUP=Skins FLAGS=2	//Material #2

#exec MESHMAP SETTEXTURE MESHMAP=explode NUM=1 TEXTURE=Jexplode_01
#exec MESHMAP SETTEXTURE MESHMAP=explode NUM=2 TEXTURE=Jexplode_02
#exec MESHMAP SETTEXTURE MESHMAP=explode NUM=3 TEXTURE=Jexplode_03

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.Explode'
}
