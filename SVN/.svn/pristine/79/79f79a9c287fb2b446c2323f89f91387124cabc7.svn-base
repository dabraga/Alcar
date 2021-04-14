#Include "protheus.ch"
#Include "topconn.ch"
#Define cEOL CHR(13) + CHR(10)

/*/{Protheus.doc} FATA0006

Rotina de alteração / liberação pedidos
	
@author Ademar Junior
@since 19/05/2015

/*/

User Function FATA0006()

	Local aArea 	:= Lj7GetArea({"SC5", "SC6"})
	Local cPerg		:= "FATA0006"	// Grupo de perguntas
	Local oSay1		:= Nil
	Local oSay2		:= Nil
	Local oSay3		:= Nil
	Local oSay4		:= Nil
	Local oSay5		:= Nil
	Local oSay6		:= Nil
	Local oSay7		:= Nil
	Local oSay8		:= Nil
	Local oSay9		:= Nil
	
	Local oGtCond	:= Nil
	Local oGtTrans	:= Nil
	Local oGtVend	:= Nil
	Local oCbTipo	:= Nil
	
	Local aCbTipo	:= {"Selecione","C - CIF","F - FOB","T - Terceiros","S - Sem frete"}
	
	Local oBrw1		:= Nil
	
	Local nOpc 		:= GD_UPDATE
	
	Local aCmpBrw	:= {}
	Local aColBrw 	:= {}
	Local aCmpAlt	:= {"C6_QTDVEN", "C6_QTDLIB", "C6_PEDCLI", "C6_NUMPCOM", "C6_ITEMPC", "C6_ZZDES", "C6_ZZPRDCL", "C6_ZZREQ"}
	
	Private cGtCond		:= Space(TamSx3("E4_CODIGO")[1])
	Private cGtTrans	:= Space(TamSx3("A4_COD")[1])
	Private cCbTipo		:= Space(TamSx3("C5_TPFRETE")[1])
	Private cGtVend		:= Space(TamSx3("C5_VEND1")[1])

	// Chamada ValidPerg
	//ValidPerg(cPerg,1) //Comentado por Eduardo Cestari (Totvs IP) 07/11/2019 para funcionamento no P12.1.25 
	If !Pergunte(cPerg,.T.)
		Return
	EndIf

	AADD(aCmpBrw, {"Item",			"C6_ITEM",		"@!",						TamSx3("C6_ITEM")[1],		TamSx3("C6_ITEM")[2],	 "", "", "C", "", ""})	// 01 - Item
	AADD(aCmpBrw, {"Produto",		"C6_PRODUTO",	"@!",						TamSx3("C6_PRODUTO")[1],	TamSx3("C6_PRODUTO")[2], "", "", "C", "", ""})	// 02 - Produto
	AADD(aCmpBrw, {"Quantidade",	"C6_QTDVEN",	"@E 999,999,999.999999",	TamSx3("C6_QTDVEN")[1],		TamSx3("C6_QTDVEN")[2],	 "", "", "N", "", ""})	// 03 - Quantidade
	AADD(aCmpBrw, {"Qtd.Liberada",	"C6_QTDLIB",	"@E 999,999,999.999999",	TamSx3("C6_QTDLIB")[1],		TamSx3("C6_QTDLIB")[2],	 "", "", "N", "", ""})	// 04 - Quantidade liberada
	AADD(aCmpBrw, {"Qtd.Entregue",	"C6_QTDENT",	"@E 999,999,999.999999",	TamSx3("C6_QTDENT")[1],		TamSx3("C6_QTDENT")[2],	 "", "", "N", "", ""})	// 04 - Quantidade liberada
	AADD(aCmpBrw, {"Ped Cliente",	"C6_PEDCLI",	"@X",						TamSx3("C6_PEDCLI")[1],		TamSx3("C6_PEDCLI")[2],	 "", "", "C", "", ""})	// 05 - Pedido cliente
	AADD(aCmpBrw, {"Num.Ped.Comp",	"C6_NUMPCOM",	"@!",						TamSx3("C6_NUMPCOM")[1],	TamSx3("C6_NUMPCOM")[2], "", "", "C", "", ""})	// 06 - Num. Ped. Com
	AADD(aCmpBrw, {"Item.Ped.Com",	"C6_ITEMPC",	"@!",						TamSx3("C6_ITEMPC")[1],		TamSx3("C6_ITEMPC")[2],	 "", "", "C", "", ""})	// 07 - Item Ped. Com
	AADD(aCmpBrw, {"Desenho",		"C6_ZZDES",		"@!",						TamSx3("C6_ZZDES")[1],		TamSx3("C6_ZZDES")[2],	 "", "", "C", "", ""})	// 08 - Desenho
	AADD(aCmpBrw, {"Prod Cliente",	"C6_ZZPRDCL",	"@!",						TamSx3("C6_ZZPRDCL")[1],	TamSx3("C6_ZZPRDCL")[2], "", "", "C", "", ""})	// 09 - Prod. Cliente
	AADD(aCmpBrw, {"Requisicao",	"C6_ZZREQ",		"@!",						TamSx3("C6_ZZREQ")[1],		TamSx3("C6_ZZREQ")[2],	 "", "", "C", "", ""})	// 10 - Requisicao

	DbSelectArea("SC5")
	
	SC5->(DbSetOrder(1))
	
	If SC5->(DbSeek(xFilial("SC5") + MV_PAR01))
	
		If Empty(SC5->C5_NOTA) .And. SC5->C5_LIBEROK != 'E'
	
			If SC5->C5_ZZBLOQ == "N"
				
				cGtCond 	:= SC5->C5_CONDPAG
				cGtTrans	:= SC5->C5_TRANSP
				cGtVend 	:= SC5->C5_VEND1

				If SC5->C5_TPFRETE == "C"
					cCbTipo := "C - CIF"
				ElseIf SC5->C5_TPFRETE == "F"
					cCbTipo := "F - FOB"
				ElseIf SC5->C5_TPFRETE == "T"
