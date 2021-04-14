#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALC007

Relatório Carteira de Representante Sul

@author Malcon Mazzucatto - Alcar Abrasivos
@since 07/11/2018
@version Protheus 12 - Faturamento

/*/

User Function ALC007()
	
	Local cRelatorio	:= "ALC007"
	Local cTitulo		:= "Carteira Representante Sul"
	Local cOption		:= "1;0;1;"+ cTitulo
	Local cParametros	:= ""

	If Pergunte(cRelatorio, .T.)
	
		cParametros := MV_PAR01 +";"+ MV_PAR02 +";"+ AllTrim(UsrRetName(RetCodUsr()))
		
		CallCrys(cRelatorio, cParametros, cOption, .F., .T., .T.)
		
	EndIf

Return Nil