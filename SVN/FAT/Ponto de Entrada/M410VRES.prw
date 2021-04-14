#Include 'Protheus.ch'

/*/{Protheus.doc} M410VRES

Ponto de entrada utilizado para verificar se o campo C6_QTDEMP está preenchido corretamente

@type 		function
@author 	Ectore Cecato - Totvs Jundiaí
@since 		13/05/2016
@version 	Protheus 12 - Faturamento
 
@return lógico, Continua a eliminação de resíduo

/*/

User Function M410VRES()

	Local lUpdateSC5 	:= .F.
	Local cSalesOrder 	:= SC5->C5_NUM
	
	SC6->(DbSetOrder(1))
		
	If SC6->(DbSeek(xFilial("SC6")+cSalesOrder))
			
		While !SC6->(Eof()) .And. SC6->C6_FILIAL == xFilial("SC6") .And. SC6->C6_NUM == cSalesOrder
				
			If SC6->C6_QTDEMP != 0 .And. SC6->C6_QTDLIB == 0 .And. /*Empty(SC6->C6_NOTA) .And.*/ ;
			   !U_ExistSC9(SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO) .And. ;
			   !U_ExistSDC(SC6->C6_NUM, SC6->C6_ITEM, SC6->C6_PRODUTO)
						
				RecLock("SC6", .F.)
					SC6->C6_QTDEMP := 0
				SC6->(MsUnlock())
					
				lUpdateSC5 := .T.
						
			EndIf
				
			SC6->(DbSkip())
				
		EndDo
		
	EndIf
		
	If lUpdateSC5
			
		RecLock("SC5", .F.)
			SC5->C5_LIBEROK := ""
		SC5->(MsUnlock())
			
	EndIf		
		
Return .T.