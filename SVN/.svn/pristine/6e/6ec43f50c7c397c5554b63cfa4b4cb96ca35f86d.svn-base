#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALC009

Acompanhamento Industrial

@author Malcon Mazzucatto - Alcar Abrasivos
@since 12/04/2018
@version Protheus 12 - Faturamento

/*/

User Function ALC009()
	
	Local cRelatorio	:= "ALC009"
	Local cTitulo		:= "Acompanhamento Industrial"
	Local cOption		:= "1;0;1;"+ cTitulo
	Local cParametros	:= ""

	//If Pergunte(cRelatorio, .T.)
	
		//cParametros := MV_PAR01 +";"+ AllTrim(UsrRetName(RetCodUsr()))
		
		CallCrys(cRelatorio, cParametros, cOption, .F., .T., .T.)
		
	//EndIf

Return Nil