//=============================================================================
// Carrot.
//=============================================================================
class Carrot expands JazzMeshes;

#ForceExec MESH IMPORT MESH=Carrot ANIVFILE=..\MODELS\Carrot_a.3d DATAFILE=..\MODELS\Carrot_d.3d X=0 Y=0 Z=0
#ForceExec MESH ORIGIN MESH=Carrot X=0 Y=0 Z=0

#ForceExec MESH SEQUENCE MESH=Carrot SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#ForceExec MESH SEQUENCE MESH=Carrot SEQ=carrotup                 STARTFRAME=0 NUMFRAMES=1

#ForceExec MESHMAP NEW   MESHMAP=Carrot MESH=Carrot
#ForceExec MESHMAP SCALE MESHMAP=Carrot X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=JCarrotup_01 FILE=..\Textures\Carrotup_01.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#ForceExec MESHMAP SETTEXTURE MESHMAP=Carrot NUM=1 TEXTURE=JCarrotup_01

defaultproperties
{
}
