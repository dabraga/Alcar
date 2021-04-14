#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALC004

Relatório Estoque Eaton

@author Ectore Cecato - Totvs IP
@since 12/04/2018
@version Protheus 12 - Faturamento

/*/

User Function ALC004()
	
	Local cRelatorio	:= "ALC004"
	Local cTitulo		:= "Estoque Eaton"
	Local cOption		:= "1;0;1;"+ cTitulo
	Local cParametros	:= ""

	//If Pergunte(cRelatorio, .T.)
	
		//cParametros := MV_PAR01 +";"+ AllTrim(UsrRetName(RetCodUsr()))
		
		CallCrys(cRelatorio, cParametros, cOption, .F., .T., .T.)
		
	//EndIf

Return Nil