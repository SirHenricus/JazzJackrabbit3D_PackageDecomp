//=============================================================================
// taga.
//=============================================================================
class taga expands JazzMeshes;

#exec MESH IMPORT MESH=taga ANIVFILE=MODELS\taga_a.3d DATAFILE=MODELS\taga_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=taga X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=taga SEQ=All                      STARTFRAME=0   NUMFRAMES=336
#exec MESH SEQUENCE MESH=taga SEQ=still                    STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=taga SEQ=attack                   STARTFRAME=1   NUMFRAMES=30
#exec MESH SEQUENCE MESH=taga SEQ=dead1                    STARTFRAME=31  NUMFRAMES=40
#exec MESH SEQUENCE MESH=taga SEQ=fly                      STARTFRAME=71  NUMFRAMES=60
#exec MESH SEQUENCE MESH=taga SEQ=hit                      STARTFRAME=131 NUMFRAMES=25
#exec MESH SEQUENCE MESH=taga SEQ=hover                    STARTFRAME=156 NUMFRAMES=90
#exec MESH SEQUENCE MESH=taga SEQ=spin                     STARTFRAME=246 NUMFRAMES=60
#exec MESH SEQUENCE MESH=taga SEQ=takeoff                  STARTFRAME=306 NUMFRAMES=30

#exec MESHMAP NEW   MESHMAP=taga MESH=taga
#exec MESHMAP SCALE MESHMAP=taga X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=Jtaga_01 FILE=Textures\taga_01.PCX GROUP=Skins FLAGS=2	//twosided

#exec MESHMAP SETTEXTURE MESHMAP=taga NUM=1 TEXTURE=Jtaga_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.Taga'
}
