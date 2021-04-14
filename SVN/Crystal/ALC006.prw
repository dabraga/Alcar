#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALC006

Relatório Carteira de Representante por Data

@author Ectore Cecato - Totvs IP
@since 12/04/2018
@version Protheus 12 - Faturamento

/*/

User Function ALC006()
	
	Local cRelatorio	:= "ALC006"
	Local cTitulo		:= "Carteira Representante por Data"
	Local cOption		:= "1;0;1;"+ cTitulo
	Local cParametros	:= ""

	If Pergunte(cRelatorio, .T.)
	
		cParametros := MV_PAR01 +";"+ MV_PAR02 +";"+ AllTrim(UsrRetName(RetCodUsr()))
		
		CallCrys(cRelatorio, cParametros, cOption, .F., .T., .T.)
		
	EndIf

Return Nil