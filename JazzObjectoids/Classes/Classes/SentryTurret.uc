//=============================================================================
// Sentry Turret.
//=============================================================================
class SentryTurret expands JazzMeshes;

#exec MESH IMPORT MESH=SentryTurret ANIVFILE=MODELS\SentryTurret_a.3d DATAFILE=MODELS\SentryTurret_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=SentryTurret X=0 Y=0 Z=200

#exec MESH SEQUENCE MESH=SentryTurret SEQ=All                      STARTFRAME=0 NUMFRAMES=15
#exec MESH SEQUENCE MESH=SentryTurret SEQ=spoot                    STARTFRAME=0 NUMFRAMES=15

#exec MESHMAP NEW   MESHMAP=SentryTurret MESH=Sentry Turret
#exec MESHMAP SCALE MESHMAP=SentryTurret X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JSentryTurret_01 FILE=Textures\SentryTurret_01.PCX GROUP=Skins FLAGS=2	//Skin

#exec MESHMAP SETTEXTURE MESHMAP=SentryTurret NUM=0 TEXTURE=JSentryTurret_01

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.SentryTurret'
}
