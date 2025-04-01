//=============================================================================
// palmtree1.
//=============================================================================
class palmtree1 expands JazzDecoration;

#ForceExec MESH IMPORT MESH=palmtree1 ANIVFILE=..\MODELS\palmtree1_a.3d DATAFILE=..\MODELS\palmtree1_d.3d X=0 Y=10 Z=0
#ForceExec MESH ORIGIN MESH=palmtree1 X=0 Y=0 Z=0

#ForceExec MESH SEQUENCE MESH=palmtree1 SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#ForceExec MESH SEQUENCE MESH=palmtree1 SEQ=palmtree1                STARTFRAME=0 NUMFRAMES=1

#ForceExec MESHMAP NEW   MESHMAP=palmtree1 MESH=palmtree1
#ForceExec MESHMAP SCALE MESHMAP=palmtree1 X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=Jpalmtree1_01 FILE=..\Textures\palmtree1_01.PCX GROUP=Skins FLAGS=2	//SKIN
#ForceExec TEXTURE IMPORT NAME=Jpalmtree1_02 FILE=..\Textures\palmtree1_02.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#ForceExec MESHMAP SETTEXTURE MESHMAP=palmtree1 NUM=0 TEXTURE=Jpalmtree1_01
#ForceExec MESHMAP SETTEXTURE MESHMAP=palmtree1 NUM=1 TEXTURE=Jpalmtree1_02

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzDecoration.palmtree1'
     DrawScale=2.000000
     MultiSkins(0)=Texture'JazzDecoration.Skins.Jpalmtree1_01'
     MultiSkins(1)=Texture'JazzDecoration.Skins.Jpalmtree1_02'
     CollisionRadius=15.000000
     CollisionHeight=65.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
