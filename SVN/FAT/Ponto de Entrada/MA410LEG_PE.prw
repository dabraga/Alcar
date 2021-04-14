#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} MA410LEG

Ponto de entrada responsável pela inclusão de cores na legenda do pedido de venda

@type function
@author Ectore Cecato - Totvs Jundiaí
@since 13/04/2017
@version Protheus 12 - Faturamento

@return Array, Novas cores da legenda [aNewLeg]

@see Verificar fonte BHAFAT01

/*/

User Function MA410LEG()

	Local aNewLeg := {}
	
	If ExistBlock("BHAFAT01")
		aNewLeg := ExecBlock("BHAFAT01", .F., .F., ParamIXB)
	EndIf
	
Return aNewLeg