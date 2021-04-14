#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALC003

Relatório Carteira de Representante

@author Ectore Cecato - Totvs IP
@since 12/04/2018
@version Protheus 12 - Faturamento

/*/

User Function ALC003()
	
	Local cRelatorio	:= "ALC003"
	Local cTitulo		:= "Carteira Representante"
	Local cOption		:= "1;0;1;"+ cTitulo
	Local cParametros	:= ""

	If Pergunte(cRelatorio, .T.)
	
		cParametros := MV_PAR01 +";"+ MV_PAR02 +";"+ AllTrim(UsrRetName(RetCodUsr()))
		
		CallCrys(cRelatorio, cParametros, cOption, .F., .T., .T.)
		
	EndIf

Return Nil