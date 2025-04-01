//=============================================================================
// explode2.
//=============================================================================
class explode2 expands JazzMeshes;

#exec MESH IMPORT MESH=explode2 ANIVFILE=MODELS\explode2_a.3d DATAFILE=MODELS\explode2_d.3d X=0 Y=0 Z=0
#exec MESH LODPARAMS MESH=explode2 ZDisp=200
#exec MESH ORIGIN MESH=explode2 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=explode2 SEQ=All                      STARTFRAME=0 NUMFRAMES=40
#exec MESH SEQUENCE MESH=explode2 SEQ=explode2                 STARTFRAME=0 NUMFRAMES=40

#exec MESHMAP NEW   MESHMAP=explode2 MESH=explode2
#exec MESHMAP SCALE MESHMAP=explode2 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jexplode2_01 FILE=Textures\explode2_01.PCX GROUP=Skins FLAGS=2	//Material #1
#exec TEXTURE IMPORT NAME=Jexplode2_02 FILE=Textures\explode2_02.PCX GROUP=Skins FLAGS=2	//Material #2
#exec TEXTURE IMPORT NAME=Jexplode2_03 FILE=Textures\explode2_03.PCX GROUP=Skins FLAGS=2	//Material 1

#exec MESHMAP SETTEXTURE MESHMAP=explode2 NUM=1 TEXTURE=Jexplode2_01
#exec MESHMAP SETTEXTURE MESHMAP=explode2 NUM=2 TEXTURE=Jexplode2_02
#exec MESHMAP SETTEXTURE MESHMAP=explode2 NUM=3 TEXTURE=Jexplode2_03

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.explode2'
}
