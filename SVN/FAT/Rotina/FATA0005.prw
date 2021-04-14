#Include "protheus.ch"
#Include "topconn.ch"
#Define cEOL CHR(13) + CHR(10)

/*/{Protheus.doc} FATA0005

Rotina de liberacao de estoque
	
@author Ademar Junior
@since 19/05/2015                      

/*/

/*
MaLibDoFat
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

C9_BLCRED
BR - Liberado 
01 – Bloqueado p/ crédito 
02 - MV_BLQCRED = t 
04 - Limite de Crédito Vencido 
05 - Bloqueio Crédito por Estorno 
06 – por risco 
09 - Rejeitado 
10 - Já Faturado.

C9_BLEST
BR - Liberado 
02 - Bloqueio de Estoque 
03 - Bloqueio Manual 
10 - Já Faturado.
*/

User Function FATA0005(cNum)

	Local aArea 	:= Lj7GetArea({"SC2", "SC5", "SC6", "SC9", "SB1"})
	Local aAreaAut	:= GetArea()	// Area rotina automatica
	Local lExeLib 	:= .F.
	Local cParam    := SuperGetMv("ZZ_LOCIND")
	
	DbSelectArea("SC5")

	If SC5->(DbSeek(xFilial("SC5") + cNum))
	
		If SC5->C5_ZZBLOQ == "N"
			
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
								
								// Se bloqueio de estoque e não tiver nota fiscal
								If AllTrim(SC9->C9_BLEST) != "" .And. AllTrim(SC9->C9_BLEST) != '' .And. SC9->C9_BLCRED != "09" .And. SC9->C9_BLEST != "10" .And. SC9->C9_BLEST != "ZZ" .And. AllTrim(SC9->C9_NFISCAL) == ""
									
									DbSelectArea("SB1")
									
									// B1_FILIAL + B1_COD
									SB1->(DbSetOrder(1))
									
									// Posicionar produto do item
									If SB1->(DbSeek(xFilial("SB1") + SC6->C6_PRODUTO))
									
										// Produto da linha padrão
										If SB1->B1_ZZLINHA == "P" .OR. (SB1->B1_ZZLINHA == "I".AND.SC6->C6_LOCAL=='05')//Alterado em 09/01/2017 por Sergio Braz - Nos casos da Federal Mogul não estava liberando pois eram linha I e local 05
											
											// Pesquisar quantidade disponível
											cQry :=	"SELECT " + cEOL
											cQry +=		"(B2_QATU - (B2_RESERVA + B2_QEMP)) AS QTDDISP " + cEOL
											cQry +=	"FROM " + cEOL
											cQry +=		RetSQLName("SB2") + " B2 " + cEOL
											cQry +=	"WHERE " + cEOL
											cQry +=		"B2_FILIAL = '" + xFilial("SB2") + "' AND" + cEOL
											cQry += 	"B2_COD = '" + SC6->C6_PRODUTO + "' AND " + cEOL
											cQry += 	"B2_LOCAL = '" + SC6->C6_LOCAL + "' AND " + cEOL
											cQry += 	"B2.D_E_L_E_T_ = ' '"
											
											// Executar query
											TcQuery cQry Alias TSB2 New
											
											If TSB2->(!EOF())
											
												// Verifica se o estoque é suficiente
												If SC9->C9_QTDLIB > TSB2->QTDDISP
													Aviso("Aviso", "Item " + AllTrim(SC6->C6_ITEM) + "(" + AllTrim(SC6->C6_PRODUTO) + ") do pedido " + AllTrim(SC6->C6_NUM) + " o saldo é insuficiente para atender. Saldo: " + AllTrim(Str(TSB2->QTDDISP)) + ".",{"OK"})
												Else 
													aAreaAut := GetArea()
		                                                 
													nAuxLib := SC9->C9_QTDLIB
													
													// Excluir liberações anteriores
													ExclLib(SC6->C6_NUM, SC6->C6_ITEM)
		
													// Fazer a liberação
													MaLibDoFat(SC6->(Recno()),nAuxLib,.T.,.T.,.F.,.F.)
		
													SC6->(MaLiberOk({SC5->C5_NUM},.F.))
													
													//Libera Restante do PV
													LibRestPV(SC5->C5_NUM, SC6->C6_ITEM, SC6->C6_CLI, SC6->C6_LOJA)
															
													lExeLib	:= .T.
													
													RestArea(aAreaAut)
											
												EndIf
											
											EndIf
											
											TSB2->(DbCloseArea())
										
										// Produto da linha industrial
										ElseIf SB1->B1_ZZLINHA == "I"
											// Checar se existe OP amarrada ao pedido no armazem de pecas soltas
											
											DbSelectArea("SC2")
											// C2_FILIAL + C2_NUM + C2_ITEM + C2_SEQUEN + C2_ITEMGRD
											SC2->(DbSetOrder(1))
											 
											// Posicionar Amarracao PV x OP
											// Com OP
											If SC2->(DbSeek(xFilial("SC2") + SC6->C6_NUMOP + SC6->C6_ITEMOP + "001"))
												
												nAQtdLib := SC9->C9_QTDLIB
											
												// Valida se a quantidade liberada é menor ou igual a quantidade produzida.
												If nAQtdLib <= SC2->C2_QUJE
													
													//Consulta quantidade disponível
													cQry :=	"SELECT " + cEOL
													cQry +=		"(B2_QATU - (B2_RESERVA + B2_QEMP)) AS QTDDISP " + cEOL
													cQry +=	"FROM " + cEOL
													cQry +=		RetSQLName("SB2") + " B2 " + cEOL
													cQry +=	"WHERE " + cEOL
													cQry +=		"B2_FILIAL = '" + xFilial("SB2") + "' AND" + cEOL
													cQry += 	"B2_COD = '" + SC6->C6_PRODUTO + "' AND " + cEOL
													cQry += 	"B2_LOCAL = '" + SC6->C6_LOCAL + "' AND " + cEOL
													cQry += 	"B2.D_E_L_E_T_ = ' '"
													
													TcQuery cQry Alias TSB2 New
													
													If TSB2->(!EOF())
														// Verifica se o estoque é suficiente
														If nAQtdLib > TSB2->QTDDISP
															Aviso("Aviso","Item " + AllTrim(SC6->C6_ITEM) + "(" + AllTrim(SC6->C6_PRODUTO) + ") do pedido " + AllTrim(SC6->C6_NUM) + " o saldo é insuficiente para atender. Saldo: " + AllTrim(Str(TSB2->QTDDISP)) + ".",{"OK"})
														Else     
															aAreaAut := GetArea()
															     
															nAuxLib := SC9->C9_QTDLIB
															
															// Excluir liberações anteriores
															ExclLib(SC6->C6_NUM,SC6->C6_ITEM)
															
															// Faz a liberação para a quantidade produzida
															MaLibDoFat(SC6->(Recno()),nAuxLib,.T.,.T.,.F.,.F.)
															
															SC6->(MaLiberOk({SC5->C5_NUM},.F.))
															
															//Libera Restante do PV
															LibRestPV(SC5->C5_NUM, SC6->C6_ITEM, SC6->C6_CLI, SC6->C6_LOJA)
															
															lExeLib := .T.
															
															RestArea(aAreaAut)
														EndIf 
													EndIf
													
													TSB2->(DbCloseArea())
												Else
													// Verfica se encontrou a OP e a mesma não foi apontada.
													Aviso("Aviso","Não há saldo suficiente produzido para este pedido. Verifique a OP: " + AllTrim(SC2->C2_NUM) + AllTrim(SC2->C2_ITEM) + AllTrim(SC2->C2_SEQUEN) + ".",{"OK"})
												EndIf 
												
											// Se não encontrou OP verifica no armazém de peças soltas
											Else
											
												If SC6->C6_LOCAL $ cParam//GetMv("ZZ_LOCIND") 
												
													// Pesquisar quantidade disponível
													cQry :=	"SELECT " + cEOL
													cQry +=		"(B2_QATU - (B2_RESERVA + B2_QEMP)) AS QTDDISP " + cEOL
													cQry +=	"FROM " + cEOL
													cQry +=		RetSQLName("SB2") + " B2 " + cEOL
													cQry +=	"WHERE " + cEOL
													cQry +=		"B2_FILIAL = '" + xFilial("SB2") + "' AND" + cEOL
													cQry += 	"B2_COD = '" + SC6->C6_PRODUTO + "' AND " + cEOL
													cQry += 	"B2_LOCAL = '" + SC6->C6_LOCAL + "' AND " + cEOL
													cQry += 	"B2.D_E_L_E_T_ = ' '"
													
													// Executar query
													TcQuery cQry Alias TSB2 New
													
													If TSB2->(!EOF())
											
														// Verifica se o estoque é suficiente
														If SC9->C9_QTDLIB <= TSB2->QTDDISP
															aAreaAut := GetArea()
				                                                 
															nAuxLib := SC9->C9_QTDLIB
															
															// Excluir liberações anteriores
															ExclLib(SC6->C6_NUM,SC6->C6_ITEM)
				
															// Fazer a liberação
															MaLibDoFat(SC6->(Recno()), nAuxLib,.T.,.T.,.F.,.F.)
				
															SC6->(MaLiberOk({SC5->C5_NUM}, .F.))
															
															//Libera Restante do PV
															LibRestPV(SC5->C5_NUM, SC6->C6_ITEM, SC6->C6_CLI, SC6->C6_LOJA)
															
															lExeLib	:= .T.
															
															RestArea(aAreaAut)
															
														EndIf
													EndIf
													
													TSB2->(DbCloseArea())
											
												Else
											
												 	// Consulta quantidade disponível no armazém de peças soltas
												 	/*
													cQry :=	"SELECT " + cEOL
													cQry +=		"(B2_QATU - (B2_RESERVA + B2_QEMP)) AS QTDDISP " + cEOL
													cQry +=	"FROM " + cEOL
													cQry +=		RetSQLName("SB2") + " B2 " + cEOL
													cQry +=	"WHERE " + cEOL
													cQry +=		"B2_FILIAL = '" + xFilial("SB2") + "' AND" + cEOL
													cQry += 	"B2_COD = '" + SC6->C6_PRODUTO + "' AND " + cEOL
													cQry += 	"B2_LOCAL = '" + GetMv("ZZ_LOCIND") + "' AND " + cEOL
													cQry += 	"B2.D_E_L_E_T_ = ' '"
													
													TcQuery cQry Alias TSB2 New
																									
													If TSB2->(!EOF())
														// Verifica se o saldo é maior que zero no armazém de 'peças soltas'
														If TSB2->QTDDISP > 0
															Aviso("Aviso","Item " + AllTrim(SC6->C6_ITEM) + "(" + AllTrim(SC6->C6_PRODUTO) + ") do pedido " + AllTrim(SC6->C6_NUM) + " tem saldo de " + AllTrim(Str(TSB2->QTDDISP)) + " unidades no armazém " + GetMv("ZZ_LOCIND") + ". Transfira para o armazém de venda e libere pela LIBERAÇÃO AUTOMÁTICA.",{"OK"})
														EndIf 
													EndIf
													
													TSB2->(DbCloseArea())
													*/
												EndIf
											
											EndIf
										
										Else
											Aviso("Aviso","Item " + AllTrim(SC6->C6_ITEM) + "(" + AllTrim(SC6->C6_PRODUTO) + ") do pedido " + AllTrim(SC6->C6_NUM) + " está com o campo 'Linha Produto' em branco. Liberação estoque não realizada.",{"OK"})
										EndIf
										
									EndIf
									
								EndIf
								
							Else
								Aviso("Aviso","Item " + AllTrim(SC6->C6_ITEM) + "(" + AllTrim(SC6->C6_PRODUTO) + ") do pedido " + AllTrim(SC6->C6_NUM) + " está bloqueado por crédito ou já faturado. Liberação estoque não realizada.",{"OK"})
							EndIf
							
						Else
							
							//Quando a quantidade liberada é 0, precisa gerar 
							MaLibDoFat(SC6->(Recno()), (SC6->C6_QTDVEN - SC6->C6_QTDENT), .T., .F., .F., .F.)
																		
							SC6->(MaLiberOk({SC5->C5_NUM}, .F.))
						
						EndIf
						
						
					EndIf	
					
					SC6->(DbSkip())
					
				EndDo
				
			EndIf
	                         
			// Refletir bloqueio de preço caso exista no SC9
			If lExeLib
				
				DbSelectArea("SC9")
				SC9->(DbSetOrder(1))
				
				If SC9->(DbSeek(xFilial("SC9") + SC5->C5_NUM))
				
					While SC9->(!EOF()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == SC5->C5_NUM
				
						RecLock("SC9",.F.)
							SC9->C9_ZZBLOQ := SC5->C5_ZZBLOQ
						SC9->(MsUnlock())
						
						SC9->(DbSkip())
				
					EndDo
				
				EndIf
				
			EndIf
		Else
			Aviso("Aviso","Pedido bloqueado por preço. Fazer primeiro a liberação por preço",{"OK"})
		EndIf
		
	EndIf
	
	Lj7RestArea(aArea)
		
Return


/****************************************************************************************************/


// Funcao		: ExclLib()
// Descricao	: Verifica a existencia do grupo de perguntas, caso nao exista cria.
Static Function ExclLib(cNum, cItem)
	
	Local aArea := Lj7GetArea({"SC9"})
	Local lLib	:= .F.
	
	dbSelectArea("SC9")
	dbSetOrder(1)
	dbSeek(xFilial("SC9") + cNum + cItem)
	
	while SC9->(!(Eof())) .and. SC9->C9_FILIAL == xFilial("SC9") .and. SC9->C9_PEDIDO == cNum .And. SC9->C9_ITEM == cItem
		
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

/*/{Protheus.doc} LibRestPV

Função responsável pela liberação do saldo do item na liberação parcial

@author Ectore Cecato - Totvs Jundiaí
@since 11/09/2015
@version Protheus 11 - Faturamento

@param cNum, caracter, Número do pedido de venda
@param cItem, caracter, Item do pedido de venda
@param cCliente, caracter, Cliente do pedido de venda
@param cLoja, caracter, Loja do cliente do pedido de venda
 
/*/
Static Function LibRestPV(cNum, cItem, cCliente, cLoja)

	Local cQuery 	:= ""
	Local cAliasQry := GetNextAlias()

	cQuery := "SELECT "+ cEOL
	cQuery += "		SUM(C9_QTDLIB) C9_QTDLIB"+ cEOL
	cQuery += "FROM "+ RetSQLName("SC9") +" SC9 "+ cEOL
	cQuery += "WHERE "+ cEOL
	cQuery += "		C9_FILIAL = '" + xFilial("SC9") + "' "+ cEOL
	cQuery += "		AND C9_PEDIDO = '" + SC5->C5_NUM + "' "+ cEOL
	cQuery += "		AND C9_ITEM = '" + SC6->C6_ITEM + "' "+ cEOL
	cQuery += "		AND C9_CLIENTE = '" + SC6->C6_CLI + "' "+ cEOL
	cQuery += "		AND C9_LOJA = '" + SC6->C6_LOJA + "' "+ cEOL
	cQuery += "		AND SC9.D_E_L_E_T_ = ' ' "
	
	DbUseArea( .T., "TOPCONN", TcGenQry(,, cQuery), cAliasQry, .F., .T.)
	
	If !(cAliasQry)->(Eof()) .And. (SC6->C6_QTDVEN - SC6->C6_QTDENT - (cAliasQry)->C9_QTDLIB) > 0
		
		MaLibDoFat(SC6->(Recno()),(SC6->C6_QTDVEN - SC6->C6_QTDENT - (cAliasQry)->C9_QTDLIB), .T., .F., .F., .F.)
																		
		SC6->(MaLiberOk({SC5->C5_NUM}, .F.))
			
	EndIf
								
	(cAliasQry)->(DbCloseArea())
	
Return Nil