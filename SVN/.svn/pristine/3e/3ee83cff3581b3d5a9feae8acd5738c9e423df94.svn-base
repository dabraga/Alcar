#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} FILRPR

Filtro para consulta padrão SA1RPR

@author Ectore Cecato - Totvs IP
@since 12/04/2018
@version Protheus 12 - Faturamento

/*/

User Function FILRPR()
	
	Local aArea		:= GetArea()
	Local aAreaSA3	:= SA3->(GetArea())
	Local cFilter 	:= ".T."
	Local cCodVend	:= AllTrim(UsrRetName(RetCodUsr()))
	
	DbSelectArea("SA3")
	
	SA3->(DbSetOrder(1))
	
	If SA3->(DbSeek(xFilial("SA3") + cCodVend))
		cFilter := "SA1->A1_VEND == '"+ cCodVend +"'"
	EndIf
		
	RestArea(aAreaSA3)
	RestArea(aArea)
	
Return cFilter