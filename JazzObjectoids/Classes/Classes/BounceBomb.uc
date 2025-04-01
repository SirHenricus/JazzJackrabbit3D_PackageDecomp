//=============================================================================
// Bounce Bomb.
//=============================================================================
class BounceBomb expands JazzMeshes;

#exec MESH IMPORT MESH=BounceBomb ANIVFILE=MODELS\BounceBomb_a.3d DATAFILE=MODELS\BounceBomb_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=BounceBomb X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=BounceBomb SEQ=All                      STARTFRAME=0 NUMFRAMES=15
#exec MESH SEQUENCE MESH=BounceBomb SEQ=static                   STARTFRAME=0 NUMFRAMES=15

#exec MESHMAP NEW   MESHMAP=BounceBomb MESH=BounceBomb
#exec MESHMAP SCALE MESHMAP=BounceBomb X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JBounceBomb_01 FILE=Textures\BounceBomb_01.PCX GROUP=Skins FLAGS=2	//Skin

#exec MESHMAP SETTEXTURE MESHMAP=BounceBomb NUM=0 TEXTURE=JBounceBomb_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.BounceBomb'
}
