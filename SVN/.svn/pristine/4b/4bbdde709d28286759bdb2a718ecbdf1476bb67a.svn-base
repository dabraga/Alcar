#Include 'Protheus.ch'

/*/{Protheus.doc} ExistSC9

Programa que verifica se existe registro na tabela SC9

@type function
@author Ectore Cecato - Totvs Jundiaí
@since 13/05/2016
@version Protheus 12 - Faturamento

@param cSalesOrder, caracter, Pedido de venda
@param cItem, caracter, Item do pedido de venda
@param cProduct, caracter, Produto do pedido de venda
 
@return lógico, Indica que existe registro na tabela SC9

/*/

User Function ExistSC9(cSalesOrder, cItem, cProduct)
	
	Local lExist 	:= .F.
	Local cQuery 	:= ""
	Local cAliasQry := GetNextAlias()
	
	cQuery := "SELECT "
	cQuery += "		C9_PEDIDO "
	cQuery += "FROM "+ RetSqlName("SC9") +" "
	cQuery += "WHERE "
	cQuery += "		D_E_L_E_T_ = ' ' "
	cQuery += "		AND C9_FILIAL = '"+ xFilial("SC9") +"' "
	cQuery += "		AND C9_PEDIDO = '"+ cSalesOrder +"' "
	cQuery += "		AND C9_ITEM = '"+ cItem +"' "
	cQuery += "		AND C9_PRODUTO = '"+ cProduct +"' "
	cQuery += "		AND C9_NFISCAL = '' "
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		lExist := .T.
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return lExist 

