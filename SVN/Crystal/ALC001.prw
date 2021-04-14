#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALC001

Relatório Acompanhamento Industrial

@author Ectore Cecato - Totvs IP
@since 12/04/2018
@version Protheus 12 - Faturamento

/*/

User Function ALC001()
	
	Local cRelatorio	:= "ALC001"
	Local cTitulo		:= "Acompanhamento Industrial"
	Local cOption		:= "1;0;1;"+ cTitulo
	Local cParametros	:= ""

	If Pergunte(cRelatorio, .T.)
		
		ConOut("RELATORIO - ALC001")
		ConOut("Parametro 1 - "+ MV_PAR01)
		ConOut("Parametro 2 - "+ AllTrim(UsrRetName(RetCodUsr())))
		
		cParametros := MV_PAR01 +";"+ AllTrim(UsrRetName(RetCodUsr()))
		
		CallCrys(cRelatorio, cParametros, cOption, .F., .T., .T.)
		
		ConOut("RELATORIO - ALC001")
		
	EndIf

Return Nil