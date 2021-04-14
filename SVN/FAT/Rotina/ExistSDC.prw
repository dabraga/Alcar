#Include 'Protheus.ch'

/*/{Protheus.doc} ExistSDC

Programa que verifica se existe registro na tabela SDC

@type function
@author Ectore Cecato - Totvs Jundiaí
@since 13/05/2016
@version Protheus 12 - Faturamento

@param cSalesOrder, caracter, Pedido de venda
@param cItem, caracter, Item do pedido de venda
@param cProduct, caracter, Produto do pedido de venda
 
@return lógico, Indica que existe registro na tabela SDC

/*/

User Function ExistSDC(cSalesOrder, cItem, cProduct)
	
	Local lExist 	:= .F.
	Local cQuery 	:= ""
	Local cAliasQry := GetNextAlias()
	
	cQuery := "SELECT "
	cQuery += "		DC_PEDIDO "
	cQuery += "FROM "+ RetSqlName("SDC") +" "
	cQuery += "WHERE "
	cQuery += "		D_E_L_E_T_ = ' ' "
	cQuery += "		AND DC_FILIAL = '"+ xFilial("SDC") +"' "
	cQuery += "		AND DC_PEDIDO = '"+ cSalesOrder +"' "
	cQuery += "		AND DC_ITEM = '"+ cItem +"' "
	cQuery += "		AND DC_PRODUTO = '"+ cProduct +"' "
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof())
		lExist := .T.
	EndIf
	
	(cAliasQry)->(DbCloseArea())
	
Return lExist

