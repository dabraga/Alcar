#Include "Protheus.ch"
#Include "ParmType.ch"
#Include "FWMVCDEF.CH"

/*/{Protheus.doc} OM010TOK

Ponto de entrada responsável pela validação da tabela de preço (Venda)

@type 		function
@author 	Ectore Cecato - Totvs Jundiaí
@since 		25/01/2019
@version 	Protheus 12 - Faturamento

@return lógico, Tabela válida

/*/

User Function OM010TOK()
	
	Local lRet 	 	:= .T.
	Local oModel 	:= ParamIXB[1]
	Local oMdlDA0	:= oModel:GetModel("DA0MASTER")
	Local cCliente	:= oMdlDA0:GetValue("DA0_ZZCLIE")
	
	If oModel:GetOperation() == MODEL_OPERATION_INSERT .And. !TabCli(cCliente)
		
		lRet := .F.
		
		Help(,, "HELP",, "Já existe tabela cadastrada para o cliente "+ cCliente, 1, 0,,,,,, {"Altere/exclua a tabela cadastrada"})
		
	EndIf
	
Return lRet 

Static Function TabCli(cCliente)
	
	Local lRet 	 := .T.
	Local cQuery := ""
	Local cAlias := GetNextAlias()
	
	cQuery := "SELECT "+ CRLF
	cQuery += "		DA0_CODTAB "+ CRLF
	cQuery += "FROM "+ RetSqlTab("DA0") +" "+ CRLF
	cQuery += "WHERE "+ CRLF
	cQuery += "		"+ RetSqlDel("DA0") +" "+ CRLF
	cQuery += "		AND "+ RetSqlFil("DA0") +" "+ CRLF
	cQuery += "		AND DA0.DA0_ZZCLIE = '"+ cCliente +"' "	
	
	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAlias, .F., .T.)
	
	If !(cAlias)->(Eof())
		lRet := .F.
	EndIf
	
	(cAlias)->(DbCloseArea())
	
Return lRet