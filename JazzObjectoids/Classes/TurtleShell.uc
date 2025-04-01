//=============================================================================
// TurtleShell.
//=============================================================================
class TurtleShell expands JazzMeshes;

#ForceExec MESH IMPORT MESH=TurtleShell ANIVFILE=..\MODELS\TurtleShell_a.3d DATAFILE=..\MODELS\TurtleShell_d.3d X=0 Y=0 Z=0
#ForceExec MESH ORIGIN MESH=TurtleShell X=0 Y=0 Z=0 PITCH=0 ROLL=64 YAW=0

#ForceExec MESH SEQUENCE MESH=TurtleShell SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#ForceExec MESH SEQUENCE MESH=TurtleShell SEQ=TurtleShell			   STARTFRAME=0 NUMFRAMES=1

#ForceExec MESHMAP NEW   MESHMAP=TurtleShell MESH=TurtleShell
#ForceExec MESHMAP SCALE MESHMAP=TurtleShell X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=TurtleGreenDead FILE=..\Textures\TurtleGreenDead.PCX GROUP=Skins FLAGS=2

#ForceExec MESHMAP SETTEXTURE MESHMAP=TurtleShell NUM=0 TEXTURE=TurtleGreenDead

defaultproperties
{
     DrawType=DT_Mesh
     Skin=Texture'JazzEnemy.Skins.TurtleGreenDead'
     Mesh=LodMesh'JazzObjectoids.TurtleShell'
}
