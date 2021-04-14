#Include "Protheus.ch"
#Include "Parmtype.ch"

User Function ALGFAT01()
	
	Local cUltNF 	:= ""
	Local cProd		:= M->C6_PRODUTO
	Local cCliente	:= M->C5_CLIENTE
	Local cLoja		:= M->C5_LOJACLI
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		SD2.D2_DOC, SD2.D2_SERIE, SD2.D2_EMISSAO, SD2.D2_PRCVEN "+ CRLF
	cQuery += "FROM "+ RetSqlTab("SF2") +" "+ CRLF
	cQuery += "		INNER JOIN "+ RetSqlTab("SD2") +" "
	cQuery += "			ON	"+ RetSqlDel("SD2") +" "
	cQuery += "				AND "+ RetSqlFil("SD2") +" "
	cQuery += "				AND SD2.D2_DOC = SF2.F2_DOC "
	cQuery += "				AND SD2.D2_SERIE = SF2.F2_SERIE "
	cQuery += "				AND SD2.D2_CLIENTE = SF2.F2_CLIENTE "
	cQuery += "				AND SD2.D2_LOJA = SF2.F2_LOJA "
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("SF2") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("SF2") +" "+ CRLF
	cQuery += "		AND SF2.F2_CLIENTE = '"+ cCliente +"' "+ CRLF
	cQuery += "		AND SF2.F2_LOJA = '"+ cLoja +"' "+ CRLF
	cQuery += "		AND SF2.F2_DUPL <> '' "+ CRLF
	cQuery += "		AND SD2.D2_COD = '"+ cProd +"' "+ CRLF
	cQuery += "ORDER BY "+ CRLF
	cQuery += "		SD2.D2_EMISSAO DESC "
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	TcSetField(cAliasQry, "D2_EMISSAO", "D", 08, 00)
	
	If !(cAliasQry)->(Eof())
		
		cUltNF := "NF "+ AllTrim((cAliasQry)->D2_DOC) +"/"+ AllTrim((cAliasQry)->D2_SERIE)
		cUltNF += " | Emissão: "+ DToC((cAliasQry)->D2_EMISSAO)
		cUltNF += " | Preço: "+ AllTrim(Transform((cAliasQry)->D2_PRCVEN, PesqPict("SD2", "D2_PRCVEN")))
		 
	EndIf
	
	//(cAliasQry)->(DbCloseArea())
	
Return cUltNF