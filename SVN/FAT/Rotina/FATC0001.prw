#Include "protheus.ch"
#Define cEOL CHR(13) + CHR(10)

/*	
	Função		:	FATC0001
	Autor		:	Ademar Pereira da Silva Junior
	Data		:	07/04/2015
	Descricao	:	Browse liberacao pv regras preço
*/

User Function FATC0001()

	Local aCores  := {}	            
	Local cFilter := "C5_ZZBLOQ = 'S' AND (C5_NOTA = '' OR C5_LIBEROK <> 'E' AND C5_BLQ <> '')"
	 
	Private aBrowse		:= {}
	Private	cCadastro 	:= "Liberação de Preço"
	Private aRotina     := {{"Pesquisar",		"AxPesqui",	  0, 1}, ;
							{"Visualizar",		"A410Visual", 0, 2}, ;
							{"Legenda",			"U_FATL0001", 0, 3}, ;
							{"Liberar Preço",	"U_ExcLib()", 0, 4}}
		
	aAdd(aCores, {"C5_ZZBLOQ == 'S'", "BR_VERMELHO"})
	aAdd(aCores, {"C5_ZZBLOQ == 'N' .OR. C5_ZZBLOQ == ' '", "BR_VERDE"})

	mBrowse(6, 1, 22, 75, "SC5",,,,,, aCores,,,,,,,, cFilter)
	
Return                                


