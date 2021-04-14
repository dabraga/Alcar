#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} ALC008

Relatório Estoque Filial 03 - Caxias do Sul

@author Malcon Mazzucatto - Alcar Abrasivos
@since 12/04/2018
@version Protheus 12 - Faturamento

/*/

User Function ALC008()
	
	Local cRelatorio	:= "ALC008"
	Local cTitulo		:= "Estoque Filial 03"
	Local cOption		:= "1;0;1;"+ cTitulo
	Local cParametros	:= ""

	//If Pergunte(cRelatorio, .T.)
	
		//cParametros := MV_PAR01 +";"+ AllTrim(UsrRetName(RetCodUsr()))
		
		CallCrys(cRelatorio, cParametros, cOption, .F., .T., .T.)
		
	//EndIf

Return Nil