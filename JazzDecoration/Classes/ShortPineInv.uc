//=============================================================================
// ShortPineInv.
//=============================================================================
class ShortPineInv expands JazzDecoration;

#ForceExec MESH IMPORT MESH=ShortPineInv ANIVFILE=..\MODELS\ShortPineInv_a.3d DATAFILE=..\MODELS\ShortPineInv_d.3d X=0 Y=0 Z=0
#ForceExec MESH ORIGIN MESH=ShortPineInv X=0 Y=0 Z=0

#ForceExec MESH SEQUENCE MESH=ShortPineInv SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#ForceExec MESH SEQUENCE MESH=ShortPineInv SEQ=ShortPineInv			   STARTFRAME=0 NUMFRAMES=1

#ForceExec MESHMAP NEW   MESHMAP=ShortPineInv MESH=ShortPineInv
#ForceExec MESHMAP SCALE MESHMAP=ShortPineInv X=0.1 Y=0.1 Z=0.2

#exec TEXTURE IMPORT NAME=JShortpine1_01 FILE=..\Textures\Shortpine1_01.PCX GROUP=Skins FLAGS=2	//SKIN
#exec TEXTURE IMPORT NAME=JShortpine1_02 FILE=..\Textures\Shortpine1_02.PCX GROUP=Skins FLAGS=2	//TWOSIDED

#ForceExec MESHMAP SETTEXTURE MESHMAP=ShortPineInv NUM=0 TEXTURE=JShortpine1_01
#ForceExec MESHMAP SETTEXTURE MESHMAP=ShortPineInv NUM=1 TEXTURE=JShortpine1_02

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzDecoration.ShortPineInv'
     DrawScale=3.000000
     MultiSkins(0)=Texture'JazzyTextures.Wood2'
     MultiSkins(1)=Texture'JazzDecoration.Skins.JShortpine1_02'
     CollisionHeight=150.000000
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
}