/*
	Realiza a liberação do pedido de venda
*/
User Function ExcLib()  
    
    Local aArea		:= Lj7GetArea({"SC5", "SC6", "SC6"})     
	Local oObjBrow 	:= GetObjBrow()
	Local CodUsu    := UsrRetName(RetCodUsr())
	
	If ValidUser()
		
		If SC5->C5_ZZBLOQ == "S"
		
			If RecordObs() //If Aviso("Atenção","Confimar a liberação do pedido " + AllTrim(SC5->C5_NUM) + "?", {"SIM", "NÃO"}) == 1
				
				//Libera pedido de venda por regra
				RecLock("SC5",.F.)
					SC5->C5_ZZBLOQ := "N"
				SC5->(MsUnLock())
				
				DbSelectArea("SC6")
				
				SC6->(DbSetOrder(1))
				
				If SC6->(DbSeek(xFilial("SC6")+SC5->C5_NUM))
				
					While SC6->(!Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
						
						nPosItem := aScan(aBrowse, {|x| AllTrim(x[2]) == AllTrim(SC6->C6_ITEM)})
						
						RecLock("SC6", .F.)
							SC6->C6_ZZBLOQ  := "N"
							SC6->C6_ZZLIBPR := CodUsu//UsrRetName(RetCodUsr())
							SC6->C6_ZZDTPRC := dDataBase
							SC6->C6_ZZHRPRC := Time()
							
							If nPosItem > 0
								SC6->C6_ZZOBSPR := AllTrim(aBrowse[nPosItem, 10])
							EndIf
							
						SC6->(MsUnlock())
						
						SC6->(DbSkip())
						
					EndDo
				
				EndIf							
								
				DbSelectArea("SC9")
				
				SC9->(DbSetOrder(1))
				
				If SC9->(DbSeek(xFilial("SC9") + SC5->C5_NUM))
				
					While SC9->(!EOF()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == SC5->C5_NUM
						
						RecLock("SC9", .F.)
							SC9->C9_ZZBLOQ := "N"
						SC9->(MsUnlock())
						
						SC9->(DbSkip())
						
					EndDo
				
				EndIf			
				
			EndIf
		Else
			Aviso("Atenção","Pedido de venda já liberado",{"OK"})
		EndIf	                                                 

	EndIf
	
	oObjBrow:Refresh()
	
	Lj7RestArea(aArea)
	
Return

/*
	Verifica permissão de liberação do usuário
*/
Static Function ValidUser()

	Local cUserLib	:= AllTrim(UsrRetName(RetCodUsr()))
	Local cUsrLib1	:= AllTrim(GetMV("ZZ_USRLIB1"))  //Usuário liberação nível 1 (Usuário)
	Local cUsrLib2	:= AllTrim(GetMV("ZZ_USRLIB2"))  //Usuário liberação nível 2 (Gerência)
	Local cUsrLib3	:= AllTrim(GetMV("ZZ_USRLIB3"))  //Usuário liberação nível 3 (Diretoria)
	Local cQuery 	:= ""
	Local cAliasQry	:= GetNextAlias()
	Local nMrgLib1	:= GetMV("ZZ_MRGLIB1")	//Margem liberação nível 1 (Usuário)
	Local nMrgLib2	:= GetMV("ZZ_MRGLIB2")	//Margem liberação nível 2 (Gerência)
	Local nNivelUsr	:= 0
	Local lValid 	:= .F.
	
	If cUserLib $ cUsrLib1
		nNivelUsr := 1
	ElseIf cUserLib $ cUsrLib2
		nNivelUsr := 2
	ElseIf cUserLib $ cUsrLib3
		nNivelUsr := 3
	EndIf
	
	If nNivelUsr > 0
		
		If nNivelUsr == 1
			
			If MarginValue() <= nMrgLib1
				lValid := .T.
			Else
				Aviso("Atenção", "Peido de venda possui item com margem superior a liberada ao usuário", {"Ok"})
			EndIf
			
		ElseIf nNivelUsr == 2 
		
			If MarginValue() <= nMrgLib2
				lValid := .T.
			Else
				Aviso("Atenção", "Peido de venda possui item com margem superior a liberada ao usuário", {"Ok"})
			EndIf
			
		ElseIf nNivelUsr == 3
			lValid := .T.
		EndIf
		
	Else
		Aviso("Atenção", "Usuário sem permissão para liberar preço", {"Ok"})
	EndIf
	
Return lValid
 
 /*
 	Função responsável por retornar a maior margem do pedido de venda bloqueado por preço
 */
Static Function MarginValue()
 	
	Local nValue 	:= 0
 	Local cQuery 	:= ""
 	Local cAliasQry	:= GetNextAlias()
 	
 	cQuery := "SELECT "
 	cQuery += "		TOP 1 ABS(C6_ZZMARGE) AS C6_ZZMARGE "
 	cQuery += "FROM "+ RetSqlName("SC6") +" "
 	cQuery += "WHERE "
 	cQuery += "		D_E_L_E_T_ = ' ' "
 	cQuery += "		AND C6_FILIAL = '"+ xFilial("SC6") +"' "
 	cQuery += "		AND C6_NUM = '"+ SC5->C5_NUM +"' "
 	cQuery += "		AND C6_ZZBLOQ = 'S' "
 	cQuery += "ORDER BY "
 	cQuery += "		ABS(C6_ZZMARGE) DESC "
 	
 	DbUseArea( .T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
 	
 	If !(cAliasQry)->(Eof())
 		nValue := (cAliasQry)->C6_ZZMARGE
 	EndIf
 	
 	(cAliasQry)->(DbCloseArea())
 	
 Return nValue
 
 Static Function RecordObs()
 	
  	Local cQuery 		:= ""
 	Local cAliasQry		:= GetNextAlias()
 	Local lSave			:= .F.
 	Local oDlg			:= Nil 
 	Local oGroup		:= Nil
 	Local oBrowse		:= Nil
 	Local cSalesOrder	:= SC5->C5_NUM
 	Local cCustomer		:= AllTrim(SC5->C5_CLIENTE) +" - "+ AllTrim(Posicione("SA1", 1, xFilial("SA1")+SC5->(C5_CLIENTE+C5_LOJACLI), "SA1->A1_NOME"))
 	Local cPayment		:= AllTrim(SC5->C5_CONDPAG) +" - "+ Posicione("SE4", 1, xFilial("SE4")+SC5->C5_CONDPAG, "SE4->E4_DESCRI")
 	Local cSaller		:= If(!Empty(SC5->C5_VEND1), AllTrim(SC5->C5_VEND1) +" - "+ Posicione("SA3", 1, xFilial("SA3")+SC5->C5_VEND1, "SA3->A3_NOME") +" / "+ AllTrim(SA3->A3_NREDUZ), "")
 	Local cTotal		:= ""
 	Local nTotal		:= 0
 	
 	aBrowse := {}
 	 
 	cQuery := "SELECT "
 	cQuery += "		C6_NUM, C6_ITEM, C6_PRODUTO, C6_DESCRI, C6_QTDVEN, C6_PRCVEN, C6_VALOR, C6_ZZVLRCF, C6_ZZMARGE "
 	cQuery += "FROM "+ RetSqlName("SC6") +" "
 	cQuery += "WHERE "
 	cQuery += "		D_E_L_E_T_ = ' ' "
 	cQuery += "		AND C6_FILIAL = '"+ xFilial("SC6") +"' "
 	cQuery += "		AND C6_NUM = '"+ SC5->C5_NUM +"' "
 	cQuery += "		AND C6_ZZBLOQ = 'S' "
 	cQuery += "ORDER BY "
 	cQuery += "		C6_ZZMARGE "
 	
 	DbUseArea( .T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
 	
 	While !(cAliasQry)->(Eof())
 		
 		aAdd(aBrowse, {(cAliasQry)->C6_NUM, (cAliasQry)->C6_ITEM, AllTrim((cAliasQry)->C6_PRODUTO), AllTrim((cAliasQry)->C6_DESCRI), ;
 		 			   AllTrim(Transform((cAliasQry)->C6_QTDVEN, "@E 999,999,999.99")), AllTrim(Transform((cAliasQry)->C6_PRCVEN, "@E 999,999,999.99")), ;
 		 			   AllTrim(Transform((cAliasQry)->C6_VALOR, "@E 999,999,999.99")), AllTrim(Transform((cAliasQry)->C6_ZZVLRCF, "@E 999,999,999.99")), ;
 		 			   AllTrim(Transform((cAliasQry)->C6_ZZMARGE, "@E 999.99%")), Space(100)})
 		
 		nTotal += (cAliasQry)->C6_VALOR
 		
 		(cAliasQry)->(DbSkip())
 		
 	EndDo
 	
 	(cAliasQry)->(DbCloseArea())	
 	
 	cTotal := AllTrim(Transform(nTotal, "@E 999,999,999.99"))
 	
 	DEFINE MsDialog oDlg FROM 0,0 TO 500, 1000 TITLE "Liberação de Preço" PIXEL
 		
		oBrowse := TCBrowse():New(050, 003, 495, 175,,,, oDlg,,,,, {||},,,,,,, .F.,, .T.,, .F.,,,)
		
		oGroup := TGroup():New(005, 003, 048, 498, "", oDlg,,,.T.)
		
		TSay():New(008, 010, {|| "Nº Pedido"}, 			oGroup,,, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 050, 008)
		TSay():New(018, 010, {|| "Cód. Cliente"},   	oGroup,,, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 050, 008)
		TSay():New(028, 010, {|| "Cond. Pagamento"},	oGroup,,, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 050, 008)
		TSay():New(038, 010, {|| "Representante"},   	oGroup,,, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 050, 008)
		TSay():New(008, 085, {|| cSalesOrder}, 			oGroup,,, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 050, 008)
		TSay():New(018, 085, {|| cCustomer},   			oGroup,,, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 300, 008)
		TSay():New(028, 085, {|| cPayment},				oGroup,,, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 300, 008)
		TSay():New(038, 085, {|| cSaller},   			oGroup,,, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 300, 008)
		TSay():New(008, 160, {|| "Total R$ "+ cTotal}, 	oGroup,,, .F., .F., .F., .T., CLR_BLACK, CLR_WHITE, 050, 008)				
			
   		oBrowse:SetArray(aBrowse) 
   		
    	oBrowse:AddColumn(TCColumn():New("Pedido", 		{|| aBrowse[oBrowse:nAt, 01]},,,, "LEFT",,  .F., .F.,,,, .F.,))
    	oBrowse:AddColumn(TCColumn():New("Item",		{|| aBrowse[oBrowse:nAt, 02]},,,, "LEFT",,  .F., .F.,,,, .F.,))
		oBrowse:AddColumn(TCColumn():New("Produto",		{|| aBrowse[oBrowse:nAt, 03]},,,, "LEFT",,  .F., .F.,,,, .F.,))
		oBrowse:AddColumn(TCColumn():New("Descrição",	{|| aBrowse[oBrowse:nAt, 04]},,,, "LEFT",,  .F., .F.,,,, .F.,))
		oBrowse:AddColumn(TCColumn():New("Quantidade",	{|| aBrowse[oBrowse:nAt, 05]},,,, "RIGHT",, .F., .F.,,,, .F.,))
		oBrowse:AddColumn(TCColumn():New("Preço",		{|| aBrowse[oBrowse:nAt, 06]},,,, "RIGHT",, .F., .F.,,,, .F.,))
		oBrowse:AddColumn(TCColumn():New("Total",		{|| aBrowse[oBrowse:nAt, 07]},,,, "RIGHT",, .F., .F.,,,, .F.,))
		oBrowse:AddColumn(TCColumn():New("Valor Coef.",	{|| aBrowse[oBrowse:nAt, 08]},,,, "RIGHT",, .F., .F.,,,, .F.,))
		oBrowse:AddColumn(TCColumn():New("Margem",		{|| aBrowse[oBrowse:nAt, 09]},,,, "RIGHT",, .F., .F.,,,, .F.,))
		oBrowse:AddColumn(TCColumn():New("Observação",	{|| aBrowse[oBrowse:nAt, 10]},,,, "LEFT",,  .F., .F.,,,, .F.,))
		
		oBrowse:bLDblClick := {|| lEditCell(@aBrowse, oBrowse, "", 10)}
		
    	TButton():New(230, 390, "Liberar", oDlg, {|| lSave := .T., oDlg:End()}, 45, 15,,, .F., .T., .F.,, .F.,,, .F.)
    	TButton():New(230, 450, "Fechar",  oDlg, {|| lSave := .F., oDlg:End()}, 45, 15,,, .F., .T., .F.,, .F.,,, .F.) 

	Activate MsDialog oDlg Centered 
 	
 Return lSave
 
 
/*
	Legenda
*/
User Function FATL0001()           
	
	Local aCores := {{"BR_VERDE", "Sem bloqueio"}, {"BR_VERMELHO", "Bloqueado"}}
	
	BrwLegenda("Legenda do Browse", "Liberação pedido", aCores)
	
Return