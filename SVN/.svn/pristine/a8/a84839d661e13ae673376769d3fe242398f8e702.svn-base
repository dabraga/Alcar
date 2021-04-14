#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} MA410LEG

Ponto de entrada responsável pela inclusão de cores na legenda do pedido de venda

@type function
@author Ectore Cecato - Totvs Jundiaí
@since 06/08/2018
@version Protheus 12 - Faturamento

@return Array, Novas cores da legenda [aNewColor]

@see Verificar fonte ALAFAT02.PRW

/*/

User Function MA410COR()

	Local aNewColor := aClone(ParamIXB)
	
	If ExistBlock("ALAFAT02")
		aNewColor := ExecBlock("ALAFAT02", .F., .F., ParamIXB)
	EndIf
		
Return aNewColor