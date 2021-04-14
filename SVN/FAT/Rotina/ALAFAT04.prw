#Include "Protheus.ch"
#Include "Parmtype.ch"

/*/{Protheus.doc} ALAFAT04

Rotina responsável pela verificação do bloqueio da regra comercial Alcar

@author 	Ectore Cecato - Totvs IP Jundiaí
@since 		27/08/2018
@version 	Protheus 12 - Faturamento

@return lógico, Informa se a linha está com bloqueado de regra comercial Alcar

/*/

User Function ALAFAT04()

	Local aArea 	:= GetArea()
	//Local aAreaSA1	:= SA1->(GetArea())
	//Local aAreaSE4	:= SE4->(GetArea())
	Local aAreaSB1	:= SB1->(GetArea())
	Local cProduto	:= aCols[n, GdFieldPos("C6_PRODUTO")]
	Local nPrcTab	:= 0
	Local lBloq		:= .F.
	
	If FunName()=="MATA410"
	
		If SB1->(DbSeek(xFilial("SB1") + cProduto))   
			
			If !Empty(M->C5_TABELA)
				nPrcTab := Posicione("DA1", 1, xFilial("DA1") + M->C5_TABELA + SB1->B1_COD, "DA1->DA1_PRCVEN")
			EndIf
			
			If nPrcTab > 0
	
				//nPrcTab := Posicione("DA1", 1, xFilial("DA1") + M->C5_TABELA + SB1->B1_COD, "DA1->DA1_PRCVEN")
	
				If nPrcTab != aCols[n, GdFieldPos("C6_PRCVEN")]
					
					lBloq := .T. //cBloq := "S"
					
					MsgAlert("Valor diverge da tabela de preço do cliente", "Atenção")
					
				EndIf
	
			ElseIf SB1->B1_ZZVALBA > 0 .And. SB1->B1_ZZCOEF > 0 
				
				nAuxVal := U_ALAFAT05(M->C5_CLIENT, M->C5_LOJACLI, M->C5_CONDPAG, cProduto, SB1->B1_ZZCOEF)
				
				aCols[n, GdFieldPos("C6_ZZMARGE")] := ((aCols[n, GdFieldPos("C6_PRCVEN")] - nAuxVal) / nAuxVal) * 100	
				//Regra Produto Padrão                        
				//nAuxCof := SB1->B1_ZZCOEF * If((1 - (nAuxICM / 100)) > 0, (1 - (nAuxICM / 100)), 1)	// Desconto Coeficiente * ICM
				//nAuxVal := (SB1->B1_ZZVALBA * nAuxCof)												
				//nAuxVal += ((nAuxVal * nCoefFin) / 100)		
														// Coeficiente financeiro
				//valor abaixo do minimo da tabela padrão
				If Round(aCols[n, GdFieldPos("C6_PRCVEN")], 2) < nAuxVal .And. SA1->A1_EST != "EX"
									
					lBloq := .T. //cBloq := "S"         
					
					MsgAlert("Valor abaixo do mínimo da tabela padrão", "Atenção")
					
				EndIf
	
			Else
			
				lBloq := .T.  //cBloq := "S"
				
				MsgAlert("Produto sem tabela de preço cadastrada", "Atenção")
				
			EndIf
	
		EndIf
	Endif
	RestArea(aAreaSB1)
	//RestArea(aAreaSE4)
	//RestArea(aAreaSA1)
	RestArea(aArea)
	
Return lBloq 