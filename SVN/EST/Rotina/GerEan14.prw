#include "totvs.ch"

User Function GerEan14

	Local nSeq		:= 0
	Local cCod		:= ""
	    
	If !ExistBlock("DIGEAN")
		MsgStop("Favor compilar o programa DIGEAN antes de dar continuidade. Comunique o departamento de TI.","ERRO - GEREAN14")
		Return
	ElseIf Empty(SB1->B1_CODBAR)
		MsgStop("Favor informar o código de barras EAN13 (B1_CODBAR) no produto antes de gerar o EAN14.","ERRO - GEREAN14")
		Return
	ElseIf Len(Alltrim(SB1->B1_CODBAR)) <> 13
		MsgStop("Tamanho do código de barras EAN13 (B1_CODBAR) no produto não possui 13 posições. Favor verificar.","ERRO - GEREAN14")
		Return
	Endif
	
	If MsgYesNo("Deseja gerar um novo código EAN14 para o produto? (Tabela SLK)","GEREAN14")
	    
		Pergunte("GEREAN14",.F.)
		MV_PAR01 := SB1->B1_CONV
		
		If Pergunte("GEREAN14",.T.)
		
			// MV_PAR01 - Tipo N - Quantidade do novo código EAN14
	
			SLK->(dbSetOrder(2))
			SLK->(dbSeek(FwXFilial("SLK")+SB1->B1_COD))
			
			While SLK->(!eof()) .and. SLK->LK_CODIGO == SB1->B1_COD .and. SLK->LK_FILIAL == FwXFilial("SLK")
			
				If SLK->LK_QUANT == MV_PAR01
					MsgAlert("Já existe um EAN14 cadastrado com a quantidade informada. Favor verificar.", "ATENÇÃO - GEREAN14")
					Return
				Endif
				
				nSeq++
				SLK->(dbSkip())
			EndDo         
			
			nSeq++
			
			cCod	:= cValToChar(nSeq) + Left(Alltrim(SB1->B1_CODBAR),12)
			cCod	+= u_DigEan(cCod)
			
			Reclock("SLK",.T.)
				SLK->LK_FILIAL 	:= FwXFilial("SLK")
				SLK->LK_CODIGO 	:= SB1->B1_COD
				SLK->LK_CODBAR 	:= cCod
				SLK->LK_QUANT	:= MV_PAR01
			SLK->(MsUnlock())
			
			MsgInfo("EAN14 gerado com sucesso!","GEREAN14")
			
		Endif
	Endif

Return