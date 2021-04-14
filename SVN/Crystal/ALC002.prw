#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALC002

Relatório Movimentações de Operação Eaton

@author Ectore Cecato - Totvs IP
@since 12/04/2018
@version Protheus 12 - Faturamento

/*/

User Function ALC002()
	
	Local cRelatorio	:= "ALC002"
	Local cTitulo		:= "Movimentacoes Eaton"
	Local cOption		:= "1;0;1;"+ cTitulo
	Local cParametros	:= ""

	If Pergunte(cRelatorio, .T.)
	
		cParametros := DToS(MV_PAR01) +";"+ DToS(MV_PAR02) +";"+ MV_PAR03
		
		CallCrys(cRelatorio, cParametros, cOption, .F., .T., .T.)
		
	EndIf

Return Nil