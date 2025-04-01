//=============================================================================
// Sentry Base.
//=============================================================================
class SentryBase expands JazzMeshes;

#exec MESH IMPORT MESH=SentryBase ANIVFILE=MODELS\SentryBase_a.3d DATAFILE=MODELS\SentryBase_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SentryBase X=0 Y=0 Z=-140

#exec MESH SEQUENCE MESH=SentryBase SEQ=All                      STARTFRAME=0 NUMFRAMES=15
#exec MESH SEQUENCE MESH=SentryBase SEQ=static                   STARTFRAME=0 NUMFRAMES=15

#exec MESHMAP NEW   MESHMAP=SentryBase MESH=Sentry Base
#exec MESHMAP SCALE MESHMAP=SentryBase X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JSentryBase_01 FILE=Textures\SentryBase_01.PCX GROUP=Skins FLAGS=2	//Skin

#exec MESHMAP SETTEXTURE MESHMAP=SentryBase NUM=0 TEXTURE=JSentryBase_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.SentryBase'
}
