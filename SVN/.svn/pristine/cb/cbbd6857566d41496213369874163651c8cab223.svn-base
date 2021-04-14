#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} FILRPR

Filtro para consulta padrão SA1RPR

@author Ectore Cecato - Totvs IP
@since 12/04/2018
@version Protheus 12 - Faturamento

/*/

User Function VLDCLI(cCliente, cLoja)
	
	Local aArea		:= GetArea()
	Local aAreaSA3	:= SA3->(GetArea())
	Local lValid 	:= .T.
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local cCodVend	:= AllTrim(UsrRetName(RetCodUsr()))
	
	DbSelectArea("SA3")
	
	SA3->(DbSetOrder(1))
	
	If SA3->(DbSeek(xFilial("SA3") + cCodVend))
		
		cQuery := "SELECT "+ CRLF
		cQuery += "		A1_COD "+ CRLF
		cQuery += "FROM "+ RetSqlTab("SA1") +" "+ CRLF
		cQuery += "WHERE "+ CRLF
		cQuery += "		"+ RetSqlDel("SA1") +" "+ CRLF
		cQuery += "		AND "+ RetSqlFil("SA1") +" "+ CRLF
		cQuery += "		AND SA1.A1_COD = '"+ cCliente +"' "+ CRLF
		
		If !Empty(cLoja)
			cQuery += "		AND SA1.A1_LOJA = '"+ cLoja +"' "+ CRLF
		EndIf
		
		cQuery += "		AND SA1.A1_VEND = '"+ cCodVend +"' "
		cQuery := ChangeQuery(cQuery)
		
		MemoWrite("\SQL\VLDCLI.SQL", cQuery)
		
		DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
		
		If (cAliasQry)->(Eof())
			
			lValid := .F.
			
			MsgAlert("Cliente "+ cCliente +"/"+ cLoja +" não encontrado", "Atenção")
			
		EndIf
		
		(cAliasQry)->(DbCloseArea())
		
	EndIf     
	
	RestArea(aAreaSA3)
	RestArea(aArea)
	
Return lValid