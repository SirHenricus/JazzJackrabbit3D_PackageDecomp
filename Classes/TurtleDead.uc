//=============================================================================
// TurtleDead.
//=============================================================================
class TurtleDead expands JazzMeshes;

#ForceExec MESH IMPORT MESH=TurtleDead ANIVFILE=..\MODELS\TurtleDead_a.3d DATAFILE=..\MODELS\TurtleDead_d.3d X=0 Y=0 Z=0
#ForceExec MESH ORIGIN MESH=TurtleDead X=0 Y=0 Z=0

#ForceExec MESH SEQUENCE MESH=TurtleDead SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#ForceExec MESH SEQUENCE MESH=TurtleDead SEQ=TurtleDead 			   STARTFRAME=0 NUMFRAMES=1

#ForceExec MESHMAP NEW   MESHMAP=TurtleDead MESH=TurtleDead 
#ForceExec MESHMAP SCALE MESHMAP=TurtleDead X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=TurtleGreenDead FILE=..\Textures\TurtleGreenDead.PCX GROUP=Skins FLAGS=2

#ForceExec MESHMAP SETTEXTURE MESHMAP=TurtleDead NUM=0 TEXTURE=TurtleGreenDead

defaultproperties
{
}
