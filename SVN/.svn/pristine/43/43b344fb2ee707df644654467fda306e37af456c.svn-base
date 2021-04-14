#Include "totvs.ch"
#Include "topconn.ch"

#Define cEOL CHR(13) + CHR(10)

/*	
Função		:	FATA0002
Autor		:	Ademar Pereira da Silva Junior
Data		:	06/04/2015
Descricao	:	Rotina para validar se o pedido será bloqueado
*/

User Function FATA0002(cPedido) 

	Local aArea 	:= GetArea()
	Local aAreaSC6	:= SC6->(GetArea())
	Local aAreaSC9	:= SC9->(GetArea())
	Local aAreaSA1	:= SA1->(GetArea())
	Local aAreaSE4	:= SE4->(GetArea())
	Local aAreaSF4	:= SF4->(GetArea())
	Local lExec		:= .F.
	Local lExecSC5	:= .F.
	Local cAuxICM	:= GetMv("ZZ_ESTICM")
	Local nAuxICM	:= 0
	Local nICMEst	:= 0
	Local nICMSP	:= 0
	Local cAuxEst   := ""
	Local nAuxPos	:= 0
	Local nAuxVal	:= ""

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))

	// Posiciona pedido
	If SC5->(DbSeek(xFilial("SC5") + cPedido))

		DbSelectArea("SA1")

		SA1->(DbSetOrder(1))

		// Posiciona cliente
		If SA1->(DbSeek(xFilial("SA1") + SC5->C5_CLIENT + SC5->C5_LOJACLI))

			cAuxEst := SA1->A1_EST
			nAuxPos	:= At(cAuxEst,cAuxICM)
			nICMEst := Val(SubStr(cAuxICM,nAuxPos + 2,2))

			nAuxPos := At("SP",cAuxICM)
			nICMSP	:= Val(SubStr(cAuxICM,nAuxPos + 2,2))

			nAuxICM := nICMSP - nICMEst

		EndIf

		// Posiciona condição de pagamento
		DbSelectArea("SE4")

		SE4->(DbSetOrder(1))

		If SE4->(DbSeek(xFilial("SE4") + SC5->C5_CONDPAG))
			nCoefFin := SE4->E4_ZZCOFIN
		EndIf

	EndIf

	DbSelectArea("SC6")  

	SC6->(DbSetOrder(1))

	// Posiciona itens
	If SC6->(DbSeek(xFilial("SC6")+cPedido))

		lExec := .F.

		// Percorrer pedido fazendo o cálculo para ver se atende a regra de bloqueio
		While SC6->C6_NUM == cPedido

			DbSelectArea("SB1")

			SB1->(DbSetOrder(1))

			If SB1->(DbSeek(xFilial("SB1") + SC6->C6_PRODUTO))   

				cGeraFin := Posicione("SF4", 1, FWxFilial("SF4")+ SC6->C6_TES, "SF4->F4_DUPLIC")

				If cGeraFin == "S"
					
					If U_ALAFAT06() .And. !Empty(M->C5_TABELA)

						nPrcTab := Posicione("DA1", 1, xFilial("DA1")+M->C5_TABELA + SB1->B1_COD, "DA1->DA1_PRCVEN")

						If nPrcTab != SC6->C6_PRCVEN

							lExec 	 := .T. //Regra Produto Industrial
							lExecSC5 := If (!lExecSC5, .T., lExecSC5)

							RecLock("SC6",.F.)
							SC6->C6_ZZBLOQ := If(lExec, "S", "N")
							SC6->(MsUnlock())

						EndIf

					ElseIf SB1->B1_ZZVALBA > 0 .And. SB1->B1_ZZCOEF > 0

						//Regra Produto Padrão                        
						nAuxCof := SB1->B1_ZZCOEF * If((1 - (nAuxICM / 100)) > 0, (1 - (nAuxICM / 100)), 1)	// Desconto Coeficiente * ICM
						nAuxVal := (SB1->B1_ZZVALBA * nAuxCof)												
						nAuxVal += ((nAuxVal * nCoefFin) / 100)												// Coeficiente financeiro

						RecLock("SC6",.F.)

						If SC6->C6_PRCVEN < nAuxVal .And. SA1->A1_EST != "EX"

							lExec 	 := .T.
							lExecSC5 := If (!lExecSC5, .T., lExecSC5)

						EndIf

						SC6->C6_ZZBLOQ 	:= If(lExec, "S", "N")	
						SC6->C6_ZZVLRCF	:= SC6->C6_PRCVEN - nAuxVal
						SC6->C6_ZZMARGE := ((SC6->C6_PRCVEN - nAuxVal) / nAuxVal) * 100		    	

						SC6->(MsUnlock())
					Else

						lExec 	 := .T.
						lExecSC5 := If (!lExecSC5, .T., lExecSC5)

						RecLock("SC6",.F.)
						SC6->C6_ZZBLOQ := If(lExec, "S", "N")
						SC6->(MsUnlock())	

					EndIf

				EndIf
				
			EndIf

			SC6->(DbSkip())

		EndDo

		// Bloquear pedido no cabeçalho
		DbSelectArea("SC5")

		SC5->(DbSetOrder(1))

		If SC5->(DbSeek(xFilial("SC5")+cPedido))

			RecLock("SC5",.F.)
			SC5->C5_ZZBLOQ := If(lExecSC5, "S", "N")
			SC5->(MsUnlock())

		EndIf

		// Bloquear pedido na liberação do pedido
		DbSelectArea("SC9")

		SC9->(DbSetOrder(1))

		If SC9->(DbSeek(xFilial("SC9") + cPedido))

			While SC9->(!EOF()) .And. SC9->C9_FILIAL == xFilial("SC9") .And. SC9->C9_PEDIDO == cPedido

				RecLock("SC9",.F.)
				SC9->C9_ZZBLOQ := If(lExecSC5, "S", "N")
				SC9->(MsUnlock())

				SC9->(DbSkip())

			EndDo

		EndIf    	

	EndIf 

	RestArea(aAreaSF4)
	RestArea(aAreaSE4)
	RestArea(aAreaSA1)
	RestArea(aAreaSC9)
	RestArea(aAreaSC6)
	RestArea(aArea)

Return Nil