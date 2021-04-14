#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALC011

Relatório Conferencia Terceiros Eaton

@author Malcon Mazzucatto - Alcar Abrasivos
@since 04/09/2019
@version Protheus 12.1.017 - Faturamento

/*/

User Function ALC011()
	
	Local cRelatorio	:= "ALC011"
	Local cTitulo		:= "Conf. Terceiros Eaton"
	Local cOption		:= "1;0;1;"+ cTitulo
	Local cParametros	:= ""

	//If Pergunte(cRelatorio, .T.)
	
		//cParametros := MV_PAR01 +";"+ AllTrim(UsrRetName(RetCodUsr()))
		
		CallCrys(cRelatorio, cParametros, cOption, .F., .T., .T.)
		
	//EndIf

Return Nil