//					"T - Terceiros"
				ElseIf SC5->C5_TPFRETE == "S"
//					"S - Sem frete"
				Else
//					"Selecione"
				EndIf
				
				aColBrw := {}
				
				DbSelectArea("SC6")
				
				SC6->(DbSetOrder(1))
	
				If SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM))
	
					While SC6->(!EOF()) .And. SC6->C6_NUM == SC5->C5_NUM
	
						If ((SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0) .And. (AllTrim(SC6->C6_BLQ) <> "R")
	
							AADD(aColBrw, Array(Len(aCmpBrw) + 1))
							
							// 01 - Item
							// 02 - Produto
							// 03 - Quantidade
							// 04 - Quantidade liberada
							// 05 - Pedido cliente
							// 06 - Num. Ped. Com
							// 07 - Item Ped. Com
							// 08 - Desenho
							// 09 - Prod. Cliente
							// 10 - Requisicao				
							
							aColBrw[Len(aColBrw)][01] := SC6->C6_ITEM
							aColBrw[Len(aColBrw)][02] := SC6->C6_PRODUTO
							aColBrw[Len(aColBrw)][03] := SC6->C6_QTDVEN
							aColBrw[Len(aColBrw)][04] := (SC6->C6_QTDVEN - SC6->C6_QTDENT)
							aColBrw[Len(aColBrw)][05] := SC6->C6_QTDENT
							aColBrw[Len(aColBrw)][06] := SC6->C6_PEDCLI
							aColBrw[Len(aColBrw)][07] := SC6->C6_NUMPCOM
							aColBrw[Len(aColBrw)][08] := SC6->C6_ITEMPC
							aColBrw[Len(aColBrw)][09] := SC6->C6_ZZDES
							aColBrw[Len(aColBrw)][10] := SC6->C6_ZZPRDCL
							aColBrw[Len(aColBrw)][11] := SC6->C6_ZZREQ
							aColBrw[Len(aColBrw)][12] := .F.
	
						EndIf
						
						SC6->(DbSkip())
	
					EndDo
	
				EndIf
			
				Define MsDialog oDlg Title "Alteração Pedido de Vendas" From 000,000 To 300,700 Pixel
			    	
			    	@005,005 Say oSay1 Prompt "Pedido: "+ AllTrim(SC5->C5_NUM) Of oDlg Pixel    	
					@005,050 Say oSay5 Prompt "Cliente: "+ SC5->C5_CLIENTE +"/"+ SC5->C5_LOJACLI +" - "+ AllTrim(Posicione("SA1", 1, xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "SA1->A1_NREDUZ")) Of oDlg Pixel
										 			
			    	@025,005 Say oSay2 Prompt "Cond.Pagamento:" Of oDlg Pixel    	
			    	@022,050 MsGet oGtCond Var cGtCond F3 "SE4" Valid !Vazio() .And. ExistCpo("SE4") Size 020,010 Of oDlg Pixel
			    	@025,100 Say oSay6 Prompt AllTrim(Posicione("SE4", 1, xFilial("SE4")+cGtCond, "SE4->E4_DESCRI")) Of oDlg Pixel
			    	
			    	@040,005 Say oSay3 Prompt "Transportadora:" Of oDlg Pixel    	
			    	@037,050 MsGet oGtTrans Var cGtTrans F3 "SA0402" Valid If(!Vazio(),ExistCpo("SA4"),.T.) Size 040,010 Of oDlg Pixel
					@040,100 Say oSay7 Prompt AllTrim(Posicione("SA4", 1, xFilial("SA4")+cGtTrans, "SA4->A4_NREDUZ")) Of oDlg Pixel
			    	
					@040,200 Say oSay8 Prompt "Vendedor:" Of oDlg Pixel    	
			    	@037,230 MsGet oGtVend Var cGtVend F3 "SA3" Valid !Vazio() .And. ExistCpo("SA3") Size 020,010 Of oDlg Pixel
			    	@040,265 Say oSay9 Prompt AllTrim(Posicione("SA3", 1, xFilial("SA3")+cGtVend, "SA3->A3_NREDUZ")) Of oDlg Pixel

			    	@025,220 Say oSay4 Prompt "Tipo de Frete :" Of oDlg Pixel    	
			    	@022,260 MsComboBox oCbTipo Var cCbTipo Items aCbTipo Size 050,010 Of oDlg Pixel
		
			    	oBrw1 := MsNewGetDados():New(060,005,125,340,nOpc,"U_LinOK()","AllwaysTrue()","",aCmpAlt,0,99,"AllwaysTrue()","","AllwaysTrue()",oDlg,aCmpBrw,aColBrw)
			
			    	@135,005 Button oBtn2 Prompt "Ok" Action(AuxProc(oDlg,SC5->C5_NUM,oBrw1:aCols,cGtCond,cGtTrans,cCbTipo,cGtVend)) Size 035,010 Of oDlg Pixel
			    	@135,045 Button oBtn3 Prompt "Cancelar" Action(oDlg:End()) Size 035,010 Of oDlg Pixel
			  	
			  	Activate MsDialog oDlg Centered
			  	
			Else
				Aviso("Aviso","Pedido bloqueado por preço. Fazer primeiro a liberação por preço",{"OK"})
			EndIf
	
	    Else
	    	Aviso("Aviso","Pedido de venda encerrado. Não é possível alteração.",{"OK"})
	    EndIf
	
	Else
		Aviso("Aviso","Pedido não encontrado.",{"OK"})
    EndIf
    
    Lj7RestArea(aArea)
        
Return

Static Function AuxProc(oDlg,cNum,aColBrw,cGtCond,cGtTrans,cCbTipo, cGtVend)

	oDlg:End()
	
	Processa({|| AltPed(cNum, aColBrw, cGtCond, cGtTrans, cCbTipo, cGtVend)}, "Executando alteração")
	
Return

Static Function AltPed(cNum, aColBrw, cGtCond, cGtTrans, cCbTipo, cGtVend)
	
	//Local cQry		:= ""
	Local aArea 	:= Lj7GetArea({"SC5", "SC6", "SC9"})
	Local aCabec 	:= {}
	Local aItens 	:= {}
	Local aLinha	:= {}
	Local k         := 0
	
	Private lMsErroAuto	:=	.F.
	Private lMsHelpAuto	:=	.F.

	If cCbTipo == "Selecione"
	
		Aviso("Aviso", "Selecione o tipo de frete.", {"OK"})
		
		Return Nil
	
	EndIf

	ProcRegua(0)
	
	DbSelectArea("SC5")
	
	SC5->(DbSetOrder(1))
	
	If SC5->(DbSeek(xFilial("SC5") + cNum)) 
        
        AADD(aCabec, {"C5_NUM",		SC5->C5_NUM,			Nil})
        AADD(aCabec, {"C5_TRANSP", 	cGtTrans,				Nil})
        AADD(aCabec, {"C5_CONDPAG",	cGtCond,				Nil})
		AADD(aCabec, {"C5_VEND1",	cGtVend,				Nil})
        AADD(aCabec, {"C5_TPFRETE",	SubStr(cCbTipo,1,1),	Nil})
        
        DbSelectArea("SC6")
        
        SC6->(DbSetOrder(1)) // C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
        
        For k := 1 To Len(aColBrw)
        
        	If SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM + aColBrw[k,1] + aColBrw[k,2]))
        
        		aLinha := {}
        	
        		// 01 - Item
        		// 02 - Produto
        		// 03 - Quantidade
        		// 04 - Quantidade liberada
        		// 05 - Pedido cliente
        		// 06 - Num. Ped. Com
        		// 07 - Item Ped. Com
        		// 08 - Desenho
        		// 09 - Prod. Cliente
        		// 10 - Requisicao
        	
        		AADD(aLinha,{"LINPOS",		"C6_ITEM",			SC6->C6_ITEM})
        		aadd(aLinha,{"AUTDELETA",	"N",				Nil})
        		AADD(aLinha,{"C6_PRODUTO",	SC6->C6_PRODUTO,	Nil})
        		AADD(aLinha,{"C6_TES",		SC6->C6_TES,		Nil})
        		AADD(aLinha,{"C6_QTDVEN",	aColBrw[k,03],		Nil})
        		AADD(aLinha,{"C6_QTDLIB",	aColBrw[k,04],		Nil})
        		AADD(aLinha,{"C6_PRCVEN",	SC6->C6_PRCVEN,		Nil})
        		AADD(aLinha,{"C6_TES",		SC6->C6_TES,		Nil})
        		AADD(aLinha,{"C6_PEDCLI",	aColBrw[k,06],		Nil})
        		AADD(aLinha,{"C6_NUMPCOM",	aColBrw[k,07],		Nil})
        		AADD(aLinha,{"C6_ITEMPC",	aColBrw[k,08],		Nil})
        		AADD(aLinha,{"C6_CLASFIS",	SC6->C6_CLASFIS,	Nil})
        		AADD(aLinha,{"C6_ZZDES",	aColBrw[k,09],		Nil})
        		AADD(aLinha,{"C6_ZZPRDCL",	aColBrw[k,10],		Nil})
        		AADD(aLinha,{"C6_ZZREQ",	aColBrw[k,11],		Nil})
        		        		
        		AADD(aItens, aLinha)
        		
        	EndIf
        	
        Next
        
        PutMv("MV_ALTPVOP", "S")
        
        MSExecAuto({|x,y,z| Mata410(x,y,z)}, aCabec, aItens, 4)
        
        PutMv("MV_ALTPVOP", "N")

		If lMsErroAuto
			MostraErro()
		Else
			
			DbSelectArea("SC5")
			
			SC5->(DbSetOrder(1))
			
			If SC5->(DbSeek(xFilial("SC5") + cNum)) 
			
				// Liberar preço
				RecLock("SC5",.F.)
					SC5->C5_ZZBLOQ := "N"
				SC5->(MsUnLock())
				
				// Bloquear pedido na liberação do pedido
				DbSelectArea("SC9")
				
				SC9->(DbSetOrder(1))

				If SC9->(DbSeek(xFilial("SC9") + SC5->C5_NUM))
				
					While SC9->(!EOF()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == SC5->C5_NUM
					
						RecLock("SC9",.F.)
							SC9->C9_ZZBLOQ := "N"
							SC9->C9_BLCRED := ""
						SC9->(MsUnlock())
						
						SC9->(DbSkip())
						
					EndDo
					
				EndIf
			
				// Liberar credito
				
				/*
				01: Registro do SC6                                      
				02: Quantidade a Liberar                                 
				03: Bloqueio de Credito                                  
				04: Bloqueio de Estoque                                  
				05: Avaliacao de Credito                                 
				06: Avaliacao de Estoque                                 
				07: Permite Liberacao Parcial                            
				08: Tranfere Locais automaticamente                      
				09: Empenhos (Caso seja informado nao efetua a gravacao apenas avalia) 
				10: CodeBlock a ser avaliado na gravacao do SC9           
				11: Array com Empenhos previamente escolhidos (impede selecao dos empenhos pelas rotinas)            
				12: Indica se apenas esta trocando lotes do SC9          
				13: Valor a ser adicionado ao limite de credito          
				14: Quantidade a Liberar - segunda UM
				*/                        
				
				DbSelectArea("SC6")
				// C6_FILIAL + C6_NUM + C6_ITEM + C6_PRODUTO
				SC6->(DbSetOrder(1))
				
				// Posicionar itens do pedido de venda
				If SC6->(DbSeek(xFilial("SC6") + SC5->C5_NUM))
					
					// Percorrer itens do pedido
					While SC6->(!EOF()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == SC5->C5_NUM
					
						If ((SC6->C6_QTDVEN - SC6->C6_QTDENT) > 0) .And. (AllTrim(SC6->C6_BLQ) <> "R")
						
							DbSelectArea("SC9")
							
							// C9_FILIAL + C9_CLIENTE + C9_LOJA + C9_PEDIDO + C9_ITEM
							SC9->(DbSetOrder(2))
							
							// Posicionar liberacao dos pedidos
							If SC9->(DbSeek(xFilial("SC9") + SC6->C6_CLI + SC6->C6_LOJA + SC6->C6_NUM + SC6->C6_ITEM))
							
									// Se não estiver bloqueado por credito
									If AllTrim(SC9->C9_BLCRED) == '' .Or. SC9->C9_BLCRED == "09" .Or. SC9->C9_BLCRED == "10" .Or. SC9->C9_BLCRED == "ZZ"
										
										// Excluir liberações anteriores
										// Comentado em 03/08/2015 por Winston Dellano // 
										ExclLib(SC6->C6_NUM, SC6->C6_ITEM)
				
										// Fazer a liberação
										MaLibDoFat(SC6->(Recno()), SC9->C9_QTDLIB, .T., .F., .F., .F., .T.)
										
										SC6->(MaLiberOk({SC5->C5_NUM}, .F.))
										
									EndIf
							EndIf
						
							//Libera Restante do PV
							//LibRestPV(SC5->C5_NUM, SC6->C6_ITEM, SC6->C6_CLI, SC6->C6_LOJA)
							/*		
							// Fazer a liberação do restante
							cQry :=	"SELECT " + cEOL
							cQry +=		"SUM(C9_QTDLIB) C9_QTDLIB" + cEOL
			
							cQry +=	"FROM " + cEOL
							cQry +=		RetSQLName("SC9") + " SC9 " + cEOL
			
							cQry +=	"WHERE " + cEOL
							cQry +=		"C9_FILIAL = '" + xFilial("SC9") + "' AND " + cEOL
							cQry +=		"C9_PEDIDO = '" + SC5->C5_NUM + "' AND " + cEOL
							cQry +=		"C9_ITEM = '" + SC6->C6_ITEM + "' AND " + cEOL
							cQry +=		"C9_CLIENTE = '" + SC6->C6_CLI + "' AND " + cEOL
							cQry +=		"C9_LOJA = '" + SC6->C6_LOJA + "' AND " + cEOL
							cQry +=		"SC9.D_E_L_E_T_ = ' '"
							
							TcQuery cQry Alias TSC9 New
			
							If TSC9->(!EOF())
								
								If ((SC6->C6_QTDVEN - SC6->C6_QTDENT) - TSC9->C9_QTDLIB) > 0
									
									MaLibDoFat(SC6->(Recno()),((SC6->C6_QTDVEN - SC6->C6_QTDENT) - TSC9->C9_QTDLIB), .T., .F., .F., .F., .T.)
																		
									SC6->(MaLiberOk({SC5->C5_NUM}, .F.))
							
								EndIf
							
							EndIf
							
							TSC9->(DbCloseArea())
						*/
						EndIf
						
						SC6->(DbSkip())
						
					EndDo
				EndIf
				
				// Liberação Alcar
				// Comentado em 03/08/2015 por Winston Dellano // 
				U_FATA0005(cNum)
				
			EndIf
		Endif
   EndIf
   
   Lj7RestArea(aArea)
   
Return Nil


/****************************************************************************************************/


// Funcao		: ExclLib()
// Descricao	: Verifica a existencia do grupo de perguntas, caso nao exista cria.
Static Function ExclLib(cNum, cItem)
	
	Local aArea := Lj7GetArea({"SC9"})
	Local lLib	:= .F.
	
	DbSelectArea("SC9")
	
	DbSetOrder(1)
	
	DbSeek(xFilial("SC9") + cNum + cItem)
	
	While !SC9->(Eof()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == cNum .And. SC9->C9_ITEM == cItem
		
		lLib := .F.
		
		BEGIN TRANSACTION
			
			lLib := SC9->(a460Estorna(.T.))
		
			If !lLib
				Aviso("Atenção", "Não foi possível excluir a liberação do item "+ SC9->C9_ITEM +" do pedido "+ SC9->C9_PEDIDO, {"Ok"})
			EndIf
			
		END TRANSACTION
		
		
		SC9->(dbSkip())
	
	enddo

	Lj7RestArea(aArea)
	
Return Nil


User Function LinOK()

	Local lLinOK := .T.
	
	If aCols[n, 04] > (aCols[n, 03] - aCols[n, 05])
		
		lLinOK := .F.
		
		Aviso("Atenção", "Quantidade liberada maior que o saldo do item", {"Ok"})
		
	EndIf

Return lLinOK

/****************************************************************************************************/


// Funcao		: ValidPerg(cPerg)
// Descricao	: Verifica a existencia do grupo de perguntas, caso nao exista cria.

//Static Function ValidPerg(cPerg)
//	
//	Local aAlias := Alias()
//	Local aRegs := {}
//	Local i,j         
//	Local aCposSX1 := FWSX1Util():GetGroup(cPerg)                                                                                                                       
	
//	SX1->(DbSelectArea("SX1"))
//	SX1->(DbSetOrder(1))
//	cPerg := PADR(cPerg,Len(aCposSX1[1][1]/*SX1->X1_GRUPO*/))
	
//	// Grupo - Ordem - Pergunta - Variavel - Tipo - Tamanho - Decimal - Presel - GSC - Valid - Var01 - Def01 - Cnt01 - Var02 - Def02 - Cnt02 - Var03 - Def03 - Cnt03 - Var04 - Def04 - Cnt04 - Var05 - Def05 - Cnt05
//	AADD(aRegs,{cPerg,"01","Pedido","","","mv_ch1","C",06,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SC5"})
	
//	For i := 1 To Len(aRegs)
//		If !SX1->(DbSeek(cPerg + aRegs[i,2]))
//			RecLock("SX1",.T.)
//			For j := 1 To FCount()
//				If j <= Len(aRegs[i])
//					FieldPut(j,aRegs[i,j])
//				EndIf
//			Next
//			SX1->(MsUnlock())
//		EndIf
//	Next
	
//	DbSelectArea(aAlias)

//Return Nil
