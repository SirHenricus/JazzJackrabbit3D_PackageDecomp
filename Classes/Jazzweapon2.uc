//=============================================================================
// JazzWeapon2.
//=============================================================================
class JazzWeapon2 expands JazzMeshes;

#ForceExec MESH IMPORT MESH=JazzWeapon2 ANIVFILE=..\MODELS\JazzWeapon2_a.3d DATAFILE=..\MODELS\JazzWeapon2_d.3d X=0 Y=0 Z=0 Package=JazzObjectoids
#ForceExec MESH ORIGIN MESH=JazzWeapon2 X=0 Y=0 Z=0

#ForceExec MESH SEQUENCE MESH=JazzWeapon2 SEQ=All                      STARTFRAME=0 NUMFRAMES=10
#ForceExec MESH SEQUENCE MESH=JazzWeapon2 SEQ=Weaponanim               STARTFRAME=0 NUMFRAMES=9
#ForceExec MESH SEQUENCE MESH=JazzWeapon2 SEQ=Weaponidle               STARTFRAME=9 NUMFRAMES=1

#ForceExec MESHMAP NEW   MESHMAP=JazzWeapon2 MESH=JazzWeapon2
#ForceExec MESHMAP SCALE MESHMAP=JazzWeapon2 X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=JJazzWeapon2_01 FILE=..\Textures\JazzWeapon2_01.PCX GROUP=Skins FLAGS=2	//skin
#ForceExec TEXTURE IMPORT NAME=JJazzWeapon2_02 FILE=..\Textures\JazzWeapon2_02.PCX GROUP=Skins FLAGS=2	//Material #3

#ForceExec MESHMAP SETTEXTURE MESHMAP=JazzWeapon2 NUM=1 TEXTURE=JJazzWeapon2_01
#ForceExec MESHMAP SETTEXTURE MESHMAP=JazzWeapon2 NUM=2 TEXTURE=JJazzWeapon2_02

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.Jazzweapon2'
}
