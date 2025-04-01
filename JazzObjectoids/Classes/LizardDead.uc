//=============================================================================
// LizardDead.
//=============================================================================
class LizardDead expands JazzMeshes;

#ForceExec MESH IMPORT MESH=LizardDead ANIVFILE=..\MODELS\LizardDead_a.3d DATAFILE=..\MODELS\LizardDead_d.3d X=0 Y=0 Z=0
#ForceExec MESH ORIGIN MESH=LizardDead X=0 Y=0 Z=0

#ForceExec MESH SEQUENCE MESH=LizardDead SEQ=All                      STARTFRAME=0 NUMFRAMES=1
#ForceExec MESH SEQUENCE MESH=LizardDead SEQ=LizardDead  		        STARTFRAME=0 NUMFRAMES=1

#ForceExec MESHMAP NEW   MESHMAP=LizardDead MESH=LizardDead
#ForceExec MESHMAP SCALE MESHMAP=LizardDead X=0.1 Y=0.1 Z=0.2

#ForceExec TEXTURE IMPORT NAME=JLizard_01 FILE=..\Textures\JLizard_01.PCX GROUP=Skins FLAGS=2

#ForceExec MESHMAP SETTEXTURE MESHMAP=LizardDead NUM=0 TEXTURE=JLizard_01

defaultproperties
{
}
