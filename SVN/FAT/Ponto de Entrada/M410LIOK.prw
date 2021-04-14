#Include "Protheus.ch"
#Include "ParmType.ch"

/*/{Protheus.doc} M410LIOK

Ponto de entrada responsável pela validação da linha do pedido de vendas

@author Ectore Cecato - Totvs IP (Jundiaí)
@since 13/11/2014
@version Protheus 11 - Faturamento

@return lógico, Indica se a linha é válida

/*/

User Function M410LIOK()

	Local nProcPrc	 	:= SuperGetMV("ZZ_PRCALC", .F., "6")
	Local nPosProd 	 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "C6_PRODUTO"})
	Local nPosPrcVen 	:= aScan(aHeader, {|x| AllTrim(x[2]) == "C6_PRCVEN"})
	Local nPosDel	 	:= Len(aHeader) + 1
	Local nPrcAlcar	 	:= Posicione("SB1", 1, xFilial("SB1") + aCols[n, nPosProd], "SB1->B1_ZZPRCAL")
	Local nVlrMinPrc 	:= If(nPrcAlcar > 0, nPrcAlcar - (nPrcAlcar * (nProcPrc / 100)), 0)
	
	If !aCols[n, nPosDel]
	
		If M->C5_ZZTPPED == "1" .And. nVlrMinPrc > 0 .And. aCols[n, nPosPrcVen] < nVlrMinPrc
			Aviso("Atenção", "O valor unitário do produto é menor que o valor mínimo cadastrado.", {"Ok"})
		EndIf
		
		If U_ALAFAT06()
			
			//Verifica se o item está bloqueado
			If FunName()=="MATA410"
				If U_ALAFAT04() 
					aCols[n, GdFieldPos("C6_ZZSTATU")] := "BR_VERMELHO"
				Else
					aCols[n, GdFieldPos("C6_ZZSTATU")] := "BR_VERDE"
				EndIf                  
			Endif
			
		EndIf
	
	EndIf
	
	GetDRefresh()
		
Return .T.