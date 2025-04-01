//=============================================================================
// npc1.
//=============================================================================
class npc1 expands JazzMeshes;

#ForceExec MESH IMPORT MESH=npc1 ANIVFILE=..\MODELS\npc1_a.3d DATAFILE=..\MODELS\npc1_d.3d X=0 Y=0 Z=0
#ForceExec MESH LODPARAMS MESH=npc1 ZDisp=200
#ForceExec MESH ORIGIN MESH=npc1 X=0 Y=0 Z=50

#ForceExec MESH SEQUENCE MESH=npc1 SEQ=All                      STARTFRAME=0 NUMFRAMES=229
#ForceExec MESH SEQUENCE MESH=npc1 SEQ=idle1                    STARTFRAME=0 NUMFRAMES=84
#ForceExec MESH SEQUENCE MESH=npc1 SEQ=still                    STARTFRAME=84 NUMFRAMES=1
#ForceExec MESH SEQUENCE MESH=npc1 SEQ=walk                     STARTFRAME=85 NUMFRAMES=30
#ForceExec MESH SEQUENCE MESH=npc1 SEQ=starttalk                STARTFRAME=115 NUMFRAMES=30
#ForceExec MESH SEQUENCE MESH=npc1 SEQ=talking                  STARTFRAME=145 NUMFRAMES=68
#ForceExec MESH SEQUENCE MESH=npc1 SEQ=shotat                   STARTFRAME=213 NUMFRAMES=16

#ForceExec MESHMAP NEW   MESHMAP=npc1 MESH=npc1
#ForceExec MESHMAP SCALE MESHMAP=npc1 X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=Jnpc1_01 FILE=..\Textures\npc1_01.PCX GROUP=Skins FLAGS=2	//Material #1
#ForceExec TEXTURE IMPORT NAME=Jnpc2_01 FILE=..\Textures\npc2_01.PCX GROUP=Skins FLAGS=2	// NPC Type 2
#ForceExec TEXTURE IMPORT NAME=Jnpc3_01 FILE=..\Textures\npc3_01.PCX GROUP=Skins FLAGS=2	// NPC Type 3

#ForceExec MESHMAP SETTEXTURE MESHMAP=npc1 NUM=0 TEXTURE=Jnpc1_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.NPC1'
}
