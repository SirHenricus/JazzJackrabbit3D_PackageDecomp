//=============================================================================
// JazzWeapon1.
//=============================================================================
class JazzWeapon1 expands JazzMeshes;

#ForceExec MESH IMPORT MESH=JazzWeapon1 ANIVFILE=..\MODELS\JazzWeapon1_a.3d DATAFILE=..\MODELS\JazzWeapon1_d.3d X=0 Y=0 Z=0 Package=JazzObjectoids
#ForceExec MESH ORIGIN MESH=JazzWeapon1 X=0 Y=0 Z=0

#ForceExec MESH SEQUENCE MESH=JazzWeapon1 SEQ=All                      STARTFRAME=0 NUMFRAMES=3
#ForceExec MESH SEQUENCE MESH=JazzWeapon1 SEQ=weaponanim               STARTFRAME=0 NUMFRAMES=1
#ForceExec MESH SEQUENCE MESH=JazzWeapon1 SEQ=weaponidle               STARTFRAME=1 NUMFRAMES=2

#ForceExec MESHMAP NEW   MESHMAP=JazzWeapon1 MESH=JazzWeapon1
#ForceExec MESHMAP SCALE MESHMAP=JazzWeapon1 X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=JJazzWeapon1_01 FILE=Textures\JazzWeapon1_01.PCX GROUP=Skins FLAGS=2	//Material #3
#ForceExec TEXTURE IMPORT NAME=JJazzWeapon1_02 FILE=Textures\JazzWeapon1_02.PCX GROUP=Skins FLAGS=2	//Material #1

#ForceExec MESHMAP SETTEXTURE MESHMAP=JazzWeapon1 NUM=1 TEXTURE=JJazzWeapon1_01
#ForceExec MESHMAP SETTEXTURE MESHMAP=JazzWeapon1 NUM=2 TEXTURE=JJazzWeapon1_02

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.JazzWeapon1'
}
