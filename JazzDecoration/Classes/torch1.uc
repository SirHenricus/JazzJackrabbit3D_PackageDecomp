//=============================================================================
// torch1.
//=============================================================================
class torch1 expands Actor;

#exec MESH IMPORT MESH=torch1 ANIVFILE=MODELS\torch1_a.3d DATAFILE=MODELS\torch1_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=torch1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=torch1 SEQ=All                   STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=torch1 SEQ=torch1                STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=torch1 MESH=torch1
#exec MESHMAP SCALE MESHMAP=torch1 X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jtorch1_01 FILE=Textures\torch1_01.PCX GROUP=Skins FLAGS=2	//twosided

#exec MESHMAP SETTEXTURE MESHMAP=torch1 NUM=1 TEXTURE=Jtorch1_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzDecoration.torch1'
}
