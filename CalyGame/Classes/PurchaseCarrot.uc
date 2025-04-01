//=============================================================================
// PurchaseCarrot.
//=============================================================================
class PurchaseCarrot expands GlowingPurchaseObject;

// What to do to the player when a purchase is done
function PurchaseFunction( actor Other )
{
	JazzPlayer(Other).AddHealth(25);
}

defaultproperties
{
     CostInCoins=5
     DrawType=DT_Mesh
     Mesh=LodMesh'JazzObjectoids.Carrot'
     DrawScale=1.500000
}
