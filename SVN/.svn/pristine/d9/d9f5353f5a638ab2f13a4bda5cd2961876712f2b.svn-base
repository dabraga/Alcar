#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALC005

Relatório Faturamento Representante

@author Ectore Cecato - Totvs IP
@since 12/04/2018
@version Protheus 12 - Faturamento

/*/

User Function ALC005()
	
	Local cRelatorio	:= "ALC005"
	Local cTitulo		:= "Faturamento Representante"
	Local cOption		:= "1;0;1;"+ cTitulo
	Local cParametros	:= ""

	If Pergunte(cRelatorio, .T.)
	
		cParametros := MV_PAR01 +";"+ MV_PAR02 +";"+ DToS(MV_PAR03) +";"+ DToS(MV_PAR04)+";"+ AllTrim(UsrRetName(RetCodUsr()))
		
		CallCrys(cRelatorio, cParametros, cOption, .F., .T., .T.)
		
	EndIf

Return Nil