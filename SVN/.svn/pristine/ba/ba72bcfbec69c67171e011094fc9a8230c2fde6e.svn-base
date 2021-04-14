#include 'protheus.ch'
#include 'parmtype.ch'

User function ClearSC9()
	
	Local aSays		:= {}
	Local aButtons	:= {}
	Local lImport	:= .F.
	Local cFile 	:= ""
	
	Aadd(aSays, "Rotina responsável pela correção da tabela SC9")
		
	Aadd(aButtons, {1, 	.T., {|o| lImport := .T., o:oWnd:End()}})
	Aadd(aButtons, {2, 	.T., {|o| o:oWnd:End()}})
	
	FormBatch("Correção SC9", aSays, aButtons)
	
	If lImport
		Processa({|| ProcessClearSC9()}, "Aguarde", "Corrigindo SC9", .F.)
	EndIf
		
return Nil

static function ProcessClearSC9()
	
	Local cQuery 	:= ""
	Local cQuery2	:= ""
	Local cAliasQry := GetNextAlias()
	Local cAliasQr2	:= ""
	Local nItem		:= 0
	
	ProcRegua(0)
	
	cQuery := "SELECT "
	cQuery += "		C9_FILIAL, C9_PEDIDO, C9_PRODUTO, C9_ITEM, C9_QTDLIB, C9_PRCVEN "
	cQuery += "FROM "+ RetSqlName("SC9") +" "
	cQuery += "WHERE "
	cQuery += "		D_E_L_E_T_ = '' AND C9_NFISCAL = '' AND C9_FILIAL = '01' "
	//cQuery += "		AND C9_PEDIDO = '028715' "
	cQuery += "GROUP BY "
	cQuery += "		C9_FILIAL, C9_PEDIDO, C9_PRODUTO, C9_ITEM, C9_QTDLIB, C9_PRCVEN "
	cQuery += "HAVING COUNT(*) > 1
	cQuery += "ORDER BY "
	cQuery += "		C9_FILIAL, C9_PEDIDO, C9_ITEM "
	
	DbUseArea( .T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	While !(cAliasQry)->(Eof())
		
		cAliasQr2 := GetNextAlias()
		
		cQuery2 := "SELECT "
		cQuery2 += "		R_E_C_N_O_ AS RECNO "  
		cQuery2 += "FROM "+ RetSqlName("SC9") +" "
		cQuery2 += "WHERE " 
		cQuery2 += "	D_E_L_E_T_ = '' AND C9_NFISCAL = '' AND C9_FILIAL = '01' "
		cQuery2 += "	AND C9_PEDIDO = '"+ (cAliasQry)->C9_PEDIDO +"' AND C9_ITEM = '"+ (cAliasQry)->C9_ITEM +"' "
		cQuery2 += "ORDER BY C9_FILIAL, C9_PEDIDO, C9_ITEM "
		
		DbUseArea( .T., "TOPCONN", TcGenQry(,, cQuery2), cAliasQr2, .F., .T.)
		
		nItem := 1
		
		While !(cAliasQr2)->(Eof())
			
			If nItem > 1
				
				cQueryUpd := "UPDATE SC9010 "
				cQueryUpd += "SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ "
				cQueryUpd += "WHERE R_E_C_N_O_ = "+ cValToChar((cAliasQr2)->RECNO) +" "
				
				If TcSqlExec(cQueryUpd) <> 0
					UserException(TCSQLError())
				Endif
						
			EndIf
			
			nItem++
			
			(cAliasQr2)->(DbSkip())
			
		EndDo
		
		(cAliasQr2)->(DbCloseArea())
		
		(cAliasQry)->(DbSkip())
		
	EndDo
	
	(cAliasQry)->(DbCloseArea())

Return Nil

